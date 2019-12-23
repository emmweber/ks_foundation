#!/usr/bin/env python3

import os
import socket
import subprocess
import pydicom
import logging
import sys
from logging.handlers import RotatingFileHandler
import argparse
from dicomutils import dicomSender


def MATLABstringlist(strlist):
  return '{' + ', '.join(["'" + s + "'" for s in strlist if len(s)>0]) + '}'


def runRecon(scannerOrigin, clinical, extraReceiver, parallel, moco, swi, doRecon):
  
  ###############################################################################
  ################################ Config  ######################################
  ###############################################################################
  dicomHosts = {
    'clinical' : ['pacs','pacs2'],
    'archive' : ['mrqa']
  }
  # This will be filled later depending on DICOM tags
  dicomDestinations = dicomHosts['archive'][:]
  dicomDestinations.append(scannerOrigin)
  dicomDestinations.append(extraReceiver)
  if clinical:
    dicomDestinations.extend(dicomHosts['clinical'])
  hostname = socket.gethostname()

  logFile       = "/tmp/recon_ksepi_py.log"
  logLevel      = "INFO"
  libgomp       = "/usr/lib/x86_64-linux-gnu/libgomp.so.1"
  matlab        = "matlab"
  reconlogfile  = "recon.log"
  dicomlogfile  = "dicom.log"
  dicomdir      = "matlabDicoms"
  matlabcmd     = "recon_epi('moco', {}, 'swi', {}, 'parpool', {})".format(moco, swi, parallel)
  archivehost   = "mrimac"
  archivepath   = "/data/rawdata/ksepi"
  archiveptrn   = "P*7 ScanArchive*h5 logfile.txt *log"
  ###############################################################################
  ################################ Setup   ######################################
  ###############################################################################
  logger = logging.getLogger("recon_ksepi")
  hdlr = RotatingFileHandler(logFile, mode='a', maxBytes=100000, backupCount=2)
  formatter = logging.Formatter('%(asctime)s %(levelname)s:   %(message)s')
  hdlr.setFormatter(formatter)
  logger.addHandler(hdlr) 
  logger.setLevel(logging.getLevelName(logLevel))

  currentDirFull = os.path.realpath('.')
  currentDir     = os.path.basename(currentDirFull)

  setmatlabpath = "addpath(genpath('" + os.path.dirname(os.path.realpath(__file__)) + "/..'))"

  ###############################################################################
  ################################ Begin recon ##################################
  ###############################################################################
  logger.info('Hostname:              ' + hostname)
  logger.info("------------------------------------------- Recon Starts --------------------------------------------------")
  logger.info("Script path:         " + os.path.abspath(__file__)) # path to potential symbolic link to this file
  logger.info("Actual script path:  " + os.path.realpath(__file__)) # path to potential this file after following symlinks
  logger.info("Current dir:         " + currentDir)
  logger.info("Current dir full:    " + currentDirFull)

  if doRecon:
    # Recon: recon_ksepi.m
    
    command = "export LD_PRELOAD={libgomp}; {matlab} -nodesktop -nosplash -logfile {logfile} -r \"try, {setmatlabpath}; {matlabcmd}; catch; end; exit\"".format(libgomp=libgomp, matlab=matlab, logfile=reconlogfile, setmatlabpath=setmatlabpath, matlabcmd=matlabcmd)
    # command = "export LD_PRELOAD={libgomp}; {matlab} -nodesktop -nosplash -logfile {logfile} -r \"     {setmatlabpath}; {matlabcmd};             exit\"".format(libgomp=libgomp, matlab=matlab, logfile=reconlogfile, setmatlabpath=setmatlabpath, matlabcmd=matlabcmd)
    logger.info(command)
    subprocess.call(command, shell=True)

  # Send DICOMs
  logger.info('Sending DICOM to ' + ' '.join(dicomDestinations))
  dicomSender.send(hostname, dicomDestinations, 'matlabDicoms/*.dcm', logger=logger)

# end of runRecon


if __name__ == "__main__":

  parser = argparse.ArgumentParser(description='Run ksepi MATLAB recon and send dicom files')

  parser.add_argument('--scanner',
                  help="AETitle of MR scanner to get DICOM files back.",
                  type=str,
                  default='')
  parser.add_argument('--clinical',
                  help="Determines if DICOM files are sent to PACS. Accession number is still required.",
                  action="store_true",
                  default=False)
  parser.add_argument('--sendToUser',
                  help="Sends DICOM additionally to user. Details must be setup in hosts.json.",
                  type=str,
                  default='')
  parser.add_argument('--parallel',
                  help="Use MATLAB parpool (0 or 1).",
                  type=int,
                  default=1)
  parser.add_argument('--moco',
                  help="Do motion correction (0 or 1).",
                  type=int,
                  default=1)
  parser.add_argument('--swi',
                  help="Do SWI recon (0 or 1).",
                  type=int,
                  default=0)
  parser.add_argument('--noRecon',
                  help="Run script without running recon_ksepi.",
                  action="store_true",
                  default=False)
  args = parser.parse_args()
  print(args)
  
  runRecon( scannerOrigin=args.scanner.lower(),
            clinical=args.clinical,
            extraReceiver=args.sendToUser, 
            parallel=args.parallel,
            moco=args.moco,
            swi=args.swi,
            doRecon = not args.noRecon)

  
