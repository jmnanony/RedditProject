library(dplyr)

######################################################################
# Scale features, run kmeans, and plot versus cluster count. Then manually select count.
rawfeatures <- select(trdata, day, time, type, length)
features <- scale(rawfeatures)

wss <- (nrow(features)-1)*sum(apply(features,2,var))
for (i in 2:15) wss[i] <- sum(kmeans(features, centers=i, nstart = 25, iter.max = 15)$withinss)

plot(1:15, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")

