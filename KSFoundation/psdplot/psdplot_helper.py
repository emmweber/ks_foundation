import numpy as np
import math
import warnings
warnings.filterwarnings("ignore", message="numpy.dtype size changed")


class Slice:
    start = 0

    def __init__(self, fields, parent):
        self.__dict__ = fields
        self.parent = parent
        self.start = Slice.start
        self.end = self.start + self.duration
        self.isSpatiallySelective = True
        if fields['slicethickness'] < 0:
            self.slicethickness = 10000.
            self.isSpatiallySelective = False
        Slice.start += fields['duration']
        self.isFiller = True if fields['excitationmode'] == 'KS_PLOT_NO_EXCITATION' else False

    def minCoverage(self):
        return min(self.slicepos) - self.slicethickness / 2.0

    def maxCoverage(self):
        return max(self.slicepos) + self.slicethickness / 2.0

    def __repr__(self):
        return self.description + ': ' + str(self.start) + ' -> ' + str(self.end)

    def __gt__(self, other):
        return self.end > other.end


class SliceGroup:
    index = 0

    def __init__(self, slices, parent, firstEventIsUseless=True):
        if firstEventIsUseless:
            del(slices[0])
        descriptionEvent = slices.pop(-1)
        self.description = descriptionEvent['groupdescription']
        self.slices = [Slice(s, self) for s in slices]
        self.sequences = list(set([s.description for s in self.slices]))
        self.parent = parent
        self.index = SliceGroup.index
        self.duration = sum([s.duration for s in self.slices])
        SliceGroup.index += 1
        Slice.start = 0
        self.slicerange = {'min': min([s.minCoverage() for s in self.slices if s.isSpatiallySelective] + [-10.]),
                           'max': max([s.maxCoverage() for s in self.slices if s.isSpatiallySelective] + [+10.])}

    def __repr__(self):
        return 'Slicegroup #' + str(self.index) + ' (' + self.parent.mode + ', ' + self.description + ')'


class Pass:
    allSequences = []
    largestRange = {'min': 0, 'max': 0}

    def __init__(self, mode, slicegroups):
        if mode == 'KS_PLOT_PASS_WAS_DUMMY':
            self.mode = 'Dummy'
        elif mode == 'KS_PLOT_PASS_WAS_CALIBRATION':
            self.mode = 'Calibration'
        else:
            self.mode = 'Acquisition'
        self.slicegroups = [SliceGroup(g, self) for g in slicegroups]
        self.duration = sum([g.duration for g in self.slicegroups])
        self.sequences = []
        [self.sequences.extend([s for s in g.sequences if s not in self.sequences]) for g in self.slicegroups]
        [Pass.allSequences.extend([seq for seq in self.sequences if seq not in Pass.allSequences])]
        self.largestRange = {'min': min([g.slicerange['min'] for g in self.slicegroups]),
                             'max': max([g.slicerange['max'] for g in self.slicegroups])}
        Pass.largestRange['min'] = min(Pass.largestRange['min'], self.largestRange['min'])
        Pass.largestRange['max'] = max(Pass.largestRange['max'], self.largestRange['max'])
        SliceGroup.index = 0

    def __repr__(self):
        return 'Pass (' + self.mode + ')'

    @classmethod
    def plotLimits(cls, paddingLevel=0.1):
        return {'min': cls.largestRange['min'],
                'max': cls.largestRange['max'],
                'padding': paddingLevel * max(abs(cls.largestRange['min']), abs(cls.largestRange['min']))}


