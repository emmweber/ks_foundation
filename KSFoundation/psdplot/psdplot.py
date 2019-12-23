# -*- coding: utf-8 -*-
from collections import OrderedDict
import numpy as np
import math
from operator import itemgetter
import os
import psdplot_helper as helper
import json
import argparse
from bokeh.layouts import gridplot, column, row, layout, widgetbox
from bokeh.plotting import figure, output_file, show, save
from bokeh.models import BoxZoomTool, HoverTool, TapTool, Range1d, Span, Line, ColumnDataSource, Div, CustomJSHover, LinearColorMapper
from bokeh.models.glyphs import MultiLine
from bokeh.models.widgets import Toggle, Slider, Panel, Tabs, Button, CheckboxButtonGroup
from bokeh.models.callbacks import CustomJS
from bokeh.models.axes import LinearAxis
from bokeh.palettes import viridis
from time import localtime, strftime

colors = {'rampsampled': "#FF198C",
          'samplewindow': "#FF1919",
          'excitation': "#2A6022",
          'refocusing': "#D552E5",
          'chemsat': "#FF0000",
          'spsat': "#AAAAAA",
          'inversion': "#00FFAA",
          'ssitime': "#FFFF99",
          'trfill': "#DDFF99",
          'lines': "#4545ad",
          'hoveredlines': "#23235b",
          'spanhover': "#9ACD32",
          'spantap': "#6B8E23",
          'spandoubleTap': "556B2F",
          'zeromoment': "#909046",
          'firstmoment': "#a66a6a",
          'secondmoment': "#6aa66a"}

colorFromRole = {
    'KS_RF_ROLE_EXC': colors['excitation'],
    'KS_RF_ROLE_REF': colors['refocusing'],
    'KS_RF_ROLE_CHEMSAT': colors['chemsat'],
    'KS_RF_ROLE_INV': colors['inversion'],
    'KS_RF_ROLE_SPSAT': colors['spsat']
}


def emptyBoardDict():
    return {'x': [],
            'y': [],
            'z': [],
            'r': [],
            't': [],
            'o': []}


def emptyBoardInstructions():
    return {'waves': {},
            'trapz': {},
            'rf': {},
            'acquisitions': []}


def activeBoards(objects):
    usedboards = ['x', 'y', 'z', 'r']
    for board in ['t', 'o']:
        for frame in objects:
            if frame[board]:
                usedboards.append(board)
    return usedboards


# Sorts board instructions by time
def sortedBoards(boardinstructions):
    numframes = len(boardinstructions)
    objs = [emptyBoardDict() for _ in range(numframes)]
    # Sort instructions by time
    for frame, frameInstructions in enumerate(boardinstructions):
        for n, desc in enumerate(frameInstructions['trapz']):
            trap = frameInstructions['trapz'][desc]
            for inst in range(0, trap.numInstances()):
                objs[frame][trap.board[inst]].append({
                    'description': trap.description,
                    'start': trap.start[inst],
                    'instanceId': inst,
                    'type': "trapz",
                    'end': trap.end[inst]})
        for n, desc in enumerate(frameInstructions['waves']):
            wave = frameInstructions['waves'][desc]
            for inst in range(0, wave.numInstances()):
                objs[frame][wave.board[inst]].append({
                    'description': wave.description,
                    'start': wave.start[inst],
                    'instanceId': inst,
                    'type': "waves",
                    'end': wave.end[inst]})
        for rfId, desc in enumerate(frameInstructions['rf']):
            rf = frameInstructions['rf'][desc]
            for inst in range(0, rf.numInstances()):
                objs[frame]['r'].append({
                    'description': rf.description,
                    'start': rf.start[inst],
                    'instanceId': inst,
                    'type': "rf",
                    'end': rf.end[inst]})
            if rf.omega is not None:
                for inst in range(0, rf.omega.numInstances()):
                    objs[frame]['o'].append({
                        'description': rf.omega.description,
                        'start': rf.omega.start[inst],
                        'instanceId': inst,
                        'type': "rf.omega",
                        'end': rf.omega.end[inst]})
            if rf.theta is not None:
                for inst in range(0, rf.theta.numInstances()):
                    objs[frame]['t'].append({
                        'description': rf.theta.description,
                        'start': rf.theta.start[inst],
                        'instanceId': inst,
                        'type': "rf.theta",
                        'end': rf.theta.end[inst]})
        for board in emptyBoardDict():
            objs[frame][board] = sorted(objs[frame][board], key=itemgetter('start'))
    return objs


def deactivateSelectionGlyph(rendererList):
    for renderer in rendererList.values():
        if renderer:
            renderer.nonselection_glyph = renderer.glyph


