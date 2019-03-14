import numpy as np
import time
import otbApplication as otb
import gdal
import os
# from rsgislib.segmentation import segutils
# from rios import ratapplier

print(np.__version__)
print('Available applications: ')
print (str( otb.Registry.GetAvailableApplications()))

LargeScaleMeanShift = otb.Registry.CreateApplication('LargeScaleMeanShift')
print (LargeScaleMeanShift.GetParametersKeys())

# 'in', 'spatialr', 'ranger', 'minsize', 'tilesizex', 'tilesizey', 'mode',
# 'mode.vector.imfield', 'mode.vector.out', 'mode.raster.out', 'cleanup',
# 'ram', 'inxml', 'outxml'

inras = r'T:\WilliamPenn_Share\EDS\BARE_HILLS\DATA\SPATIAL\barehills6in_prj_s.tif'
spatialr = str(5)
ranger = str(15)
minsize = str(10)
outshp = r'T:\WilliamPenn_Share\EDS\BARE_HILLS\DATA\SPATIAL\segout_02\seg_merged_02.shp'

LargeScaleMeanShift.SetParameterString("in", inras)
LargeScaleMeanShift.SetParameterString("spatialr", spatialr)
LargeScaleMeanShift.SetParameterString("ranger", ranger)
LargeScaleMeanShift.SetParameterString("minsize", minsize)
LargeScaleMeanShift.SetParameterString("mode.vector.out", outshp)

start_time = time.clock()
LargeScaleMeanShift.ExecuteAndWriteOutput()
print("OTB operation took:")
print(time.clock() - start_time, "seconds")






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