class Wave:
    count = 0
    maxamp = {'x': 0,
              'y': 0,
              'z': 0,
              'r': 0,
              't': 0,
              'o': 0}
    minamp = {'x': 0,
              'y': 0,
              'z': 0,
              'r': 0,
              't': 0,
              'o': 0}

    # Instance variables
    start = 0.
    end = 0.
    description = ""
    board = []
    instances = 0
    duration = 0.
    waveform = []
    ampscale = 0.
    res = 0
    amp = []
    _tgt = False

    def __init__(self, fields):
        self.description = fields['description']
        self.instances = fields['instances']
        self.duration = fields['duration']
        self.start = [i['time'] for i in self.instances]
        self.board = [i['board'] for i in self.instances]
        self.ampscale = [i['ampscale'] for i in self.instances]
        self.rtscale = [i['rtscale'] for i in self.instances]
        self._tgt = "waveform" in self.instances[0]
        self.end = [self.duration + t for t in self.start]
        scales = [a * b for a, b in zip(self.ampscale, self.rtscale)]
        if self._tgt:
            self.waveform = [np.array(i['waveform']) for i in self.instances]
        else:
            self.waveform = [np.array(fields['waveform'])]
        signamp = []
        self.res = self.duration / (self.waveform[0].size - 2)  # ms
        for n in range(0, self.numInstances()):
            wf = self.waveform[n] if self._tgt else self.waveform[0]
            maxval = np.amax(np.outer(wf, scales))
            minval = np.amin(np.outer(wf, scales))
            Wave.maxamp[self.board[n]] = maxval if (maxval > Wave.maxamp[self.board[n]]) else Wave.maxamp[self.board[n]]
            Wave.minamp[self.board[n]] = minval if (minval < Wave.minamp[self.board[n]]) else Wave.minamp[self.board[n]]
            signamp.append(maxval if abs(maxval) >= abs(minval) else minval)
        self.amp = [signamp[i] * self.ampscale[i] * self.rtscale[i] for i in range(0, self.numInstances())]
        Wave.count += 1

    def __repr__(self):
        return (self.description + "(" + str(self.numInstances()) + ")")

    def __str__(self):
        return self.__repr__()

    def instanceTime(self, instance):
        if self._tgt:
            return np.append(self.start[instance], np.append(self.start[instance], np.append(np.linspace(self.start[instance], self.end[instance], num=self.waveform[instance].size - 2), self.end[instance])))
        else:
            return np.append(self.start[instance], np.append(self.start[instance], np.append(np.linspace(self.start[instance], self.end[instance], num=self.waveform[0].size - 2), self.end[instance])))

    def instanceWaveform(self, instance):
        if self._tgt:
            return self.ampscale[instance] * self.rtscale[instance] * self.waveform[instance]
        else:
            return self.ampscale[instance] * self.rtscale[instance] * self.waveform[0]

    def moments(self, inst, begin='start', stop='end', orders=[0, 1, 2]):
        moment = []
        if begin == 'start' and stop == 'end':
            waveform = self.instanceWaveform(inst)
        else:
            waveform = self.instanceWaveform(inst)[int(round(begin / self.duration * self.waveform[0].size)):int(round(stop / self.duration * self.waveform[0].size))]
        for order in orders:
            moment.append(1000 * self.res * np.array(list(Wave.calculateMagneticMoment(waveform, order, self.start[inst], self.res))))
        return moment

    def numInstances(self):
        return len(self.start)

    @staticmethod
    def calculateMagneticMoment(waveform, order, t0=0, dt=1):
        it = iter(waveform)
        total = 0
        for timeIndex, G in enumerate(it, start=1):
            total += G * ((timeIndex * dt + t0)**order)
            yield total


class RF:
    count = 0

    # Instance variables
    start = 0.
    end = 0.
    description = ""
    rfwave = None
    theta = None
    omega = None
    duration = 0.
    isodelay = 0.
    nominal_flipangle = 0.
    waveform = []
    flipangle = 0.
    role = ""
    max_b1 = 0.
    ampscale = []
    rtscale = []
    _tgt = False

    def __init__(self, description, fields):
        self.description = description
        self.instances = fields['instances']
        self.start = [i['time'] for i in self.instances]
        self.amp = fields['amp']
        self.duration = fields['duration']
        self.isodelay = fields['isodelay']
        self.nominal_flipangle = fields['nominal_flipangle']
        self.flipangle = fields['flipangle']
        self._tgt = "waveform" in self.instances[0]
        self.role = fields['role']
        self.max_b1 = fields['max_b1']
        self.ampscale = [i['ampscale'] for i in self.instances]
        self.rtscale = [i['rtscale'] for i in self.instances]
        self.end = [self.duration + t for t in self.start]
        self.theta = Wave(fields['theta']) if any(fields['theta']) else None
        self.omega = Wave(fields['omega']) if any(fields['omega']) else None
        if self._tgt:
            self.rfwave = Wave(
                {'description': description,
                 'instances': fields['instances'],
                 'duration': fields['duration'],
                 'board': ['r'] * len(fields['instances'])})
        else:
            self.rfwave = Wave(
                {'description': description,
                 'instances': fields['instances'],
                 'duration': fields['duration'],
                 'waveform': np.array(fields['waveform']) * self.flipangle / self.nominal_flipangle * self.max_b1,
                 'board': ['r'] * len(fields['instances'])})
        RF.count += 1

    def __repr__(self):
        return (self.description + "(" + str(len(self.start)) + "): " + str(self.start) + " -> " + str(self.end))

    def __str__(self):
        return self.__repr__()

    def instanceTime(self, instance):
        return np.append(np.linspace(self.start[instance], self.end[instance], num=self.rfwave.waveform[instance].size - 2), self.end[instance])

    def numThetaInstances(self):
        if self.theta is not None:
            return len(self.theta.start)
        else:
            return 0

    def numOmegaInstances(self):
        if self.omega is not None:
            return len(self.omega.start)
        else:
            return 0

    def numInstances(self):
        return len(self.start)

    def instanceWaveform(self, instance):
        if self._tgt:
            return self.flipangle / self.nominal_flipangle * self.max_b1 * self.ampscale[instance] * self.rtscale[instance] * self.rfwave.waveform[0]
        else:
            return self.flipangle / self.nominal_flipangle * self.max_b1 * self.ampscale[instance] * self.rtscale[instance] * self.rfwave.waveform[instance]