def plotPlan(plan):
    if not plan:
        return
    yrange = Range1d(max(plan['ky'].flatten()) + .5, -.5)
    colors = {'shots': viridis(min(256, plan['shots'])),
              'readout': viridis(min(256, plan['etl']))}
    mapper = {'shots': LinearColorMapper(palette=colors['shots'], low=0, high=plan['shots']),
              'readout': LinearColorMapper(palette=colors['readout'], low=0, high=plan['etl'])}
    planFig = figure(title='Phase encoding plan',
                     plot_width=500,
                     tools="",
                     plot_height=500,
                     background_fill_color="#CCCCCC")
    figs = [planFig]
    hover = HoverTool(toggleable=False)
    if plan["is3d"]:
        planFig.title.text = '3D phase encoding plan "{}"'.format(plan['description'])
        xrange = Range1d(-.5, max(plan['kz'].flatten()) + .5)
        plan_data = {'shot': [],
                     'ky': [],
                     'kz': [],
                     'readout': []}
        for shot in range(plan['shots']):
            plan_data['shot'].extend(np.array([shot] * plan['etl']).flatten())
            plan_data['ky'].extend(np.array(plan['ky'][shot]).flatten())
            plan_data['kz'].extend(np.array(plan['kz'][shot]).flatten())
            plan_data['readout'].extend(range(0, plan['etl']))
        planCDS = ColumnDataSource(data=plan_data)
        rect_renderer = planFig.rect(
            x='kz',
            y='ky',
            width=1,
            height=1,
            line_color=None,
            dilate=True,
            source=planCDS,
            fill_color={'field': 'shot', 'transform': mapper['shots']})
        planFig.y_range = yrange
        planFig.x_range = xrange
        planFig.xaxis.axis_label = 'kz'
        planFig.yaxis.axis_label = 'ky'
        hover.tooltips = [
            ("ky/kz", "@ky/@kz"),
            ("Shot", "@shot"),
            ("Readout", "@readout")
        ]
        clicked_plan_cb = CustomJS(
            args={
                'renderer': rect_renderer,
                'mapper': mapper,
                'source': planCDS,
                'fig': planFig},
            code="""
if (renderer["glyph"]["fill_color"]["field"] == "shot") {
    renderer["glyph"]["fill_color"]["field"] = "readout"
    renderer["glyph"]["fill_color"]["transform"] = mapper['readout']
    fig.title.text = '3D phasenencoding plan - Readout'
} else {
    renderer["glyph"]["fill_color"]["field"] = "shot"
    renderer["glyph"]["fill_color"]["transform"] = mapper['shots']
    fig.title.text = '3D phasenencoding plan - Shots'
}
source.change.emit()
""")
        planFig.js_on_event('tap', clicked_plan_cb)
    else:
        planFig.title.text = '2D phase encoding plan "{}"'.format(plan['description'])
        xrange = Range1d(-.5, plan['shots'] - .5)
        plan_data = {'shot': [],
                     'ky': [],
                     'readout': [],
                     'collapsed': [0] * (plan['shots'] * plan['etl'])}
        for shot in range(plan['shots']):
            plan_data['shot'].extend(np.array([shot] * plan['etl']).flatten())
            plan_data['ky'].extend(np.array(plan['ky'][shot]).flatten())
            plan_data['readout'].extend(range(0, plan['etl']))
        planCDS = ColumnDataSource(data=plan_data)
        rect_renderer = planFig.rect(
            x='shot',
            y='ky',
            width=1,
            height=1,
            line_color=None,
            dilate=True,
            source=planCDS,
            fill_color={'field': 'readout',
                        'transform': mapper['readout']} if plan['etl'] > 1 else "#fdf5e6")
        planFig.y_range = yrange
        planFig.x_range = xrange
        planFig.xaxis.axis_label = 'Shot'
        planFig.yaxis.axis_label = 'ky'
        if plan['shots'] == 1:
            planFig.xaxis.major_label_text_color = None
            planFig.xaxis.major_tick_line_color = None
            planFig.xaxis.minor_tick_line_color = None
            planFig.xaxis.axis_label = 'Single shot'
        hover.tooltips = [
            ("ky", "@ky"),
            ("Shot", "@shot"),
            ("Readout", "@readout")
        ]
        # Collapsed view of ky
        collapsedFig = figure(
            title='Combined shots',
            plot_width=150,
            tools="",
            plot_height=500,
            background_fill_color="#CCCCCC")
        collapsed_renderer = collapsedFig.rect(
            x='collapsed',
            y='ky',
            width=1,
            height=1,
            line_color=None,
            dilate=True,
            source=planCDS,
            fill_color={'field': 'readout',
                        'transform': mapper['readout']} if plan['etl'] > 1 else "#fdf5e6")
        collapsedFig.x_range = Range1d(-.5, .5)
        collapsedFig.y_range = yrange
        collapsedFig.title.text_font_size['value'] = '8pt'
        collapsedFig.xgrid.visible = False
        collapsedFig.ygrid.visible = False
        collapsedFig.xaxis.visible = False
        figs.append(collapsedFig)
    for fig in figs:
        fig.toolbar.logo = None
        fig.add_tools(hover)
        fig.yaxis[0].axis_label_text_font_style = 'normal'
        fig.yaxis[0].axis_label_text_font_size = '13pt'
        fig.yaxis[0].major_label_text_font_size = '13pt'
        fig.yaxis[0].ticker.num_minor_ticks = 0
    planFig.xgrid.visible = False
    planFig.ygrid.visible = False
    planFig.xaxis[0].axis_label_text_font_size = '13pt'
    planFig.xaxis[0].axis_label_text_font_style = 'normal'
    planFig.xaxis.major_label_text_font_size = '13pt'
    planFig.xaxis[0].ticker.num_minor_ticks = 0
    return figs


