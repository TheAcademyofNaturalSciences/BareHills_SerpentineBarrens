# Random Forest Classification for GEOBIA
# An alternative for the train vector classifier in OTB
# OTB has an SVM classifier, we want RF
library(foreign)
library(randomForest)
library(caret)
library(dplyr)
library(ggraph)
library(igraph)
library(pillar)
library(sf)
library(raster)
library(ggplot2)
library(RStoolbox)

# SKIP TO LINE 240!!!!!!!!!!!!!!!!!!!!!

# Just some plotting functions testing
aoi_boundary_HARV <- st_read(
  "T:/WilliamPenn_Share/EDS/BARE_HILLS/DATA/SPATIAL/study_area_smallest2.shp")
classified_points <- st_read(
  "T:/WilliamPenn_Share/EDS/BARE_HILLS/DATA/SPATIAL/Classification/rand_pt_300_prj_nowat.shp")
rasFile <- "T:/WilliamPenn_Share/EDS/BARE_HILLS/DATA/SPATIAL/barehills6in_prj_s2_composite.tif"
imagery <- raster(rasFile)
imagery

classified_points$geometry

ggRGB(imagery, 1, 2, 3, stretch = "lin")

plot(imagery)

ggplot() + 
  geom_sf(data = aoi_boundary_HARV, size = 1, color = "red", fill = "white") + 
  geom_sf(data = classified_points, size = 1, color = "black", fill = "cyan1") + 
  ggRGB(imagery, r=1, g=2, b=3) +
  ggtitle("AOI Boundary Plot") + 
  coord_sf()

# Set up working directory and data variables
getwd()
setwd("T:/WilliamPenn_Share/EDS/BARE_HILLS/DATA/SPATIAL")

################################################################################################################################
# First iteration of the training set. Accuracies not acceptable yet

train_bh <- read.dbf("T:/WilliamPenn_Share/EDS/BARE_HILLS/DATA/SPATIAL/segout_17/seg_merged_17_training2.dbf",
                  as.is=FALSE)
colnames(train_bh)

drops <- c("FID_1","label" ,"id","Distance", "FID_2", "meanB4", "varB4",
           "SHAPE_Leng", "SHAPE_Area", "class_desc", "nbPixels", "class","OBJECTID","FID_1_1")

train_bh <- train_bh[ , !(names(train_bh) %in% drops)]
View(train_bh)

test_bh <- read.dbf("T:/WilliamPenn_Share/EDS/BARE_HILLS/DATA/SPATIAL/segout_17/seg_merged_17_classify2.dbf",
                    as.is=FALSE)
colnames(test_bh)
drops <- c("FID_1","label" ,"id","Distance", "FID_2", "meanB4", "varB4",
           "SHAPE_Leng", "SHAPE_Area", "class_desc", "nbPixels", "class","FID_1_1")
test_bh <- test_bh[ , !(names(test_bh) %in% drops)]
View(test_bh)
colnames(test_bh)[16] <- "class"
colnames(train_bh)[15] <- "class"
test_bh$class[test_bh$class == 0] <- NA

################################################################################################################################
# Second iteration of the training set. Accuracies not acceptable yet

train_bh <- read.dbf("T:/WilliamPenn_Share/EDS/BARE_HILLS/DATA/SPATIAL/segout_18/seg_merged_18_training.dbf",
                     as.is=FALSE)
colnames(train_bh)

drops <- c("FID_1","label" ,"id","Distance", "FID_2", "meanB4", "varB4",
           "class_desc", "nbPixels")

train_bh <- train_bh[ , !(names(train_bh) %in% drops)]
View(train_bh)

test_bh <- read.dbf("T:/WilliamPenn_Share/EDS/BARE_HILLS/DATA/SPATIAL/segout_18/seg_merged_18_classify.dbf",
                    as.is=FALSE)
colnames(test_bh)
drops <- c("label" ,"meanB4", "varB4", "nbPixels")
test_bh <- test_bh[ , !(names(test_bh) %in% drops)]
View(test_bh)
colnames(test_bh)[16] <- "class"
colnames(train_bh)[15] <- "class"
test_bh$class[test_bh$class == 0] <- NA

mean(acc)
0.5202681
1 - mean(acc)
0.4797319
rf_bh$confusion[, 'class.error']
1         2         3         4         5         6         7         8        10 
1.0000000 0.3673469 0.2297297 0.6086957 0.9230769 0.3793103 0.3846154 0.2105263 0.2142857 