class Trapezoid:
    count = 0
    maxamp = {'x': 0,
              'y': 0,
              'z': 0,
              'r': 0,
              't': 0,
              'o': 0}
    minamp = {'x': 0,
              'y': 0,
              'z': 0,
              'r': 0,
              't': 0,
              'o': 0}

    # Instance variables
    start = 0
    end = 0
    amp = 0

    description = ""
    duration = 0
    board = None

    def __init__(self, description, fields):
        self.description = description
        self.instances = fields['instances']
        self.duration = fields['duration']
        self.rampup = fields['ramptime']
        self.plateau = fields['plateautime']
        self.duration = fields['duration']
        self.rampdown = self.duration - self.rampup - self.plateau

        self.start = [i['time'] for i in self.instances]
        self.board = [i['board'] for i in self.instances]
        self.ampscale = [i['ampscale'] for i in self.instances]
        self.rtscale = [i['rtscale'] for i in self.instances]
        self._tgt = "waveform" in self.instances[0]
        self.end = [self.duration + t for t in self.start]
        self.plateaustart = [self.start[i] + self.rampup for i in range(0, self.numInstances())]
        sign = [1 if (fields['amp'] * self.ampscale[i] * self.rtscale[i]) > 0 else -1 for i in range(0, self.numInstances())]
        self.amp = [sign[i] * abs(self.rtscale[i]) * abs(self.ampscale[i]) * abs(fields['amp']) for i in range(0, self.numInstances())]
        for n in range(0, self.numInstances()):
            if (Trapezoid.maxamp[self.board[n]] < self.amp[n]):
                Trapezoid.maxamp[self.board[n]] = self.amp[n]
            if (Trapezoid.minamp[self.board[n]] > self.amp[n]):
                Trapezoid.minamp[self.board[n]] = self.amp[n]
        Trapezoid.count += 1

    def displayCount(self):
        print "Total Trapezoidz: %d" % Trapezoid.count

    def rampArea(self):
        return self.rampup * self.amp / 2000

    def plateauArea(self):
        return self.plateau * self.amp / 1000

    def __repr__(self):
        return (self.description + "(" + str(self.numInstances()) + ")")

    def __str__(self):
        return self.__repr__()

    def totalArea(self):
        return 2 * self.rampArea() + self.plateauArea()

    def numRasterPoints(self, part="total"):
        if part == "total":
            return round(1000 * (self.end[0] - self.start[0]))
        elif part == "plateau":
            return round(1000 * self.plateau)
        elif part == "attack":
            return round(1000 * self.rampup)
        elif part == "decay":
            return round(1000 * self.rampdown)
        elif part == "toStart":
            return round(1000 * self.start[0])
        else:
            return 0

    def rasterize(self, inst, dt=1):
        numAttk = self.numRasterPoints(part="attack") / dt
        numPlat = self.numRasterPoints(part="plateau") / dt
        numDecy = self.numRasterPoints(part="decay") / dt
        attk = np.linspace(0, self.amp[inst], numAttk)
        plateau = np.linspace(self.amp[inst],
                              self.amp[inst],
                              numPlat)
        decay = np.linspace(self.amp[inst],
                            0,
                            numDecy)
        return np.concatenate((attk, plateau, decay))

    def getPlotNodes(self, inst):
        times = [self.start[inst] + t for t in [0, self.rampup, self.rampup + self.plateau, self.duration]]
        amps = [0, self.amp[inst], self.amp[inst], 0]
        return times, amps

    def instanceTime(self, inst, dt=1):
        return np.arange(self.start[inst], self.end[inst], step=dt)

    def moments(self, inst, begin='start', stop='end', orders=[0, 1, 2], dt=1):
        if begin == 'start' and stop == 'end':
            rasterized = self.rasterize(inst, dt)
        else:
            rasterized = self.rasterize(inst, dt)[int(round(begin * 1000 / dt)):int(round(stop * 1000 / dt))]
        moment = []
        for order in orders:
            moment.append(np.array(list(Wave.calculateMagneticMoment(rasterized, order, self.start[inst], dt / 1000.0))))
        return moment

    def numInstances(self):
        return len(self.start)

    @classmethod
    def timepointsBetweenWaveforms(base, first, second, dt=1):
        return np.zeros(round(1000 / dt * (second.start - first.end)))