def saveBokeh(figures, divs, togglebox, filename, title, plans, svgname=''):
    template = """
{% block preamble %}
<style>
    .plot_info_left {
        background-color: #EFF7FE;
        padding: 5px;
        width: inherit;
    }
    .plot_info_center {
        background-color: #e8fff3;
        padding: 5px;
        width: inherit;
    }
    .plot_info_right {
        background-color: #f7feef;
        padding: 5px;
        width: inherit;
    }
    .plot_widgets { float: right; }
</style>
<script type="text/javascript">
    window.unitsFromBoard=function(board) {
      if (["x", "y", "z"].indexOf(board) >= 0) {
        return 'G/cm';
      } else if (board === "t") {
        return 'deg';
      } else if (board === "r") {
        return 'G';
      } else
        return 'a.u';
    }

    window.trapArea=function(time, amplitude) {
        let rampuptime = time[1] - time[0]
        let rampdowntime = time[3] - time[2]
        let plateautime = time[2] - time[1]
        return (amplitude * (rampuptime / 2.0 + rampdowntime / 2.0 + plateautime))
    }

    window.trapDescription=function(traps, idx) {
        var starttime = traps.data['time'][idx][0]
        var endtime = traps.data['time'][idx][3]
        var desc = traps.data['description'][idx]
        var amplitude = traps.data['amp'][idx][1]
        var board = traps.data['board'][idx]
        var ramptime = traps.data['time'][idx][1] - traps.data['time'][idx][0]
        var rampdowntime = traps.data['time'][idx][3] - traps.data['time'][idx][2]
        var plateautime = traps.data['time'][idx][2] - traps.data['time'][idx][1]
        var area = window.trapArea(traps.data['time'][idx], amplitude)
        var slewrate = amplitude / ramptime
        var duration = endtime - starttime
        var units = window.unitsFromBoard(board)
        return '<font size="+2"><b>' + desc                  + '</b></font><br>' + '<font color="#A33AFF"> KS_TRAP</font>' + '<br>' +
               '<b>Start</b>: '     + starttime.toFixed(3)   + ' ms<br>' +
               '<b>Duration</b>: '  + duration.toFixed(3)    + ' ms<br>' +
               '<b>Plateau</b>: '   + plateautime.toFixed(3) + ' ms<br>' +
               '<b>End</b>: '       + endtime.toFixed(3)     + ' ms<br>' +
               '<b>Ramptime</b>: '  + ramptime.toFixed(3)    + ' ms<br>' +
                ((Math.round(ramptime*1000) == Math.round(rampdowntime*1000)) ? '' : ('<b><font color="#FFA07A">Rampdown</b>: ' + rampdowntime.toFixed(3) + ' ms</font><br>')) +
               '<b>Area</b>: '      + area.toFixed(3)        + ' (' + units + ')*ms' + '<br>' +
               '<b>Amplitude</b>: ' + amplitude.toFixed(3)   + ' ' + units + '<br>' +
               '<b>Slewrate</b>: ' + slewrate.toFixed(3)    + ' (' + units + ')/ms' + '<br>'
    }

    window.waveDescription=function(waves, idx) {
        var desc = waves.data['description'][idx]
        var ampmax = Math.max(...waves.data['amp'][idx])
        var ampmin = Math.min(...waves.data['amp'][idx])
        var starttime = waves.data['time'][idx][0]
        var endtime = waves.data['time'][idx][ waves.data['time'][idx].length -1 ]
        var duration = endtime - starttime
        var board = waves.data['board'][idx]
        var units = window.unitsFromBoard(board)
        return '<font size="+2"><b>' + desc + '</b></font><br>' + '<font color="#A33AFF"> KS_WAVE</font>' + '<br>' +
               '<b>Start</b>: ' + starttime.toFixed(3) + ' ms<br>' +
               '<b>Duration</b>: ' + duration.toFixed(3) + ' ms<br>' +
               '<b>End</b>: ' + endtime.toFixed(3) + ' ms<br>' +
               '<b>Amplitude</b>: ' + ampmax.toFixed(3) + ' / ' + ampmin.toFixed(3) + ' ' + units + '<br>'
    }

    window.rfDescription=function(rf, idx) {
        var desc = rf.data['description'][idx]
        var role = rf.data['role'][idx]
        var max_b1 = rf.data['max_b1'][idx]
        var flipangle = rf.data['flipangle'][idx]
        var instanceFlipangle = flipangle * rf.data['ampscale'][idx]
        var ampmax = Math.max(...rf.data['amp'][idx])
        var ampmin = Math.min(...rf.data['amp'][idx])
        var starttime = rf.data['time'][idx][0]
        var endtime = rf.data['time'][idx][ rf.data['time'][idx].length -1 ]
        var duration = endtime - starttime
        var units = window.unitsFromBoard('r')
        return '<font size="+2"><b>' + desc + '</b></font><br>' + '<font color="#A33AFF"> KS_RF</font>' + '<br>' +
               '<b>Start</b>: ' + starttime.toFixed(3) + ' ms<br>' +
               '<b>Duration</b>: ' + duration.toFixed(3) + ' ms<br>' +
               '<b>End</b>: ' + endtime.toFixed(3) + ' ms<br>' +
               '<b>Flipangle</b>: ' + flipangle.toFixed(1) + ' deg<br>' +
               '<b>Instance flipangle</b>: ' + instanceFlipangle.toFixed(1) + ' deg<br>' +
               '<b>Role</b>: ' + role + '<br>' +
               '<b>Max B1</b>: ' + max_b1 + units +'<br>' +
               '<b>Amplitude</b>: ' + ampmax.toFixed(3) + ' / ' + ampmin.toFixed(3) + ' ' + units + '<br>'
    }

    window.acqDescription=function(acq, idx) {
        var desc = acq.data['description'][idx]
        var starttime = acq.data['time'][idx]
        var duration = acq.data['duration'][idx]
        var samples = acq.data['samples'][idx]
        var rbw = acq.data['rbw'][idx]
        var endtime = starttime + duration
        return '<font size="+2"><b>' + desc + '</b></font><br>' + '<font color="#A33AFF"> KS_READ</font>' + '<br>' +
               '<b>Start</b>: ' + starttime.toFixed(3) + ' ms<br>' +
               '<b>Duration</b>: ' + duration.toFixed(3) + ' ms<br>' +
               '<b>End</b>: ' + endtime.toFixed(3) + ' ms<br>' +
               '<b>Samples</b>: ' + samples.toFixed(0) + '<br>' +
               '<b>rBW</b>: ' + rbw.toFixed(2) + '  kHz<br>'
    }

    window.durationDescription=function(durations, idx) {
        var duration = durations.data['width'][idx]
        var starttime = durations.data['xcenter'][idx] - duration / 2
        var endtime = starttime + duration
        var desc = durations.data['name'][idx]
        var color = durations['data']['color'][idx]
        return '<font size="+2"><span style="background-color: ' + color + '"><b>' + desc + '</b></span></font><br>' +
               '<b>Start</b>: ' + starttime.toFixed(3) + ' ms<br>' +
               '<b>Duration</b>: ' + duration.toFixed(3) + ' ms<br>' +
               '<b>End</b>: ' + endtime.toFixed(3) + ' ms<br>'
    }

    window.metadataDescription=function(metadata) {
        return '<font size="+2"><b>Metadata</b></font>'                          + '<br>' +
               '<b>Duration</b>: '         + metadata['duration'].toFixed(3)     + ' ms<br>' +
               '<b>Minimum duration</b>: ' + metadata['min_duration'].toFixed(3) + ' ms<br>' +
               '<b>Minimum TR</b>: '        + metadata['optr_desc']               + '<br>' +
               '<b>SSI Time</b>: '         + metadata['ssi_time'].toFixed(3)     + ' ms<br>' +
               '<b>Sequence</b>: '         + metadata['sequence']                + '<br>' +
               '<b>PSD name</b>: '         + metadata['psdname']                 + '<br>'
    }

    window.setSpanPosition=function(spans, start, end) {
        for (i = 0; i < spans['left'].length; i++) {
            spans['left'][i].location = start;
            spans['right'][i].location = end;
        }
    }


    window.compareObjects=function(obj1, obj2) {
        if (obj1.board === obj2.board && obj1.time[0] == obj2.time[0] && obj1.description == obj2.description) {
            return ''
        }
        if (typeof obj1.time != "object") {
            obj1.time = [obj1.time, obj1.time + obj1.duration]
        }
        if (typeof obj2.time != "object") {
            obj2.time = [obj2.time, obj2.time + obj2.duration]
        }
        let startDiff = (obj1.time[0] - obj2.time[0]).toFixed(3)
        let startFirst = (startDiff < 0) ? obj1 : obj2
        let startSecond = (startDiff < 0) ? obj2 : obj1
        let returnStrings = []
        if (Math.abs(startDiff) > 0) {
            returnStrings.push('<b>' + startFirst.description + '</b>' + ' starts ' + Math.abs(startDiff).toFixed(3) + ' ms before ' + '<b>' + startSecond.description + '</b>')
        } else {
            returnStrings.push('<b>' + startFirst.description + '</b>' + ' starts synchronously with ' + '<b>' + startSecond.description + '</b>')
        }
        let endDiff = (obj1.time.slice(-1)[0] - obj2.time.slice(-1)[0]).toFixed(3)
        endFirst = (endDiff < 0) ? obj1 : obj2
        endSecond = (endDiff < 0) ? obj2 : obj1
        if (Math.abs(endDiff) > 0) {
            returnStrings.push('<b>' + endFirst.description + '</b>' + ' ends ' + Math.abs(endDiff).toFixed(3) + ' ms before ' + '<b>' + endSecond.description + '</b> ends')
        } else {
            returnStrings.push('<b>' + endFirst.description + '</b>' + ' ends synchronously with ' + '<b>' + endSecond.description + '</b>')
        }

        let timeBetween = startSecond.time[0] - endFirst.time.slice(-1)[0]
        if (timeBetween.toFixed(3) > 0.005) {
            returnStrings.push('<b>' + obj1.description + '</b> and <b>' + obj2.description + '</b> are ' + timeBetween.toFixed(3) + ' ms apart')
        } else {
            returnStrings.push('<b>' + obj1.description + '</b> and <b>' + obj2.description + '</b> are overlapping ' + Math.abs(timeBetween).toFixed(3) + ' ms')
        }

        if (obj1.type == "trap" && obj2.type == "trap") {
            units1 = window.unitsFromBoard(obj1.board)
            units2 = window.unitsFromBoard(obj2.board)
            if (units1 == units2) {
                let area1 = Math.abs(window.trapArea(obj1.time, obj1.amp[1]))
                let area2 = Math.abs(window.trapArea(obj2.time, obj2.amp[1]))
                let areaDiff = area1 - area2
                firstObj = (areaDiff < 0) ? obj2 : obj1
                secondObj = (areaDiff < 0) ? obj1 : obj2
                let printArea = Math.abs(area1 - area2).toFixed(3)
                if (printArea == 0) {
                    returnStrings.push('Area is equal')
                } else {
                    returnStrings.push('Area of <b>' + firstObj.description + '</b> is ' + printArea + ' (' + units1 + ')*ms larger than <b>' + secondObj.description + '</b>')
                }
            }
        }
        return returnStrings.join("<br>")
    }
</script>
{% endblock %}
"""
    output_file(filename=filename, mode='inline')
    rows = [row(gridplot([f for f in figures.values()], ncols=1, toolbar_location="below", toolbar_options=dict(logo=None)),
                column(togglebox, divs['left'], divs['center'], divs['right']))]
    for plan in plans:
        rows.append(plan)
    l = layout(rows)
    save(l, filename=filename, template=template, title=title)
    if svgname:
        from bokeh.io import export_svgs
        for f in figures.values():
            f.output_backend = "svg"
        for plan in plans[0]:
            plan.output_backend = "svg"
        arow = row([f for f in figures.values()])
        export_svgs(l, filename=svgname)