################################################################################################################################
# Third iteration of the training set. Accuracies not acceptable yet

train_bh <- read.dbf("T:/WilliamPenn_Share/EDS/BARE_HILLS/DATA/SPATIAL/segout_18/seg_merged_18_training2.dbf",
                     as.is=FALSE)
colnames(train_bh)

drops <- c("FID_1","label" ,"id","Distance", "FID_2", "meanB4", "varB4",
           "class_desc", "nbPixels")

train_bh <- train_bh[ , !(names(train_bh) %in% drops)]
View(train_bh)

#train_bh$class_code[train_bh$class_code == 5] <- 11
#train_bh$class_code[train_bh$class_code == 12] <- 13

train_bh$class_code[train_bh$class_code == 5] <- 4
train_bh$class_code[train_bh$class_code == 11] <- 4
train_bh$class_code[train_bh$class_code == 12] <- 6
train_bh$class_code[train_bh$class_code == 13] <- 6

test_bh <- read.dbf("T:/WilliamPenn_Share/EDS/BARE_HILLS/DATA/SPATIAL/segout_18/seg_merged_18_classify2.dbf",
                    as.is=FALSE)
colnames(test_bh)
drops <- c("label" ,"meanB4", "varB4", "nbPixels")
test_bh <- test_bh[ , !(names(test_bh) %in% drops)]
View(test_bh)
colnames(test_bh)[16] <- "class"
colnames(train_bh)[15] <- "class"
test_bh$class[test_bh$class == 0] <- NA

hist(train_bh$class, xlim=c(1,15),breaks=15)
summary(train_bh$class)

xlabs = c("Water","Deciduous","Coniferous","Shrub Scrub","Grass","Barren",
          "Impervious Building","Impervious Pavement","Shadow")

plot(train_bh$class,train_bh$meanB5)
plot(train_bh$class,train_bh$meanB7)
plot(train_bh$class,train_bh$meanB3)
plot(train_bh$class,train_bh$meanB0)
plot(train_bh$class,train_bh$meanB2)
plot(train_bh$class,train_bh$meanB1)

ntree = 5400
mtry = 6
mean(acc)
0.6778368
mean(err)
0.3221632
rf_bh$confusion[, 'class.error']
1          2          3          6          7          8         10         11         13 
0.00000000 0.33673469 0.22972973 0.66666667 0.23076923 0.05263158 0.28571429 0.47222222 0.62500000 
accuracy
1.0000000  0.6632653  0.7702703  0.3333333  0.7692308  0.9473684  0.7142857  0.5277778  0.3750000

################################################################################################################################
################################################################################################################################
# Fourth iteration of the training set. Accuracies not acceptable yet

train_bh <- read.dbf("T:/WilliamPenn_Share/EDS/BARE_HILLS/DATA/SPATIAL/segout_18/seg_merged_18_training3.dbf",
                     as.is=FALSE)
colnames(train_bh)

drops <- c("FID_1","label" ,"id","Distance", "FID_2", "meanB4", "varB4",
           "class_desc", "nbPixels")

train_bh <- train_bh[ , !(names(train_bh) %in% drops)]
#View(train_bh)

# METHOD 1
#train_bh$class_code[train_bh$class_code == 5] <- 4
#train_bh$class_code[train_bh$class_code == 11] <- 4
#train_bh$class_code[train_bh$class_code == 12] <- 6
#train_bh$class_code[train_bh$class_code == 13] <- 6

# METHOD 2
#train_bh$class_code[train_bh$class_code == 5] <- 11
#train_bh$class_code[train_bh$class_code == 12] <- 13

# METHOD 3
train_bh$class_code[train_bh$class_code == 3] <- 2
train_bh$class_code[train_bh$class_code == 5] <- 4
train_bh$class_code[train_bh$class_code == 8] <- 7
train_bh$class_code[train_bh$class_code == 11] <- 4
train_bh$class_code[train_bh$class_code == 12] <- 6
train_bh$class_code[train_bh$class_code == 13] <- 6

test_bh <- read.dbf("T:/WilliamPenn_Share/EDS/BARE_HILLS/DATA/SPATIAL/segout_18/seg_merged_18_classify3.dbf",
                    as.is=FALSE)
