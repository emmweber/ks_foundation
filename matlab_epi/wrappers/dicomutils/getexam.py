#!/usr/bin/env python3

import os
import socket
import subprocess
import pydicom
import logging
import re
import sys
from logging.handlers import RotatingFileHandler
import argparse
import string
import socket

sys.path.insert(0,'/recon/master/matlab2/wrappers/dicomutils/')
import dicomSender


def getFolderName(ds, mrscanner, acqdate, level="series"):
  validCharacters = string.ascii_letters + string.digits

  if mrscanner == '':
    if "StationName" in ds:
      mrscanner = ds.StationName # K2D8SMRXXX instead of hostname
    elif "PerformedStationName" in ds:
      mrscanner = ds.StationName # K2D8SMRXXX instead of hostname
    else:
      mrscanner = 'unknown'

  if acqdate == '':
    acqdate = ds.AcquisitionDate

  if level == "exam":
    folder = "{date}_{sysid}_e{exam}".format(
                date=acqdate, #.strftime("%Y%m%d"),
                sysid=mrscanner,
                exam=str(ds.StudyID).zfill(5),
                filesep=os.path.sep)
  else:
    folder = "{date}_{sysid}_e{exam}_s{series}_{safedesc}{filesep}".format(
                date=acqdate, #.strftime("%Y%m%d"),
                sysid=mrscanner,
                exam=str(ds.StudyID).zfill(5),
                series=str(ds.SeriesNumber).zfill(5),
                safedesc=re.sub("[^" + validCharacters + "]+",
                                '',
                                ds.SeriesDescription),
                filesep=os.path.sep)

  return folder