def plotBokehFrame(figs, sources, metadata, spans, divs):
    renderers = {b: {item: [] for item in sources[figs.items()[0][0]]} for b in figs.keys()}
    someboard = figs.items()[0][0]
    for board, fig in figs.iteritems():
        renderers[board]['trap'] = fig.multi_line(xs="time",
                                                  ys="amp",
                                                  line_color=colors['lines'],
                                                  line_alpha=0.75,
                                                  line_width=1.5,
                                                  name='trap',
                                                  hover_line_color=colors['hoveredlines'],
                                                  hover_line_alpha=1, source=sources[board]['traps'])
        renderers[board]['acq'] = fig.rect(x="xcenter",
                                           y="ycenter",
                                           width="duration",
                                           height="amp",
                                           line_color='black',
                                           line_dash='dotted',
                                           line_alpha=0.5,
                                           line_width=.1,
                                           name='rf',
                                           fill_color='color',
                                           fill_alpha=0.4,
                                           hover_line_color=colors['hoveredlines'],
                                           source=sources[board]['acq'])
        renderers[board]['waves'] = fig.multi_line(xs="time",
                                                   ys="amp",
                                                   line_color=colors['lines'],
                                                   line_alpha=0.75,
                                                   line_width=1.5,
                                                   name='wave',
                                                   hover_line_color=colors['hoveredlines'],
                                                   hover_line_alpha=1, source=sources[board]['waves'])
        renderers[board]['rf'] = fig.multi_line(xs="time",
                                                ys="amp",
                                                line_color=colors['lines'],
                                                line_alpha=0.75,
                                                line_width=1.5,
                                                name='rf',
                                                hover_line_color=colors['hoveredlines'],
                                                hover_line_alpha=1, source=sources[board]['rf'])
        renderers[board]['durations'] = fig.rect(x="xcenter",
                                                 y="ycenter",
                                                 width="width",
                                                 height="height",
                                                 line_color='black',
                                                 line_dash='solid',
                                                 line_alpha=1,
                                                 line_width=.1,
                                                 dilate=True,
                                                 name='name',
                                                 fill_color='color',
                                                 fill_alpha=0.5,
                                                 source=sources[board]['durations'])
        renderers[board]['zeros'] = fig.multi_line(xs="time",
                                                   ys="amp",
                                                   line_color=colors['lines'],
                                                   line_alpha=0.75,
                                                   line_width=1.5,
                                                   name='zero',
                                                   hover_line_color=colors['hoveredlines'],
                                                   hover_line_alpha=1, source=sources[board]['zeros'])
        if board in ["x", "y", "z"]:
            for order, desc in enumerate(['zeromoment', 'firstmoment', 'secondmoment']):
                maxval = max(sources[board][desc].data['moment'])
                minval = min(sources[board][desc].data['moment'])
                rangemax = max(abs(maxval), abs(minval))
                fig.extra_y_ranges.update({desc: Range1d(start=-1.1 * rangemax,
                                                         reset_start=-1.1 * rangemax,
                                                         reset_end=1.1 * rangemax,
                                                         end=1.1 * rangemax)})
                fig.add_layout(LinearAxis(y_range_name=desc,
                                          axis_line_color=colors[desc],
                                          major_tick_line_color=colors[desc],
                                          minor_tick_line_color=colors[desc]), 'right')
                renderers[board][desc] = fig.line(x="time",
                                                  y="moment",
                                                  line_color=colors[desc],
                                                  line_alpha=.75,
                                                  line_width=1.5,
                                                  visible=False,
                                                  name=desc,
                                                  y_range_name=desc,
                                                  source=sources[board][desc])
                renderers[board][desc].hover_glyph = renderers[board][desc].glyph

        renderers[board]['zeros'].hover_glyph.line_width = 2.5
        renderers[board]['trap'].hover_glyph.line_width = 2.5
        renderers[board]['waves'].hover_glyph.line_width = 2.5
        renderers[board]['rf'].hover_glyph.line_width = 2.5
        clicked_cb = CustomJS(
            args={
                'waves': renderers[board]['waves'].data_source,
                'traps': renderers[board]['trap'].data_source,
                'rf': renderers[board]['rf'].data_source,
                'acq': renderers[board]['acq'].data_source,
                'durations': renderers[board]['durations'].data_source,
                'metadata': metadata,
                'spans': spans,
                'divs': divs},
            code="""
var traphit = traps.selected.indices.length > 0
var wavehit = waves.selected.indices.length > 0
var rfhit = rf.selected.indices.length > 0
var acqhit = acq.selected.indices.length > 0
var durationhit = durations.selected.indices.length > 0
if (traphit) {
    var idx = traps.selected.indices[0]
    var starttime = traps.data['time'][idx][0]
    var endtime = traps.data['time'][idx][3]
    divs['center'].text = window.trapDescription(traps, idx);
    window.setSpanPosition(spans['tap'], starttime, endtime);
    window.lastClicked = {}
    for (var k in traps.data) {
        window.lastClicked[k] = traps.data[k][idx]
    }
    window.lastClicked['type'] = "trap"
    for (i = 0; i < acq.data['description'].length; i++) {
        acqStart = acq.data['time'][i]
        acqEnd = acqStart + acq.data['duration'][i]
        if (endtime >= acqEnd && starttime <= acqStart) {
            divs['center'].text += '<br>' + window.acqDescription(acq, i)
        }
    }
} else if (wavehit) {
    var idx = waves.selected.indices[0]
    var starttime = waves.data['time'][idx][0]
    var endtime = waves.data['time'][idx][waves.data['time'][idx].length -1]
    divs['center'].text = window.waveDescription(waves, idx)
    window.lastClicked = {}
    for (var k in waves.data) {
        window.lastClicked[k] = waves.data[k][idx]
    }
    window.lastClicked['type'] = "wave"
    window.setSpanPosition(spans['tap'], starttime, endtime);
    for (i = 0; i < acq.data['description'].length; i++) {
        acqStart = acq.data['time'][i]
        acqEnd = acqStart + acq.data['duration'][i]
        if (endtime >= acqEnd && starttime <= acqStart) {
            divs['center'].text += '<br>' + window.acqDescription(acq, i)
        }
    }
} else if (rfhit) {
    var idx = rf.selected.indices[0]
    var starttime = rf.data['time'][idx][0]
    var endtime = rf.data['time'][idx][rf.data['time'][idx].length -1]
    window.lastClicked = {}
    for (var k in rf.data) {
        window.lastClicked[k] = rf.data[k][idx]
    }
    window.lastClicked['type'] = "rf"
    divs['center'].text = window.rfDescription(rf, idx);
    window.setSpanPosition(spans['tap'], starttime, endtime);
} else if (acqhit) {
    var idx = acq.selected.indices[0]
    var starttime = acq.data['time'][idx]
    var endtime = starttime + acq.data['duration'][idx]
    window.lastClicked = {}
    for (var k in acq.data) {
        window.lastClicked[k] = acq.data[k][idx]
    }
    window.lastClicked['type'] = "acq"
    divs['center'].text = window.acqDescription(acq, idx);
    window.setSpanPosition(spans['tap'], starttime, endtime);
} else if (durationhit) {
    var idx = durations.selected.indices[0]
    var duration = durations.data['width'][idx]
    var starttime = durations.data['xcenter'][idx] - duration / 2
    window.lastClicked = {}
    window.lastClicked['type'] = "duration"
    var endtime = starttime + duration
    divs['center'].text = window.durationDescription(durations, idx) + '<br>' + window.metadataDescription(metadata)
    window.setSpanPosition(spans['tap'], starttime, endtime);
}
            """)
        hover_cb = CustomJS(
            args={
                'waves': renderers[board]['waves'].data_source,
                'traps': renderers[board]['trap'].data_source,
                'rf': renderers[board]['rf'].data_source,
                'acq': renderers[board]['acq'].data_source,
                'durations': renderers[board]['durations'].data_source,
                'metadata': metadata,
                'spans': spans,
                'divs': divs
            },
            code="""
idx = cb_data.index['1d'].indices
var starttime = -1
var endtime = -1
var hovertext = ''
var found = false
var trapidx = traps.inspected.indices[0]
var waveidx = waves.inspected.indices[0]
var rfidx   = rf.inspected.indices[0]
var acqidx  = acq.inspected.indices[0]
var durationidx  = durations.inspected.indices[0]
if (idx.length) {
    var xhit = cb_data.geometry['x']
    var hitidx = idx[0]
    if (hitidx < traps.data['description'].length) {
        starttime = traps.data['time'][hitidx][0]
        endtime = traps.data['time'][hitidx][3]
        if (xhit <= endtime && xhit >= starttime) {
            window.lastHovered = {}
            for (var k in traps.data) {
                window.lastHovered[k] = traps.data[k][idx]
            }
            window.lastHovered['type'] = "trap"
            hovertext = window.trapDescription(traps, hitidx);
            window.setSpanPosition(spans['hover'], starttime, endtime);
            found = true
        }
    }
    if ((!found) && (hitidx < waves.data['description'].length)) {
        starttime = waves.data['time'][hitidx][0]
        endtime = waves.data['time'][hitidx][waves.data['time'][hitidx].length -1]
        if (xhit <= endtime && xhit >= starttime) {
            found = true
            window.lastHovered = {}
            console.log('hoverWave')
            for (var k in waves.data) {
                window.lastHovered[k] = waves.data[k][idx]
            }
            window.lastHovered['type'] = "wave"
            window.setSpanPosition(spans['hover'], starttime, endtime);
            hovertext = window.waveDescription(waves, hitidx)
        }
    }
    if ((!found) && (hitidx < rf.data['description'].length)) {
        starttime = rf.data['time'][hitidx][0]
        endtime = rf.data['time'][hitidx][rf.data['time'][hitidx].length -1]
        if (xhit <= endtime && xhit >= starttime) {
            found = true
            window.lastHovered = {}
            for (var k in rf.data) {
                window.lastHovered[k] = rf.data[k][idx]
            }
            window.lastHovered['type'] = "rf"
            hovertext = window.rfDescription(rf, hitidx)
        }
    }
    // Check if any ADCs should hit
    if (found) {
        let compareString
        if ("lastClicked" in window) {
            compareString = window.compareObjects(window.lastClicked, window.lastHovered)
        }
        divs['right'].text = compareString
        for (i = 0; i < acq.data['description'].length; i++) {
            acqStart = acq.data['time'][i]
            acqEnd = acqStart + acq.data['duration'][i]
            if (endtime >= acqEnd && starttime <= acqStart) {
                window.lastHovered = {}
                for (var k in acq.data) {
                    window.lastHovered[k] = acq.data[k][idx]
                }
                window.lastHovered['type'] = "acq"
                hovertext += '<br>' + window.acqDescription(acq, i)
            }
        }
    }
}
if (hovertext !== '') {
    for (i = 0; i < spans['hover']['left'].length; i++) {
        spans['hover']['left'][i].location = starttime;
        spans['hover']['right'][i].location = endtime;
    }
    divs['left'].text = hovertext
}
            """)
        fig.add_tools(HoverTool(tooltips=None, callback=hover_cb, mode='vline'))
        fig.add_tools(TapTool(callback=clicked_cb))
        deactivateSelectionGlyph(renderers[board])
    return renderers


