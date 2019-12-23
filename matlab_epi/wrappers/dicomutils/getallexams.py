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
import glob
import socket
import json
import time
from datetime import datetime, timedelta



def runGetAllExams(rootpath, dirptrn, sendto, daysold):
  
  ###############################################################################
  ################################ Config  ######################################
  ###############################################################################
  hostname = socket.gethostname()
  logFile       = "/tmp/getallexams.log"
  logLevel      = "INFO"
  getOneExam    = "/usr/local/bin/getexam.py"
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

 # if socket.gethostname() == "hermes" or socket.gethostname() == "pandora":
 #    hostjson = "/recon/master/matlab2/wrappers/dicomutils/hosts.json"
 # else:
 #    hostjson = json.load(open(os.path.dirname(os.path.realpath(__file__)) + "/hosts.json"))
 #
 #  hosts = json.load(open(hostjson))
      
  ###############################################################################
  ###############################################################################

  rootpath = os.path.abspath(rootpath) 
  os.chdir(rootpath)
  examdir = glob.glob(dirptrn)

  if daysold:
    hourlimit = int(daysold) * 24
  else:
    hourlimit = 0
  

  for e in examdir:
      fileparts = e.split('_')
      mrscanner = fileparts[1]
      examno = fileparts[2].split('s')[0].replace('e','')

      exampath = rootpath + os.path.sep + e
      zipfile = glob.glob(exampath + os.path.sep + '20*.zip')

      file_mod_time = datetime.fromtimestamp(os.stat(exampath).st_mtime)  # This is a datetime.datetime object!
      now = datetime.today()
      max_delay = timedelta(hours=hourlimit)

      if (hourlimit == 0) or (now - file_mod_time < max_delay):
        doit = True
      else:
        doit = False
              
      if not zipfile:
        if doit:
          command = getOneExam + ' --scanner ' + mrscanner + ' --exam ' + examno + ' --storepath ' + exampath + ' --sendto ' + sendto
          logger.info(command)
          process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
          output = process.communicate()
        else:
          logger.info(exampath + ': No zip file exists but exam too old to try')
      else:
        logger.info(exampath + ': zip file already exists')
        



if __name__ == "__main__":

  parser = argparse.ArgumentParser(description='Get all DICOMs for exams in rootpath')

  parser.add_argument('--rootpath',
                  help="root path of archive",
                      type=str,
                      default="./")
  parser.add_argument('--dirptrn',
                  help="dir filename pattern to search",
                      type=str,
                      default="20*_e*s*_*")
  parser.add_argument('--sendto',
                  help="Sends DICOM additionally to user. Details must be setup in hosts.json.",
                  type=str,
                  default='')
  parser.add_argument('--daysold',
                  help="Sends DICOM additionally to user. Details must be setup in hosts.json.",
                  type=str,
                  default='')
  
  args = parser.parse_args()
  print(args)
  
  runGetAllExams(rootpath=args.rootpath, dirptrn=args.dirptrn, sendto=args.sendto, daysold=args.daysold)
  

  
