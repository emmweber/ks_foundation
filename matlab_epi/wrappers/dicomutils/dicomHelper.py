#!/usr/bin/env python3
import pydicom
import datetime
import numpy as np
import os
import sys


# Dictionary of DICOM tags
tagDict = {
    'Patient Name': 0x00100010,
    'Patient ID': 0x00100020,
    'Patient Birthdate': 0x00100030,
    'Series Instance UID': 0x0020000E,
    'Study Instance UID': 0x0020000D,
    'Institution Name': 0x00080080,
    'Institution Address': 0x00080081,
    'Accession Number': 0x00080050,
    'Referring Physician': 0x00080090,
    'Image Comments': 0x00204000,
    'Operator Name': 0x00081070,
    'Media Storage Instance UID': 0x00020003,
    'SOP Instance UID':0x00080018,
    'Referenced SOP Instance UID': 0x00081155,
    'Other Patient IDs': 0x00101000,
    'Study ID': 0x00200010,
    'Study Description': 0x00081030,
    'Series Description': 0x0008103E,
    'Protocol Name': 0x00181030
}


def generateSOPInstanceUID():
    t = datetime.datetime.now()
    datestr = '{:04d}{:02d}{:02d}{:02d}{:02d}{:02d}{:03d}'.format(t.year, t.month, t.day, t.hour, t.minute, t.second, t.microsecond // 1000)
    randstr = str(np.random.randint(1000, 1000000000))
    uidstr = "1.3.12.2.1107.5.2.32.35356." + datestr + randstr
    return uidstr


def generateSeriesInstanceUID():
    return generateSOPInstanceUID() + ".0.0.0"


def readDicoms(files):
    datasets = []
    for filename in files:
        try:
            datasets.append(pydicom.read_file(filename))
        except FileNotFoundError:
            print('Error: ' + filename + ' not found')
            sys.exit(1)
    return datasets


def getTextPosition(matrixsize, font, text, location='SW', offset=3):
    # Position has (x,y) coordinates with (0,0) being top left corner
    textSize = font.getsize(text)
    if location == 'SW':
        return (offset, matrixsize[0] - textSize[1] - offset)
    elif location == 'SE':
        return (matrixsize[1] - textSize[0] - offset, matrixsize[0] - textSize[1] - offset)
    elif location == 'NE':
        return (matrixsize[1] - textSize[0] - offset, offset)
    elif location == 'NW':
        return (offset, offset)
    else:
        print('Error: invalid text location ' + location)
        raise Exception


def embedPixelDataText(datasets, text, offset=3):
    if not text:
        return
    import PIL
    import PIL.Image as Image
    import PIL.ImageDraw as ImageDraw
    import PIL.ImageFont as ImageFont
    font_size = 12
    font = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', font_size)

    for ds in datasets:
        pixelData = np.int32(ds.pixel_array)
        image = Image.fromarray(pixelData)
        draw = ImageDraw.Draw(image)
        textpos = getTextPosition(pixelData.shape, font, text)
        draw.text(textpos, text, font=font, fill='rgb(256, 256, 256)')
        matris = np.int16(np.array(image))
        ds.PixelData = matris.tobytes()


def removeFromSeriesDescription(datasets, toRemove):
    for ds in datasets:
        oldDescription = ds.SeriesDescription
        if oldDescription.startswith(toRemove):
            ds.SeriesDescription = oldDescription[len(toRemove):]


def saveDicoms(filenames, datasets):
    for idx, ds in enumerate(datasets):
        ds.save_as(filenames[idx])


def hackDicoms(filenames, embedText=''):
    datasets = readDicoms(filenames)
    removeFromSeriesDescription(datasets, 'NOT DIAGNOSTIC: ')
    embedPixelDataText(datasets, embedText)
    saveDicoms(filenames, datasets)


def anonymize(filenames, newPatientName='anonymous', newStudyDescription='unnamed', newSeriesDescription='unnamed'):
    SeriesInstanceUIDs = {}
    datasets = readDicoms(filenames)
    for ds in datasets:
        if tagDict['Series Instance UID'] in ds:
            SeriesInstanceUID = ds[tagDict['Series Instance UID']].value
            if SeriesInstanceUID not in SeriesInstanceUIDs:
                newSeriesInstanceUID = generateSeriesInstanceUID()
                SeriesInstanceUIDs[SeriesInstanceUID] = newSeriesInstanceUID
            else:
                newSeriesInstanceUID = SeriesInstanceUIDs[SeriesInstanceUID]
            ds[tagDict['Series Instance UID']].value = newSeriesInstanceUID
        else:
            raise Exception('Must have SeriesInstanceUID')
        
        ds[tagDict['SOP Instance UID']].value = generateSOPInstanceUID()
        
        toErase = ['Patient ID', 'Patient Birthdate', 'Study Instance UID', 'Institution Name', 'Institution Address', 'Accession Number', 'Referring Physician', 'Image Comments', 'Operator Name', 'Referenced SOP Instance UID', 'Other Patient IDs', 'Study ID', 'Protocol Name']
        for tag in toErase:
            if tagDict[tag] in ds:
                del ds[tagDict[tag]]
        toSet = [('Study Description', newStudyDescription), ('Patient Name', newPatientName)]
        for (tag, val) in toSet:
            if tagDict[tag] in ds:
                ds[tagDict[tag]].value = val
        if tagDict['Series Description'] in ds:
            ds[tagDict['Series Description']].value = newSeriesDescription
    saveDicoms(filenames, datasets)