def plotLimits(metadata, padding_level=0.1):
    padding = emptyBoardDict()
    maxamp = {key: max(value, helper.Wave.maxamp[key]) for key, value in helper.Trapezoid.maxamp.iteritems()}
    minamp = {key: min(value, helper.Wave.minamp[key]) for key, value in helper.Trapezoid.minamp.iteritems()}
    [padding.update({b: padding_level * max(abs(minamp[b]), abs(maxamp[b]))}) for b in emptyBoardDict()]
    return {'maxtime': metadata['duration'],
            'maxamp': maxamp,
            'minamp': minamp,
            'padding': padding}


def addSlider(frameCDS, allframes, figs):
    numframes = len(allframes)
    if numframes == 1:
        return None
    else:
        changeframe_cb = CustomJS(args=dict(figs=figs, allframes=allframes, allCDS=frameCDS), code="""
let frame = cb_obj.value
for (let board in figs) {
    let CDS =  allCDS[board]
    let newdata = allframes[frame][board]
    CDS['traps'].data = newdata['trapz']
    CDS['traps'].change.emit()
    CDS['waves'].data = newdata['waves']
    CDS['waves'].change.emit()
}
    """)
        slider = Slider(start=0, end=numframes - 1, value=0, step=1, title="Frame", callback=changeframe_cb, bar_color="#2EA54A")
    return slider


def generateCDS(framedata, durationInstructions):
    frameCDS = {b: {} for b in framedata.keys()}
    for board, items in framedata.iteritems():
        frameCDS[board] = {
            'traps': ColumnDataSource(data=items['trapz']),
            'acq': ColumnDataSource(data=items['acq']),
            'waves': ColumnDataSource(data=items['waves']),
            'rf': ColumnDataSource(data=items['rf']),
            'durations': ColumnDataSource(data=durationInstructions[board]),
            'zeros': ColumnDataSource(data=items['zero']),
            'zeromoment': ColumnDataSource(data=items['zeromoment']),
            'firstmoment': ColumnDataSource(data=items['firstmoment']),
            'secondmoment': ColumnDataSource(data=items['secondmoment'])
        }
    return frameCDS


def generateDurationInstructions(metadata, limits, boards):
    inst = {}
    for b in boards:
        inst.update({b: {'xcenter': [metadata['min_duration'] + (metadata['duration'] - metadata['min_duration']) / 2,
                                     metadata['min_duration'] - (metadata['ssi_time']) / 2],
                         'ycenter': [(limits['maxamp'][b] + limits['minamp'][b]) / 2,
                                     (limits['maxamp'][b] + limits['minamp'][b]) / 2],
                         'width': [metadata['duration'] - metadata['min_duration'],
                                   metadata['ssi_time']],
                         'height': [limits['maxamp'][b] - limits['minamp'][b] + 2 * limits['padding'][b],
                                    limits['maxamp'][b] - limits['minamp'][b] + 2 * limits['padding'][b]],
                         'color': [colors['trfill'], colors['ssitime']],
                         'name': ["TR Fill", "SSI Time"]}})
    return inst