colnames(test_bh)
drops <- c("label" ,"meanB4", "varB4", "nbPixels")
test_bh <- test_bh[ , !(names(test_bh) %in% drops)]
#View(test_bh)
colnames(test_bh)[16] <- "class"
colnames(train_bh)[15] <- "class"
test_bh$class[test_bh$class == 0] <- NA

hist(train_bh$class, xlim=c(1,15),breaks=15)
summary(train_bh$class)

xlabs = c("Water","Deciduous","Coniferous","Shrub Scrub","Grass","Barren",
          "Impervious Building","Impervious Pavement","Shadow")

# No Alterations
ntree = 5400
mtry = 8
Accuracy : 0.6506         
95% CI : (0.5381, 0.752)
No Information Rate : 0.3012         
P-Value [Acc > NIR] : 5.509e-11      
Kappa : 0.5659  

# METHOD 1
ntree = 5400
mtry = 8
Accuracy : 0.7229 
95% CI : (0.6138, 0.8155)
No Information Rate : 0.3976    
P-Value [Acc > NIR] : 1.944e-09  
Kappa : 0.6285

# METHOD 2
ntree = 5400
mtry = 8
Accuracy : 0.6627          
95% CI : (0.5505, 0.7628)
No Information Rate : 0.3012          
P-Value [Acc > NIR] : 1.234e-11       
Kappa : 0.58  

# METHOD 3
ntree = 5400
mtry = 8
Accuracy : 0.7952          
95% CI : (0.6924, 0.8759)
No Information Rate : 0.4337          
P-Value [Acc > NIR] : 1.817e-11       
Kappa : 0.6728     

################################################################################################################################
################################################################################################################################
################################################################################################################################
# FINAL ITERATION, ACCURACY IS ACCEPTABLE

# Load in the training data and drop columns we do not want to analyze
train_bh <- read.dbf("T:/WilliamPenn_Share/EDS/BARE_HILLS/DATA/SPATIAL/segout_18/seg_merged_18_training4.dbf",
                     as.is=FALSE)
colnames(train_bh)
drops <- c("FID_1","label" ,"id","Distance", "FID_2", "meanB4", "varB4",
           "class_desc", "nbPixels", "lat", "lon")

train_bh <- train_bh[ , !(names(train_bh) %in% drops)]
#View(train_bh)

# The different methods refer to a reclassification of the hand-classified points
# Method 3 has best accuracy but was the coarsest resoltuion

# METHOD 1
#train_bh$class_code[train_bh$class_code == 5] <- 4
#train_bh$class_code[train_bh$class_code == 11] <- 4
#train_bh$class_code[train_bh$class_code == 12] <- 6
#train_bh$class_code[train_bh$class_code == 13] <- 6

# METHOD 2
#OLD##train_bh$class_code[train_bh$class_code == 5] <- 11
#OLD##train_bh$class_code[train_bh$class_code == 12] <- 13

#train_bh$class_code[train_bh$class_code == 5] <- 4
#train_bh$class_code[train_bh$class_code == 11] <- 4
#train_bh$class_code[train_bh$class_code == 12] <- 13

# METHOD 3
#train_bh$class_code[train_bh$class_code == 3] <- 2
#train_bh$class_code[train_bh$class_code == 5] <- 4
#train_bh$class_code[train_bh$class_code == 8] <- 7
#train_bh$class_code[train_bh$class_code == 11] <- 4
#train_bh$class_code[train_bh$class_code == 12] <- 6
#train_bh$class_code[train_bh$class_code == 13] <- 6

# METHOD 4
train_bh$class_code[train_bh$class_code == 3] <- 2
train_bh$class_code[train_bh$class_code == 5] <- 4
train_bh$class_code[train_bh$class_code == 8] <- 7
train_bh$class_code[train_bh$class_code == 11] <- 4
train_bh$class_code[train_bh$class_code == 12] <- 13

# Load in the unclassified dataset to run through the RF model

test_bh <- read.dbf("T:/WilliamPenn_Share/EDS/BARE_HILLS/DATA/SPATIAL/segout_18/seg_merged_18_classify4.dbf",
                    as.is=FALSE)
colnames(test_bh)
drops <- c("label" ,"meanB4", "varB4", "nbPixels")
test_bh <- test_bh[ , !(names(test_bh) %in% drops)]
#View(test_bh)
colnames(test_bh)[16] <- "class"
colnames(train_bh)[15] <- "class"
test_bh$class[test_bh$class == 0] <- NA

