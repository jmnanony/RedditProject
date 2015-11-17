library(dplyr)
clustercount <-3

###########################################################
# Find result rule table from running kmeans with chosen cluster count.
# Unscale and create selection rules.
fit <- kmeans(features, centers=clustercount, nstart = 25)
for (i in 1:ncol(features)) {
    fit$centers[,i] <- fit$centers[,i] * sd(rawfeatures[,i]) + mean(rawfeatures[,i])
}
results <- round(as.data.frame(fit$centers))
results <- arrange(results, day, time, type, length)



#######################################################
# Check test data against rules.
# Read test data.

# Indicate in selection column if submission meets the selection rules.
tedata <- select(tedata, score, day, time, type, length)
tedata <- mutate(tedata, selected = 0)
for (i in 1:nrow(results)) {
    rday <- results[i,]$day
    rtime <- results[i,]$time
    rtype <- results[i,]$type
    rlength <- results[i,]$length
    tedata <- mutate(tedata, selected = ifelse(
        (tedata$day == rday) &
        (tedata$time ==rtime) &
        (tedata$type == rtype) &
        (tedata$length > (rlength * 0.8)) &
        (tedata$length < (rlength * 1.2)), i, tedata$selected))
}



# Print summary results
seltd <- filter(tedata, selected > 0)
seltot <- nrow(seltd)
selmean <- mean(seltd$score)
testtot <- nrow(tedata)
testmean <- mean(tedata$score)

print(paste("Full Test Set mean = ", round(testmean)))
print(paste("Only Selected mean = ", round(selmean)))
for (i in 1:nrow(results)) {
    print(paste("Rule:", i, " = ", round(mean(filter(seltd, selected == i)$score))))
}
print(results)