def setupBokeh(usedboards, limits, metadata, title):
    figs = OrderedDict()
    bokeh_xrange = Range1d(0, metadata['duration'])
    for i in usedboards:
        figs.update({i: figure(tools="", width=1100, plot_height=200)})
        figs[i].add_tools(BoxZoomTool())
        figs[i].toolbar.logo = None
        figs[i].add_layout(Span(
            location=0.0,
            dimension='width',
            level='underlay',
            name="iso",
            line_color='black',
            line_alpha=.75,
            line_dash='dotted',
            line_width=1))
        bokeh_yrange = Range1d(limits['minamp'][i] - limits['padding'][i],
                               limits['maxamp'][i] + limits['padding'][i])
        figs[i].x_range = bokeh_xrange
        figs[i].y_range = bokeh_yrange
        figs[i].xgrid.visible = False
        figs[i].ygrid.visible = False
        figs[i].xaxis.visible = False
        figs[i].yaxis.axis_label = axisLabel(i)
        figs[i].yaxis[0].axis_label_text_font_style = 'normal'
        figs[i].yaxis[0].axis_label_text_font_size = '13pt'
        figs[i].yaxis[0].major_label_text_font_size = '10pt'
        figs[i].yaxis[0].ticker.num_minor_ticks = 0
    figs.items()[-1][1].xaxis.visible = True
    figs.items()[-1][1].xaxis.axis_label = 'Time [ms]'
    figs.items()[-1][1].yaxis[0].axis_label_text_font_style = 'normal'
    figs.items()[-1][1].xaxis.major_label_text_font_size = '10pt'
    figs['x'].title.text = title
    return figs


def addRfSpans(figs, events):
    spans = []
    for fig in figs.values():
        for i in range(0, len(events['time'])):
            rfspan = Span(location=events['time'][i],
                          dimension='height',
                          level='underlay',
                          name=events['role'][i],
                          line_color=events['color'][i],
                          line_dash='solid',
                          line_width=2)
            spans.append(rfspan)
            fig.add_layout(rfspan)
    return spans


def addHoverSpans(figs):
    spans = {
        'hover': {
            'left': [],
            'right': []
        }, 'tap': {
            'left': [],
            'right': []
        }, 'doubleTap': {
            'left': [],
            'right': []
        }, 'rfevents': []
    }
    spanConfig = {'color': {'hover': 'olive',
                            'tap': 'black',
                            'doubleTap': 'red'},
                  'dash': {'hover': 'dashed',
                           'tap': 'dotted',
                           'doubleTap': 'dashed'}}
    for fig in figs.values():
        for spantype in ('hover', 'tap', 'doubleTap'):
            spancolor = colors['span' + spantype]
            leftspan = Span(
                location=-1.0,
                dimension='height',
                level='underlay',
                name="iso",
                line_color=spanConfig['color'][spantype],
                line_dash=spanConfig['dash'][spantype],
                line_width=1)
            rightspan = Span(
                location=-1.0,
                dimension='height',
                level='underlay',
                name="iso",
                line_color=spanConfig['color'][spantype],
                line_dash=spanConfig['dash'][spantype],
                line_width=1)
            spans[spantype]['left'].append(leftspan)
            spans[spantype]['right'].append(rightspan)
            fig.add_layout(leftspan)
            fig.add_layout(rightspan)
    return spans


def columnDataFromObjects(frame, boardinstr, objs, seqdur):
    for board in frame.keys():
        times = [0, 0]
        for obj in objs[board]:
            times[1] = obj['start']
            frame[board]['zero']['time'].append(times[:])
            frame[board]['zero']['amp'].append([0, 0])
            times[0] = obj['end']
            if obj['type'] == 'trapz':
                trap = boardinstr['trapz'][obj['description']]
                inst = obj['instanceId']
                (time, amp) = trap.getPlotNodes(inst)
                frame[board]['trapz']['time'].append(time)
                frame[board]['trapz']['amp'].append(amp)
                frame[board]['trapz']['description'].append(trap.description)
                frame[board]['trapz']['instance'].append(inst)
                frame[board]['trapz']['board'].append(trap.board[inst])
            elif (obj['type'] == 'waves'):
                wave = boardinstr['waves'][obj['description']]
                inst = obj['instanceId']
                frame[board]['waves']['time'].append(wave.instanceTime(inst))
                frame[board]['waves']['amp'].append(wave.instanceWaveform(inst))
                frame[board]['waves']['description'].append(wave.description)
                frame[board]['waves']['instance'].append(inst)
                frame[board]['waves']['board'].append(wave.board[inst])
            elif obj['type'] == 'rf':
                rf = boardinstr['rf'][obj['description']]
                inst = obj['instanceId']
                frame[board]['rf']['time'].append(rf.rfwave.instanceTime(inst))
                frame[board]['rf']['amp'].append(rf.rfwave.instanceWaveform(inst))
                frame[board]['rf']['description'].append(rf.description)
                frame[board]['rf']['instance'].append(inst)
                frame[board]['rf']['ampscale'].append(rf.ampscale[inst])
                frame[board]['rf']['rtscale'].append(rf.rtscale[inst])
                frame[board]['rf']['flipangle'].append(rf.flipangle)
                frame[board]['rf']['nom_flipangle'].append(rf.nominal_flipangle)
                frame[board]['rf']['max_b1'].append(rf.max_b1)
                frame[board]['rf']['role'].append(rf.role)
                frame[board]['rf']['num_instances'].append(rf.numInstances())
                frame[board]['rf']['theta'].append(rf.theta.description if rf.theta is not None else "No theta wave")
                frame[board]['rf']['omega'].append(rf.omega.description if rf.omega is not None else "No omega wave")
                # Event
                frame['r']['events']['time'].append(rf.isodelay + rf.start[inst])
                frame['r']['events']['role'].append(rf.role)
                frame['r']['events']['color'].append(colorFromRole[rf.role])
            if (obj['type'] == 'rf.theta'):
                wave = boardinstr['rf'][obj['description']].theta
                inst = obj['instanceId']
                frame[board]['waves']['time'].append(wave.instanceTime(inst))
                frame[board]['waves']['amp'].append(wave.instanceWaveform(inst))
                frame[board]['waves']['description'].append(wave.description + '.theta')
                frame[board]['waves']['instance'].append(inst)
                frame[board]['waves']['board'].append(wave.board[inst])
            if (obj['type'] == 'rf.omega'):
                wave = boardinstr['rf'][obj['description']].omega
                inst = obj['instanceId']
                frame[board]['waves']['time'].append(wave.instanceTime(inst))
                frame[board]['waves']['amp'].append(wave.instanceWaveform(inst))
                frame[board]['waves']['description'].append(wave.description + '.omega')
                frame[board]['waves']['instance'].append(inst)
                frame[board]['waves']['board'].append(wave.board[inst])
        times[1] = seqdur
        frame[board]['zero']['time'].append(times)
        frame[board]['zero']['amp'].append([0, 0])
    for acq in boardinstr['acquisitions']:
        parent = getReadoutParent(acq, boardinstr['trapz'], boardinstr['waves'])
        frame[parent['board']]['acq']['xcenter'].append(acq['start'] + acq['duration'] / 2.0)
        frame[parent['board']]['acq']['ycenter'].append(parent['amp'] / 2)
        frame[parent['board']]['acq']['time'].append(acq['start'])
        frame[parent['board']]['acq']['duration'].append(acq['duration'])
        frame[parent['board']]['acq']['amp'].append(abs(parent['amp']))
        frame[parent['board']]['acq']['color'].append(colors['rampsampled'] if parent['rampsampled'] is True else colors['samplewindow'])
        frame[parent['board']]['acq']['description'].append(acq['description'])
        frame[parent['board']]['acq']['board'].append(parent['board'])
        frame[parent['board']]['acq']['samples'].append(acq['samples'])
        frame[parent['board']]['acq']['rbw'].append(acq['rbw'])


