# Linear algebra HW - gene expression for Leukemia

# Notes:
# Dataset contains gene expression profiles for three types of Leukemia.
# Due to a lab error, there is a chance that one of the samples is mislabeled.
# Assignment is to determine which of the samples that may be.

load('C:/Users/Andrew/Documents/NC State Center for Advanced Analytics/Linear Algebra/HW/LeukError.Rdata')

names(leuk) #5000 genes
length(leuk)

leuk$V5001 # this column says what type of leukemia it is
           # ALL-B, ALL-T, AML
           # The data has 38 rows = 38 labeled samples

# Compute covariance PCA (note the scale=F option)

pca = prcomp(leuk[,1:5000], scale=F) # don't include the column of leukemia type

plot(pca)

head(pca)

summary(pca)

plot(pca$x) #plot the first and second principal components

# Pick out a color palatte for the Leukemia type:

colors <- c("cyan",
            "red",
            "green")

# Plot this 5000-dimensional data projected into two dimensions:

plot(pca$x, col = colors[leuk$V5001], pch = 16, cex=2) # these are the first 2 PCA scores for each sample
text(pca$x[,1], pca$x[,2],leuk$V5001, cex=0.5)


# Plot this 5000-dimensional data projected into three dimensions:

library(rgl)
library(car)
scatter3d(x=pca$x[,1],y=pca$x[,2],z=pca$x[,3], groups=leuk$V5001, surface=F, labels=leuk$V5001, id.n = 38) #id.n is the number of observations

# based on the 2D and 3D plots, it looks like the AML sample
# at less than -20000 on PC1 may actually be ALL-T

pc1 = cbind(pca$x[,1], leuk$V5001) # ALL-B = 1, ALL-T = 2, AML = 3

AML = pc1[pc1[,2]==3,] #identify the PC1 scores for samples labeled AML

# Sample 22 is probably mislabeled and should be ALL-T
# It already looks suspicious because in the column of
# leukemia types it is a 3 in the middle of 2's