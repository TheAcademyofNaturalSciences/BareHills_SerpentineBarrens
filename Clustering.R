setwd("T:/WilliamPenn_Share/EDS/BARE_HILLS/DATA/SPATIAL/segout_03")
dat <- read.csv(file="seg_merged_03_zscore.csv")
head(dat)
srun.km <- kmeans(dat[, -1], 50, iter.max = 100, nstart = 25)
print(srun.km)
write.csv(srun.km$cluster,file="seg_merged_03_clusters.csv")

codetools Description
111 Residential
120 Farm Building
141 Road
172 Shrubs
211 Crops
212 Pasture
400 "Recent" Clearcut
410 Deciduous forest
420 Conifer forest
510 Water
20 Nonforested Wetland
740 Rock/Gravel bar/soil