def calculateMoments(allMoments, instructions, sortedObjs, metadata, events):
    [momentOrder['time'].extend([0, metadata['momentstart']]) for momentOrder in allMoments]
    [momentOrder['moment'].extend([0, 0]) for momentOrder in allMoments]
    previous_end = metadata['momentstart']
    for obj in sortedObjs:
        current = []
        if obj['type'] == 'trapz':
            current = instructions['trapz'][obj['description']]
        elif obj['type'] == 'waves':
            current = instructions['waves'][obj['description']]
        else:
            print(obj['type'] + ' - important?')
            continue
        start = current.start[obj['instanceId']]
        end = current.end[obj['instanceId']]
        exc = False
        refocus_events = {'pre': [], 'during': []}
        for event_id, t in enumerate(events['time']):
            role = events['role'][event_id]
            if (t < start) and (t > previous_end) and (role == "KS_RF_ROLE_REF"):
                refocus_events['pre'].append(t)
            if (t >= start) and (t < end) and (role == "KS_RF_ROLE_REF"):
                refocus_events['during'].append(t)
            if (t < start) and (t > end) and (role == "KS_RF_ROLE_EXC"):
                print("Excitation without trap!") # TODO: Support this case
                raise Exception
            if (t >= start) and (t < end) and (role == "KS_RF_ROLE_EXC"):
                exc = t
        previous_event = previous_end
        for t in refocus_events['pre']:
            # No gradient has been played, only flip moment at the correct time
            [momentOrder['time'].extend([previous_event, t, t]) for momentOrder in allMoments]
            [momentOrder['moment'].extend([momentOrder['moment'][-1], momentOrder['moment'][-1], -momentOrder['moment'][-1]]) for momentOrder in allMoments]
            previous_event = t
        if refocus_events['during']:
            prev = 0
            for t in refocus_events['during']:
                partial = current.moments(obj['instanceId'], begin=prev, stop=t - start)
                for order, momentOrder in enumerate(allMoments):
                    momentOrder['time'].extend(np.linspace(start + prev, t, partial[order].size))
                    momentOrder['moment'].extend(partial[order] + momentOrder['moment'][-1])
                    momentOrder['time'].extend([t])
                    momentOrder['moment'].extend([-momentOrder['moment'][-1]])
                prev = t - start
            final = current.moments(obj['instanceId'], begin=prev, stop=current.duration)
            [momentOrder['time'].extend(np.linspace(prev + start, end, final[order].size)) for order, momentOrder in enumerate(allMoments)]
            [momentOrder['moment'].extend(final[order] + momentOrder['moment'][-1]) for order, momentOrder in enumerate(allMoments)]
        elif exc:
            partial = current.moments(obj['instanceId'], begin=exc - start, stop=current.duration)
            [momentOrder['moment'].extend(partial[order]) for order, momentOrder in enumerate(allMoments)]
            [momentOrder['time'].extend(np.linspace(exc, end, partial[order].size)) for order, momentOrder in enumerate(allMoments)]
        else:
            full = current.moments(obj['instanceId'], begin=0, stop=current.duration)
            [momentOrder['time'].extend(np.linspace(start, end, full[order].size)) for order, momentOrder in enumerate(allMoments)]
            [momentOrder['moment'].extend(full[order] + momentOrder['moment'][-1]) for order, momentOrder in enumerate(allMoments)]
        previous_end = current.end[obj['instanceId']]
    for order, momentOrder in enumerate(allMoments):
        momentOrder['time'].extend([previous_end, metadata['duration']])
        momentOrder['moment'].extend([momentOrder['moment'][-1], momentOrder['moment'][-1]])
        momentOrder['moment'] = np.array(momentOrder['moment']) / 1000.0


def plot(boardinstr, metadata, plans, saveSvg):
    numframes = len(boardinstr)

    objs = sortedBoards(boardinstr)
    usedboards = activeBoards(objs)

    limits = plotLimits(metadata)

    figures = {'bokeh': []}
    figures['bokeh'] = setupBokeh(usedboards, limits, metadata, args.title)

    # Add plot instructions
    lines = emptyBoardDict()
    bokeh_template = {'trapz': ('time', 'amp', 'description', 'instance', 'board'),
                      'waves': ('time', 'amp', 'description', 'instance', 'board'),
                      'events': ('time', 'role', 'color'),
                      'rf': ('time', 'amp', 'description', 'instance', 'ampscale', 'rtscale', 'flipangle', 'nom_flipangle', 'max_b1', 'role', 'num_instances', 'theta', 'omega'),
                      'zero': ('time', 'amp'),
                      'acq': ('xcenter', 'ycenter', 'time', 'duration', 'amp', 'description', 'rbw', 'samples', 'board', 'color'),
                      'zeromoment': ('time', 'moment'),
                      'firstmoment': ('time', 'moment'),
                      'secondmoment': ('time', 'moment')
                      }

    framedata = [{board: {obj: {prop: [] for prop in bokeh_template[obj]} for obj in bokeh_template.keys()} for board in usedboards} for _ in range(numframes)]
    for frameIdx, frame in enumerate(framedata):
        columnDataFromObjects(frame, boardinstr[frameIdx], objs[frameIdx], metadata['duration'])
        for board in ['x', 'y', 'z']:
            calculateMoments([framedata[frameIdx][board]['zeromoment'], framedata[frameIdx][board]['firstmoment'], framedata[frameIdx][board]['secondmoment']],
                             boardinstr[frameIdx], objs[frameIdx][board], metadata, framedata[frameIdx]['r']['events'])
    divs = {'left': Div(css_classes=["plot_info", "plot_info_left"]),
            'center': Div(css_classes=["plot_info", "plot_info_center"]),
            'right': Div(css_classes=["plot_info", "plot_info_right"])}
    spans = addHoverSpans(figures['bokeh'])
    spans.update({'rfevents': addRfSpans(figures['bokeh'], framedata[0]['r']['events'])})
    durationInstructions = generateDurationInstructions(metadata, limits, usedboards)
    frameCDS = generateCDS(framedata[0], durationInstructions)
    slider = addSlider(frameCDS, framedata, figures['bokeh'])
    renderers = plotBokehFrame(figures['bokeh'], frameCDS, metadata, spans, divs)

    toggleRFiso_cb = CustomJS(args=dict(spans=spans['rfevents']), code="""
    if (cb_obj.active) {
        cb_obj.label = "RF events on"
    } else {
        cb_obj.label = "RF events off"
    }
for (var span in spans) {
    spans[span].visible = !spans[span].visible
}
        """)

    toggleDuration = Toggle(label="Show actual duration", button_type="success", active=False)
    toggleDuration_cb = CustomJS(args=dict(figs=figures['bokeh'], metadata=metadata, toggleButton=toggleDuration, limits=limits), code="""
        end = (toggleButton.active) ? metadata['duration'] : metadata['min_duration']
        toggleButton.label = (toggleButton.active) ? "Show minimum duration" : "Show actual duration"
        console.log('resetting')
        for (let fig in figs) {
            figs[fig].x_range.setv({"start": 0,
                                    "reset_start": 0,
                                    "end": end,
                                    "reset_end": end})
            figs[fig].y_range.setv({"start": limits['minamp'][fig] - limits['padding'][fig],
                                    "reset_start": limits['minamp'][fig] - limits['padding'][fig],
                                    "end": limits['maxamp'][fig] + limits['padding'][fig],
                                    "reset_end": limits['maxamp'][fig] + limits['padding'][fig]})
            for (let extra in figs[fig].extra_y_ranges) {
                figs[fig].extra_y_ranges[extra].reset();
            }
        }
    """)
    save_cb = CustomJS(args=dict(figs=figures['bokeh'], metadata=metadata), code="""
        console.log('save')
        }
    """)
    toggleMoment_cb = CustomJS(args=dict(figs=figures['bokeh'], metadata=metadata, renderers=renderers), code="""
    let boards = ["x", "y", "z"]
    let orderDescription = ["zeromoment", "firstmoment", "secondmoment"]
    for (let b in boards) {
        board = boards[b]
        if (cb_obj.active.length > 0) {
            let newmax = Math.max(Math.abs(figs[boards[b]].y_range.start), Math.abs(figs[boards[b]].y_range.end))
            figs[board].y_range.setv({"start": -newmax,
                                      "reset_start": -newmax,
                                      "end": newmax,
                                      "reset_end": newmax})
        }
        for (let order = 0; order < cb_obj.attributes.labels.length; order++) {
            let isOrderOn = cb_obj.active.indexOf(order) >= 0
            renderers[board][orderDescription[order]].visible = isOrderOn
        }
    }
    """)
    toggleDuration.js_on_click(toggleDuration_cb)
    toggleRFiso = Toggle(label="RF events off", button_type="success", callback=toggleRFiso_cb, active=False)
    toggleMoment = CheckboxButtonGroup(labels=["M0", "M1", "M2"], callback=toggleMoment_cb)
    resetZoomButton = Button(label="Reset zoom", button_type="success", callback=toggleDuration_cb)
    saveButton = Button(label="Save plot", button_type="success", callback=save_cb)
    if not toggleDuration.active:
        for f in figures['bokeh'].values():
            f.x_range.end = metadata['min_duration']
    if not toggleRFiso.active:
        for span in spans['rfevents']:
            span.visible = False

    if slider:
        togglebox = widgetbox(toggleRFiso, toggleDuration, resetZoomButton, slider, toggleMoment, css_classes=["plot_widgets"])
    else:
        togglebox = widgetbox(toggleRFiso, toggleDuration, resetZoomButton, toggleMoment, css_classes=["plot_widgets"])
    planrows = [plotPlan(plan) for plan in plans]
    for outdir in args.outputdir:
        outname = ("%s/%s_%s.html" % (outdir, metadata['psdname'], metadata['sequence']))
        svgname = ("%s/%s_%s.svg" % (outdir, metadata['psdname'], metadata['sequence'])) if saveSvg else ''
        saveBokeh(figures['bokeh'], divs, togglebox, outname, args.title, planrows, svgname)
        print('Saved', outname, svgname)
    return


