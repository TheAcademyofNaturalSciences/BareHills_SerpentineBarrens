############################################
# Image Classification Using Orfeo ToolBox #
############################################

import numpy as np
import time
import datetime
import otbApplication as otb
import os
from path import Path


runNum = '05'
os.getcwd()
# Go to the directory you want to output the segmentation files
os.mkdir(r'T:\WilliamPenn_Share\EDS\BARE_HILLS\DATA\SPATIAL\segout_'+runNum)
os.chdir(r'T:\WilliamPenn_Share\EDS\BARE_HILLS\DATA\SPATIAL\segout_'+runNum)

print('Available applications: ')
apps = list( otb.Registry.GetAvailableApplications())
for app in apps:
    print(app)

print('\nAvailable parameters for LargeScaleMeanShift: ')
LargeScaleMeanShift = otb.Registry.CreateApplication('LargeScaleMeanShift')
params = list(LargeScaleMeanShift.GetParametersKeys())
for param in params:
    print(param)

# All of these parameters can be edited based on the computer in use and desired segmentation
# spatialr and minsize are in pixels (0.25 sqft)
# ranger is in radiometric units
# ram is in MB

inras = r'T:\WilliamPenn_Share\EDS\BARE_HILLS\DATA\SPATIAL\barehills6in_prj_s.tif'
spatialr = 4   # Changing this parameter will effect run-time, higher means more avg.ing -> more time
ranger = 15.00
minsize = 12
cleanup = 'True'
ram = 2000
outshp = r'T:\WilliamPenn_Share\EDS\BARE_HILLS\DATA\SPATIAL\segout_'+runNum+'\seg_merged_'+runNum+'.shp'

# Set the parameters for the application
LargeScaleMeanShift.SetParameterString("in", inras)
LargeScaleMeanShift.SetParameterInt("spatialr", spatialr)
LargeScaleMeanShift.SetParameterFloat("ranger", ranger)
LargeScaleMeanShift.SetParameterInt("minsize", minsize)
LargeScaleMeanShift.SetParameterString("cleanup", cleanup)
LargeScaleMeanShift.SetParameterInt("ram", ram)
LargeScaleMeanShift.SetParameterString("mode.vector.out", outshp)

# Create a log file of the inputs used in this run in case we forget
t = datetime.datetime.now()
myFile = open('Inputs_'+runNum+'.txt', 'w')
myFile.writelines('Run on {0}/{1}/{2} at {3}:{4}:{5}{6}'.format(t.year,t.month,t.day,t.hour,t.minute,t.second,'\n'))
myFile.writelines('{0} = {1}{2}'.format('inras',inras,'\n'))
myFile.writelines('{0} = {1}{2}'.format('spatialr',spatialr,'\n'))
myFile.writelines('{0} = {1}{2}'.format('ranger',ranger,'\n'))
myFile.writelines('{0} = {1}{2}'.format('minsize',minsize,'\n'))
myFile.writelines('{0} = {1}{2}'.format('cleanup',cleanup,'\n'))
myFile.writelines('{0} = {1}{2}'.format('ram',ram,'\n'))
myFile.writelines('{0} = {1}{2}'.format('outshp',outshp,'\n'))

# Run the OTB Algorithm
start_time = time.clock()
LargeScaleMeanShift.ExecuteAndWriteOutput()
print("OTB operation took:")
print(round((time.clock() - start_time)/60, 2), "minutes")

myFile.writelines('{0}OTB operation took {1} minutes'.format('\n',round((time.clock() - start_time)/60, 2)))
myFile.close()

# Cleanup the extra raster files created by the application
d = Path(os.getcwd())
clean = d.walkfiles('*.tif')
for file in clean:
    file.remove()










