#!/usr/bin/env python

import os
import signal
import subprocess
import socket
import threading
import time

class JuliusServer(threading.Thread):
    def __init__(self, configFile):
        # initialize the process
        threading.Thread.__init__(self)
        self._process = None
        self._julius_bin = "/usr/local/bin/julius-4.2"
        self._config_file=configFile
        try:
            self.start()
        except ServerError, e:
            pass

    def run(self):
        #args = [self._julius_bin, "-module", "-input", "mic", "-C", self._config_file]
        args = [self._julius_bin, "-input", "mic", "-C", self._config_file]
        self._process = subprocess.Popen( args, 
                              #stdin = subprocess.PIPE, 
                              stdout = subprocess.PIPE, 
                              stderr = subprocess.PIPE) #,
                              #close_fds = True) 
        #stdout, stderr = self._process.communicate() 
        #stdout = self._process.communicate()
        #print 'Tipo: ', type(stdout) 
        #if stderr.rstrip() == "socket: bind failed":
        #    raise ServerError(stderr.rstrip())
        #while True:
        #    readed=self._process.stdout.readline()
        #    print readed
            
    def stop(self):
        """Kill the instance of the julius server.
        
        """
        if self.get_pid() != None:
            try:
                os.kill(self.get_pid(), signal.SIGTERM)
            except OSError:
                print "Error killing the julius server"
        else:
            print "No julius server process to stop"
            
    def restart(self):
        self.stop()
        self.start()
    
    def get_pid(self):
        if self._process != None:
            return self._process.pid
        else:
            return None