def axisLabel(board):
    if board in ('x', 'y', 'z'):
        return board.upper() + ' [G/cm]'
    elif board == 'o':
        return 'Omega [Hz/mm]'
    elif board == 't':
        return 'Theta [deg]'
    elif board == 'r':
        return 'RF [G]'


def getReadoutParent(acq, trapz, waves=None):
    centertime = acq['start'] + acq['duration'] / 2
    for desc in trapz:
        trap = trapz[desc]
        for inst in range(0, trap.numInstances()):
            if (trap.start[inst] <= centertime and
                    trap.end[inst] > centertime and
                    "read" in trap.description):
                rampsampled = True if (acq['start'] < trap.plateaustart[inst]) else False
                return {'trap': trap,
                        'board': trap.board[inst],
                        'instance': inst,
                        'amp': trap.amp[inst],
                        'rampsampled': rampsampled}
    for desc in waves:
        wave = waves[desc]
        for inst in range(0, wave.numInstances()):
            if (wave.start[inst] <= centertime and
                    wave.end[inst] > centertime and
                    "read" in wave.description):
                rampsampled = True
                return {'wave': wave,
                        'board': wave.board[inst],
                        'instance': inst,
                        'amp': wave.amp[inst],
                        'rampsampled': rampsampled}
    return None


def boardinstrFromDict(objects, to_add=None):
    boardinstr = emptyBoardInstructions()
    for desc in objects['trapz']:
        boardinstr['trapz'].update(
            {desc: helper.Trapezoid(fields=objects['trapz'][desc], description=desc)})
    for desc in objects['waves']:
        boardinstr['waves'].update(
            {desc: helper.Wave(fields=objects['waves'][desc])})
    for desc in objects['rf']:
        boardinstr['rf'].update(
            {desc: helper.RF(description=desc, fields=objects['rf'][desc])})
    for acq in objects['acquisitions']:
        for (idx, start) in enumerate(acq['time']):
            boardinstr['acquisitions'].append({
                'start': start,
                'duration': acq['duration'],
                'rbw': acq['rbw'],
                'samples': acq['samples'],
                'instance': idx,
                'description': acq['description'] + str(idx).zfill(3)})
    if to_add is not None:
        boardinstr.update(to_add)
    return boardinstr


def processPhaseEncodingPlan(plan):
    entries = np.array(plan["entries"])
    ky = entries[:, :, 0]
    kz = entries[:, :, 1]
    return {'description': plan['description'],
            'shots': plan['num_shots'],
            'etl': plan['etl'],
            'ky': ky,
            'kz': kz,
            'is3d': (kz != -1).any()}


def readJsonInstructions(filename):
    with open(filename) as file:
        objects = json.load(file)
        frames = []
        del(objects['frames'][0])
        for f in objects['frames']:
            frames.append(boardinstrFromDict(f))
        if "phaseencplans" in objects.keys():
            plans = [processPhaseEncodingPlan(plan) for plan in objects['phaseencplans']]
        else:
            plans = []
        return dict(frames=frames,
                    metadata=objects['metadata'],
                    plans=plans)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('filename',
                        type=str,
                        default=None)
    parser.add_argument('-o', '--outputdir',
                        help=("Where plots are saved. " +
                              "Default is current directory"),
                        type=str,
                        nargs='*',
                        default=[os.getcwd(), ])
    parser.add_argument('-t', '--title',
                        help="Plot title",
                        default=None)
    parser.add_argument('--svg',
                        help="Flag to save vectorized (SVG) plots",
                        action="store_true",
                        default=False)
    args = parser.parse_args()
    args.__dict__.update({'boardinstr': readJsonInstructions(args.filename)})
    args.psdname = args.boardinstr['metadata']['psdname']
    args.sequence = args.boardinstr['metadata']['sequence']
    args.mode = args.boardinstr['metadata']['mode']
    if args.title is None:
        args.title = ("%s - %s (%s %s)" % (args.psdname,
                                           args.sequence,
                                           args.mode,
                                           strftime("%H:%M:%S", localtime())))
    mode = args.mode
    for n, outdir in enumerate(args.outputdir):
        args.outputdir[n] = os.path.abspath(outdir)
    plot(args.boardinstr['frames'], args.boardinstr['metadata'], args.boardinstr['plans'], args.svg)
