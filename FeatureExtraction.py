##################################################
#     Feature Extraction Using Orfeo ToolBox     #
# Compute different edge and radiometric indices #
##################################################

import time
import datetime
import otbApplication as otb
import os
from path import Path


runNum = '01'
os.getcwd()
# Go to the directory you want to output the segmentation files
os.mkdir(r'T:\WilliamPenn_Share\EDS\BARE_HILLS\DATA\SPATIAL\fexout_'+runNum)
os.chdir(r'T:\WilliamPenn_Share\EDS\BARE_HILLS\DATA\SPATIAL\fexout_'+runNum)

print('Available applications: ')
apps = list(otb.Registry.GetAvailableApplications())
for app in apps:
    print(app)

print('\nAvailable parameters for RadiometricIndices: ')
RadiometricIndices = otb.Registry.CreateApplication('RadiometricIndices')
params = list(RadiometricIndices.GetParametersKeys())
for param in params:
    print(param)

options = list(RadiometricIndices.list.GetParameterKeys())

# All of these parameters can be edited based on the computer in use and desired segmentation
# spatialr and minsize are in pixels (0.25 sqft)
# ranger is in radiometric units
# ram is in MB

inras = r'T:\WilliamPenn_Share\EDS\BARE_HILLS\DATA\SPATIAL\barehills6in_prj_s.tif'
outras = r'T:\WilliamPenn_Share\EDS\BARE_HILLS\DATA\SPATIAL\fexout_'+runNum+r'\fex_merged_'+runNum+'.shp'
ram = 2000
# channels = {'red': 1,'blue': 3,'green': 2,'nir': 4}
channelsBlue = 3
channelsGreen = 2
channelsRed = 1
channelsNir = 4
outlist = '[Vegetation:NDVI]'

# Set the parameters for the application
RadiometricIndices.SetParameterString('in', inras)
RadiometricIndices.SetParameterString('out', outras)
RadiometricIndices.SetParameterInt('ram', ram)
RadiometricIndices.SetParameterInt('channels.blue', channelsBlue)
RadiometricIndices.SetParameterInt('channels.green', channelsGreen)
RadiometricIndices.SetParameterInt('channels.red', channelsRed)
RadiometricIndices.SetParameterInt('channels.nir', channelsNir)
RadiometricIndices.SetParameterString('list', outlist)

# Create a log file of the inputs used in this run in case we forget
t = datetime.datetime.now()
myFile = open('Inputs_'+runNum+'.txt', 'w')
myFile.writelines('Run on {0}/{1}/{2} at {3}:{4}:{5}{6}'.format(t.year,t.month,t.day,t.hour,t.minute,t.second,'\n'))
myFile.writelines('{0} = {1}{2}'.format('in', inras,'\n'))
myFile.writelines('{0} = {1}{2}'.format('out', outras,'\n'))
myFile.writelines('{0} = {1}{2}'.format('ram', ram,'\n'))
myFile.writelines('{0} = {1}{2}'.format('channels.blue', channelsBlue,'\n'))
myFile.writelines('{0} = {1}{2}'.format('channels.green', channelsGreen,'\n'))
myFile.writelines('{0} = {1}{2}'.format('channels.red', channelsRed,'\n'))
myFile.writelines('{0} = {1}{2}'.format('channels.nir', channelsNir,'\n'))
myFile.writelines('{0} = {1}{2}'.format('list', outlist,'\n'))

# Run the OTB Algorithm
start_time = time.clock()
RadiometricIndices.ExecuteAndWriteOutput()
print('OTB operation took:')
print(round((time.clock() - start_time)/60, 2), 'minutes')

myFile.writelines('{0}OTB operation took {1} minutes'.format('\n',round((time.clock() - start_time)/60, 2)))
myFile.close()

# Cleanup the extra raster files created by the application
d = Path(os.getcwd())
clean = d.walkfiles('*FINAL.tif')
for file in clean:
    file.remove()


