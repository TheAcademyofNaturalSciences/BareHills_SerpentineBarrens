############################################
# Image Classification Using Orfeo ToolBox #
############################################

import numpy as np
import time
import otbApplication as otb
import os


os.getcwd()
# Go to the directory you want to output the segmentation files
os.mkdir(r'T:\WilliamPenn_Share\EDS\BARE_HILLS\DATA\SPATIAL\segout_04')
os.chdir(r'T:\WilliamPenn_Share\EDS\BARE_HILLS\DATA\SPATIAL\segout_04')

print(np.__version__)
print('Available applications: ')
apps = list( otb.Registry.GetAvailableApplications())
for app in apps:
    print(app)

print('\nAvailable parameters for LargeScaleMeanShift: ')
LargeScaleMeanShift = otb.Registry.CreateApplication('LargeScaleMeanShift')
params = list(LargeScaleMeanShift.GetParametersKeys())
for param in params:
    print(param)

# 'in', 'spatialr', 'ranger', 'minsize', 'tilesizex', 'tilesizey', 'mode',
# 'mode.vector.imfield', 'mode.vector.out', 'mode.raster.out', 'cleanup',
# 'ram', 'inxml', 'outxml'

# All of these parameters can be edited based on the computer in use and desired segmentation
# spatialr and minsize are in pixels (0.25 sqft)
# ranger is in radiometric units
# ram is in MB

inras = r'T:\WilliamPenn_Share\EDS\BARE_HILLS\DATA\SPATIAL\barehills6in_prj_s.tif'
spatialr = 4   # Changing this parameter will effect run-time, higher means more avg.ing -> more time
ranger = 15.00
minsize = 4
cleanup = 'True'
ram = 2000
outshp = r'T:\WilliamPenn_Share\EDS\BARE_HILLS\DATA\SPATIAL\segout_04\seg_merged_04.shp'

LargeScaleMeanShift.SetParameterString("in", inras)
LargeScaleMeanShift.SetParameterInt("spatialr", spatialr)
LargeScaleMeanShift.SetParameterFloat("ranger", ranger)
LargeScaleMeanShift.SetParameterInt("minsize", minsize)
LargeScaleMeanShift.SetParameterString("cleanup", cleanup)
LargeScaleMeanShift.SetParameterInt("ram", ram)
LargeScaleMeanShift.SetParameterString("mode.vector.out", outshp)

start_time = time.clock()
LargeScaleMeanShift.ExecuteAndWriteOutput()
print("OTB operation took:")
print(round((time.clock() - start_time)/60, 2), "minutes")