def runGetExam(scanner, exam, storepath, sendto):
  
  ###############################################################################
  ################################ Config  ######################################
  ###############################################################################
  hostname = socket.gethostname()
  logFile       = "/tmp/getexam.log"
  logLevel      = "INFO"
  ###############################################################################
  ################################ Setup   ######################################
  ###############################################################################
  logger = logging.getLogger("")
  hdlr = RotatingFileHandler(logFile, mode='a', maxBytes=100000, backupCount=2)
  formatter = logging.Formatter('%(asctime)s %(levelname)s:   %(message)s')
  hdlr.setFormatter(formatter)
  logger.addHandler(hdlr) 
  logger.setLevel(logging.getLevelName(logLevel))

  currentDirFull = os.path.realpath('.')
  currentDir     = os.path.basename(currentDirFull)
  validCharacters = string.ascii_letters + string.digits

  if socket.gethostname() == "hermes" or socket.gethostname() == "pandora":
    hostjson = "/recon/master/matlab2/wrappers/dicomutils/hosts.json"
  else:
    hostjson = os.path.dirname(os.path.realpath(__file__)) + "/hosts.json"

  hostname = socket.gethostname()
  
  ###############################################################################
  ################################ Begin DICOM get ##############################
  ###############################################################################
  
  # find exam path on scanner
  command = 'ssh ' + scanner +  ' pathExtract ' + exam + ' 1 1'
  logger.info(command)
  process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
  output = process.communicate()
  output = str(output[0]).replace("b'","").replace("\\n'","").replace("\\n","\n").splitlines()
  
  if output[0] == "NOT FOUND":
    return
  else:
    output = output[1]
  pth,dummy = os.path.split(output)
  pth,dummy = os.path.split(pth)

  # mkdir storepath
  command = 'mkdir -p ' + storepath
  logger.info(command)
  process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
  output = process.communicate()

  # change dir
  storepath = os.path.abspath(storepath)
  os.chdir(storepath)
  subdir = 'alldicoms_' + scanner + '_exam' + exam  

  # rm temp subdir
  command = 'rm -rf ' + storepath + os.path.sep + subdir
  logger.info(command)
  process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
  output = process.communicate()

  # mkdir temp subdir
  command = 'mkdir -p ' + storepath + os.path.sep + subdir
  logger.info(command)
  process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
  output = process.communicate()

  # get exam
  command = 'scp -rq ' + scanner + ':' + pth + ' ' + subdir
  logger.info(command)
  process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
  output = process.communicate()

  # rename exam
  os.chdir(subdir) #  os.getcwd(), os.listdir()
  examdir = [f for f in os.listdir() if not f.startswith('.')][0]
  logger.info(examdir)
  logger.info(os.getcwd())

  for root, dirs, files in os.walk(".", topdown=False):
    for name in files:
      dcmfile = os.path.join(root, name)
      break
    break
  ds = pydicom.dcmread(dcmfile)
  newexamdir = getFolderName(ds, '', '', "exam") # will try StationName and PerformedStationName for mrscanner if ''
  os.rename(examdir, newexamdir)

  # find StationName and AcquisitionDatae in multiple series (hoping at least one of them has StationName or PerformedStationName and AcquisitionDate)
  newexamdir = os.path.abspath(newexamdir)
  os.chdir(newexamdir)
  serdir = [f for f in os.listdir() if not f.startswith('.')]
  mrscanner = scanner # mrscanner is initialized as hostname
  acqdate = '20000101' # 2000-Jan-01 if all else fails
  for s in serdir:
    dcm = [f for f in os.listdir(s) if not f.startswith('.')][0]
    ds = pydicom.dcmread(s + os.path.sep + dcm)
    if "StationName" in ds:
      mrscanner = ds.StationName # K2D8SMRXXX instead of hostname
    elif "PerformedStationName" in ds:
      mrscanner = ds.StationName # K2D8SMRXXX instead of hostname
    if "AcquisitionDate" in ds:
      acqdate = ds.AcquisitionDate

  # rename series
  for s in serdir:
    dcm = [f for f in os.listdir(s) if not f.startswith('.')][0]
    ds = pydicom.dcmread(s + os.path.sep + dcm)    
    newseriersdir = getFolderName(ds, mrscanner, acqdate)
    os.rename(s, newseriersdir)

  # rename dicoms (add .dcm)
  for root, dirs, files in os.walk(".", topdown=False):
    for name in files:
      newname = name.replace('.','_')
      dcmfile = os.path.join(root, name)
      newdcmfile = os.path.join(root, newname) + '.dcm'
      os.rename(dcmfile, newdcmfile)


  # send dicoms to remote DICOM DB
  os.chdir(newexamdir)
  serdir = [f for f in os.listdir() if not f.startswith('.')]  
  for s in serdir:
    os.chdir(newexamdir + os.path.sep + s)
    if sendto:
      logger.info('Sending DICOM to ' + sendto)
      dicomSender.send(hostname, [sendto], '*.dcm', logger=logger)
      
  # change to 'subdir' again
  os.chdir(storepath + os.path.sep + subdir)

  # zip it
  command = 'zip -rq ' + newexamdir + '_alldicoms.zip ' + newexamdir
  logger.info(command)
  process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
  output = process.communicate()
  
  # move up
  command = 'mv -f ' + newexamdir + '_alldicoms.zip ..'
  logger.info(command)
  process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
  output = process.communicate()

  # remove subdir
  os.chdir(storepath)
  command = 'rm -rf ' + subdir
  logger.info(command)
  process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
  output = process.communicate()
    





if __name__ == "__main__":

  parser = argparse.ArgumentParser(description='Get all DICOMs for exam')

  parser.add_argument('--scanner',
                  help="MR scanner (K2D8SMR009 etc)",
                  type=str,
                  default='')
  parser.add_argument('--exam',
                  help="Exam #",
                  type=str,
                  default=False)
  parser.add_argument('--storepath',
                  help="Storepath",
                  type=str,
                  default=".")                  
  parser.add_argument('--sendto',
                  help="Sends DICOM additionally to user. Details must be setup in hosts.json.",
                  type=str,
                  default='')
  
  args = parser.parse_args()
  print(args)
  
  runGetExam(scanner=args.scanner,
            exam=args.exam,
            storepath=args.storepath,
            sendto=args.sendto)

  