hist(train_bh$class, xlim=c(1,15),breaks=15)
summary(train_bh$class)

# METHOD 1
ntree = 5400
mtry = 8
Accuracy: 	 0.758241758241758 
Lower 95% CI: 	 0.657165598547952 
Upper 95% CI: 	 0.841870186064057 
Kappa: 		 0.675158202174266 
Accuracy Null: 	 0.417582417582418 
PValue: 	 4.18894489914752e-11

# METHOD 2
ntree = 5400
mtry = 8
Accuracy: 	 0.692307692307692 
Lower 95% CI: 	 0.58682944309372 
Upper 95% CI: 	 0.784858161810888 
Kappa: 		 0.620381406436234 
Accuracy Null: 	 0.318681318681319 
PValue: 	 3.11108571117649e-13 

# METHOD 3
ntree = 5300
mtry = 8
Accuracy: 	 0.835164835164835 
Lower 95% CI: 	 0.742742663420269 
Upper 95% CI: 	 0.904704029789513 
Kappa: 		 0.74428624953166 
Accuracy Null: 	 0.417582417582418 
PValue: 	 2.8737038158156e-16    

# METHOD 4
ntree = 5400
mtry = 8
Accuracy: 	 0.758241758241758 
Lower 95% CI: 	 0.657165598547952 
Upper 95% CI: 	 0.841870186064057 
Kappa: 		 0.653453349489354 
Accuracy Null: 	 0.395604395604396 
PValue: 	 2.21498595468635e-12 

################################################################################################################################

# Create a function to easily test the training set
compareRF <- function(rf_test, data,...) {
  p2_bh <- predict(rf_test, data)
  p2_bh_cm <- confusionMatrix(p2_bh, data$class)
  a <- data.frame(p2_bh_cm$overall)
  cat(paste("\n\tAccuracy: \t",a[1,],
            "\n\tLower 95% CI: \t",a[3,],
            "\n\tUpper 95% CI: \t",a[4,],
            "\n\tKappa: \t\t",a[2,],
            "\n\tAccuracy Null: \t",a[5,],
            "\n\tPValue: \t",a[6,],"\n\n"
  ))
}

# The classifiers are now integers, we want them as factors
str(train_bh)
str(test_bh)
train_bh$class <- as.factor(train_bh$class)
table(train_bh$class)
test_bh$class <- as.factor(test_bh$class)
table(test_bh$class)

# Partition the training dataset to assess how well the RF performs, trian parameters etc...
set.seed(123) # For reproducibility
ind_bh <- sample(2, nrow(train_bh), replace = TRUE, prob = c(0.80, 0.20)) # Independant samples, more 1s than 2s
head(ind_bh)
nrow(train_bh[which(ind_bh == 1),])
nrow(train_bh[which(ind_bh == 2),])
# from the original set, get 70% for training the RF and leave 30% for testing how the RF model performs
train_bh_train <- train_bh[ind_bh==1,]
train_bh_test <- train_bh[ind_bh==2,]

# View(train_bh_train)

# Random Forest
# Predict new data using training rf data
set.seed(222) # For Reproducibiloty
rf_bh <- randomForest(class~., data=train_bh, # Dot is for all other vars
                   ntree = 5400,
                   mtry = 8,
                   importance = TRUE,
                   proximity = TRUE#,
                   #do.trace = TRUE
        )
compareRF(rf_bh, train_bh_test)
print(rf_bh)
attributes(rf_bh)
rf_bh$confusion[, 'class.error']
err <- rf_bh$confusion[, 'class.error']
err <- data.frame(err)
acc <- 1 - err[,1]
round(acc,7)
mean(acc)
1 - mean(acc)

# Prediction & Confusion Matrix - train data
# Test to see how the model performed against training set
p1_bh <- predict(rf_bh, train_bh_train)
head(p1_bh)
head(train_bh_train$class)
# See how many misclassifications there were
# The model is very good at classifying the training data set
confusionMatrix(p1_bh, train_bh_train$class)

# # Prediction & Confusion Matrix - test data. THE REAL TEST

compareRF(rf_bh, train_bh_test)

# Error rate of Random Forest, errors level off around 500 so increasing ntree would not yeild better results
plot(rf_bh, xlim=c(0,5400))

