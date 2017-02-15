# Linear algebra HW - gene expression for Leukemia

load('C:/Users/Andrew/Documents/NC State Center for Advanced Analytics/Linear Algebra/HW/LeukError.Rdata')

names(leuk)
names(B)

leuk$V5001 # this says what type of leukemia it is
            # ALL-B, ALL-T, AML
           # The data has 38 rows = 38 labeled samples

# Compute covariance PCA (note the scale=F option)

pca = prcomp(leuk[,1:5000], scale=F) # don't include the column of leukemia type

plot(pca)

head(pca)

summary(pca)

plot(pca$x)

# Pick out a color palatte for the Leukemia type that would make Dr. Healey Proud:

colors <- c("cyan",
            "red",
            "green")

# Plot this 5000-dimensional data projected into two dimensions:

plot(pca$x, col = colors[leuk$V5001], pch = 16, cex=2) # these are the first 2 PCA scores for each sample
text(pca$x[,1], pca$x[,2],leuk$V5001, cex=0.5)


# Plot this 5000-dimensional data projected into three dimensions:

library(rgl)
library(car)
scatter3d(x=pca$x[,1],y=pca$x[,2],z=pca$x[,3], groups=leuk$V5001, surface=F, labels=leuk$V5001, id.n = 38) #id.n looks like the number of observations

# based on the 2D and 3D plots, it looks like the AML sample
# at less than -20000 on PC1 may actually be ALL-T

pc1 = cbind(pca$x[,1], leuk$V5001) # ALL-B = 1, ALL-T = 2, AML = 3

AML = pc1[pc1[,2]==3,]

# Sample 22 is probably mislabeled and should be ALL-T
# It already looks suspicious because in the column of
# leukemia types it is a 3 in the middle of 2's


#  Code from other PCA examples ######################################

# Get the dataset in order, create the target variable which is missing:

chicken = as.data.frame(t(chicken))
diet = as.factor(c(rep("N",6),rep("F16",5),rep("F16R5",8), rep("F16R16",9),rep("F48",6),rep("F48R24",9)))
chicken = cbind.data.frame(diet,chicken)

# Compute covariance PCA (note the scale=F option)

pca = prcomp(chicken[,2:7407], scale=F) # Do not include the factor diet in the PCA computation
