############################################
# Image Classification Using Orfeo ToolBox #
############################################

import numpy as np
import time
import otbApplication as otb
import os


os.getcwd()
# Go to the directory you want to output the segmentation files
os.chdir(r'T:\WilliamPenn_Share\EDS\BARE_HILLS\DATA\SPATIAL\segout_03')

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

inras = r'T:\WilliamPenn_Share\EDS\BARE_HILLS\DATA\SPATIAL\barehills6in_prj_s.tif'
spatialr = 10   # Changing this parameter will effect run-time
ranger = 40.00
minsize = 40
cleanup = 'True'
ram = 2000
outshp = r'T:\WilliamPenn_Share\EDS\BARE_HILLS\DATA\SPATIAL\segout_03\seg_merged_03.shp'

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
print((time.clock() - start_time)/60, "minutes")