# Tune mtry, tune the mtry parameter to minimize errors
# We find we minimize OOB error with an mtry of 8!!!
t_bh <- tuneRF(train_bh[,-15], train_bh[,15],
            stepFactor = 0.5, #mtry inflated or deflated by this factor, try smaller if plot underwhelms
            plot = TRUE,
            ntreeTry = 5400,
            trace = TRUE,
            improve = 0.05) # relative improvement of OOB error must be by this much to continue

# No. of nodes for the trees
hist(treesize(rf_bh),
     main = "No. of Nodes for the Trees",
     col = "orangered", breaks =30)

# Variable Importance, which play the biggest role, higher x-value is more important for prediction accuracy
varImpPlot(
           rf_bh,
           sort = T,
           n.var = 14,
           main = "Top Variable Importance")
# The quantitative values of the above
importance(rf_bh)
# Find out which variables are acually used in nodes for RF, 5 = occurred 5 times, count over to determine which var
varUsed(rf_bh)

rf_bh$confusion

# # Prediction & Confusion Matrix - test data. THE REAL TEST and SET THE CLASS TO THE RF VALUES
set.seed(222) # For Reproducibiloty
p3_bh <- predict(rf_bh, test_bh)
test_bh$class <- p3_bh
confusionMatrix(p3_bh, test_bh$class)
View(p3_bh)
View(test_bh)
print(predict(rf_bh, test_bh))

getTree(rf_bh, 1, labelVar = TRUE)

tree <- getTree(rf_bh, k=1, labelVar=TRUE)
tree

# Output to a dbf, load in ArcGIS, and join to the segmented image
write.dbf(test_bh,"T:/WilliamPenn_Share/EDS/BARE_HILLS/DATA/SPATIAL/segout_18/seg_merged_18_classified5_method4.dbf")

###############################################################################################
###############################################################################################
###############################################################################################
###############################################################################################
###############################################################################################
tree_num <- which(rf_bh$forest$ndbigtree == max(rf_bh$forest$ndbigtree))
tree_num
tree_func(final_model = rf_bh, tree_num)

png("T:/WilliamPenn_Share/EDS/BARE_HILLS/GRAPHICS/TABLES_FIGURES/maxTree_method4.png", width = 3000, height = 750)
tree_func(final_model = rf_bh, tree_num)
dev.off()


# CREATE THE FUNCTION TO MAKE THE NICE RF TREE GRAPHs
tree_func <- function(final_model, 
                      tree_num) {
  
  # get tree by index
  tree <- randomForest::getTree(final_model, 
                                k = tree_num, 
                                labelVar = TRUE) %>%
    tibble::rownames_to_column() %>%
    # make leaf split points to NA, so the 0s won't get plotted
    dplyr::mutate(`split point` = ifelse(is.na(prediction), `split point`, NA))
  
  # prepare data frame for graph
  graph_frame <- data.frame(from = rep(tree$rowname, 2),
                            to = c(tree$`left daughter`, tree$`right daughter`))
  
  # convert to graph and delete the last node that we don't want to plot
  graph <- graph_from_data_frame(graph_frame) %>%
    delete_vertices("0")
  
  # set node labels
  V(graph)$node_label <- gsub("_", " ", as.character(tree$`split var`))
  V(graph)$leaf_label <- as.character(tree$prediction)
  V(graph)$split <- as.character(round(tree$`split point`, digits = 2))
  
  # plot
  plot <- ggraph(graph, 'dendrogram') + 
    theme_bw() +
    geom_edge_link() +
    geom_node_point() +
    geom_node_text(aes(label = node_label), na.rm = TRUE, repel = TRUE, size=6, fontface = "bold",vjust=-2) +
    geom_node_label(aes(label = split), vjust = 0.0, na.rm = TRUE, fill = "white", size=6) +
    geom_node_label(aes(label = leaf_label, fill = leaf_label), na.rm = TRUE, 
                    repel = TRUE, colour = "white", fontface = "bold", show.legend = FALSE, size=6) +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank(),
          panel.background = element_blank(),
          plot.background = element_rect(fill = "white"),
          panel.border = element_blank(),
          axis.line = element_blank(),
          axis.text.x = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks = element_blank(),
          axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          plot.title = element_text(size = 18))
  
  print(plot)
}




