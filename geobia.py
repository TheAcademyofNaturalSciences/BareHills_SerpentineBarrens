import numpy as np
import time
import otbApplication as otb
import gdal
import os
# from rsgislib.segmentation import segutils
# from rios import ratapplier

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

# You may want to alter a raster band to increase or decrease it's weight

# gdal















# OLDER WORK TRYING TO USE RSGISLib, this requires the rasters in kea format
# and only works well on a Linux OS
#
# inputImage = "D:\\DATA\\SPATIAL\\Imagery\\BareHills\\barehills_6in.tif"
# outputClumps = "D:\\DATA\\SPATIAL\\Imagery\\BareHills\\barehills_6inclumps.kea"
#
# segutils.runShepherdSegmentation(inputImage, outputClumps, numClusters=60, minPxls=100,
#                                  distThres=100, bands=None, sampling=100, kmMaxIter=200)
#
# def classifyWater(info, inputs, outputs):
#     # Read the 1996 JERS-1 Mean dB values for the clumps
#     # The column is represented as a numpy array of size
#     # block length x 1.
#     HH96MeandB = inputs.inrat.HH96MeandB
#     # Create a new numpy array with the same dimensions (i.e., length)
#     # as the 'HH96MeandB' array. The data type has been defined as
#     # an 8 bit integer (i.e., values from -128 to 128).
#     # All pixel values will be initialised to zero
#     Water96 = numpy.zeros_like(HH96MeandB, dtype=numpy.int8)
#     # Similar to an SQL where selection the where numpy where function
#     # allows a selection to be made. In this case all array elements
#     # with a 1996 HH value less than -12 dB are being selected and
#     # the corresponding elements in the Water96 array will be set to 1.
#     Water96 = numpy.where((HH96MeandB & amp;amp;lt; -12), 1, Water96)
#     # Save out to column 'Water96'
#     outputs.outrat.Water96 = Water96
#
#
# # Set up inputs and outputs for ratapplier
# inRats = ratapplier.RatAssociations()
# outRats = ratapplier.RatAssociations()
#
# inRats.inrat = ratapplier.RatHandle('N06W053_96-10_segs.kea')
# outRats.outrat = ratapplier.RatHandle('N06W053_96-10_segs.kea')
#
# print('Classifying water')
# ratapplier.apply(classifyWater, inRats, outRats)


