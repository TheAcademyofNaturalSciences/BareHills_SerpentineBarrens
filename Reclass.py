###########################################################################
# You may want to alter a raster band to increase or decrease it's weight #
###########################################################################

import numpy as np
import gdal

inras = r'T:\WilliamPenn_Share\EDS\BARE_HILLS\DATA\SPATIAL\barehills6in_prj_s.tif'

driver = gdal.GetDriverByName('GTiff')
file = gdal.Open(inras)
band1 = file.GetRasterBand(1)
band1a = band1.ReadAsArray()
band2 = file.GetRasterBand(2)
band2a = band2.ReadAsArray()
band3 = file.GetRasterBand(3)
band3a = band3.ReadAsArray()
band4 = file.GetRasterBand(4)
band4a = band4.ReadAsArray()

# Reclassification
# Broad
band1a[np.where((0 <= band1a) & (band1a < 256)) ] = band1a/2

# Based off band value criteria
band1a[np.where( band1a < 100 )] = band1a
band1a[np.where((100 < band1a) & (band1a < 200)) ] = 0
band1a[np.where((200 < band1a) & (band1a < 256)) ] = band1a/2

# create new file
file2 = driver.Create( 'barehills6in_prj_sr.tif', file.RasterXSize , file.RasterYSize , 1)
file2.GetRasterBand(1).WriteArray(band1a)
file2.GetRasterBand(2).WriteArray(band2a)
file2.GetRasterBand(3).WriteArray(band3a)
file2.GetRasterBand(4).WriteArray(band4a)

# spatial ref system
proj = file.GetProjection()
georef = file.GetGeoTransform()
file2.SetProjection(proj)
file2.SetGeoTransform(georef)
file2.FlushCache()
del file2