#!/usr/bin/env python3
import sys
import subprocess
import os
import json
import socket
import argparse
import datetime
import glob


def send(senderAETitle, allReceivers, pattern='*.dcm', hostFile='', logger=''):
    if not hostFile:
        hostFile = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'hosts.json')
    with open(hostFile, 'r') as f:
        hosts = json.load(f)
        for receiver in allReceivers:
            if receiver not in hosts:
                for host in hosts:
                    if 'nickname' in hosts[host] and receiver in hosts[host]['nickname']:
                        receiver = host
            if receiver not in hosts:
                if logger:
                    logger.error('User "' + receiver + '" not found in ' + hostFile)
                continue
            target = hosts[receiver]
            if not all([attr in target for attr in ['aet', 'hostname', 'dicomport', 'ip']]):
                if logger:
                    logger.error('hosts.json: Each target must have "aet", "hostname", "dicomport", and "ip"')
                raise Exception('hosts.json: Each target must have "aet", "hostname", "dicomport", and "ip"')
            cmd = ['storescu',
                   '-aet', senderAETitle,
                   '-aec', target['aet'], target['ip'], str(target['dicomport']),
                   '--timeout', '10',
                   pattern]
            if logger:
                logger.info(' '.join(cmd))
            proc = subprocess.Popen(" ".join(cmd), shell=True)
            proc.communicate()


if __name__ == "__main__":
    import dicomHelper
    parser = argparse.ArgumentParser()
    parser.add_argument('sendToUser',
                        help="Sends DICOMs to user. Details must be setup in hosts.json.",
                        type=str,
                        default='')
    parser.add_argument('--hostname',
                        help="AETitle of sender.",
                        type=str,
                        default=socket.gethostname())
    parser.add_argument('--CI',
                        help="Anonymize DICOMs according to CI. Provide: 1. Studydescription 2. Datadescription, 3. Gitsha and 4. branch for SeriesDescription.",
                        type=str,
                        nargs='*',
                        default=[])
    parser.add_argument('--filepattern',
                        help="Glob pattern to match filenames.",
                        type=str,
                        default='./*.dcm')
    args = parser.parse_args()
    if args.CI:
        print(args.CI)
        dcmfiles = sorted(glob.glob(args.filepattern))
        studydescr = args.CI[0]
        datadescr = args.CI[1]
        gitsha = args.CI[2]
        branch = args.CI[3]
        t = datetime.datetime.now()
        seriesDescr = '{:04d}-{:02d}-{:02d} {:02d}:{:02d} #{} ({})'.format(
                        t.year, t.month, t.day, t.hour, t.minute, gitsha, branch)
        dicomHelper.anonymize(dcmfiles,
                              newPatientName=datadescr,
                              newStudyDescription=studydescr,
                              newSeriesDescription=seriesDescr)
    send(senderAETitle=args.hostname,
         allReceivers=[args.sendToUser],
         pattern=args.filepattern)
