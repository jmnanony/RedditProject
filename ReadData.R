library(dplyr)

setwd("C:/Users/Mark Nelson/PycharmProjects/RedditProject")

#######################################################################
# Read data. Manipulate for features.
srdata <- lapply(Sys.glob("./Data/YearTop-*.txt"), read.table, header = TRUE, sep = "\t", quote = "", colClasses = c("factor", "numeric", "integer", "character", "factor", "character"))
srdata <- do.call("rbind", srdata)
srdata <- mutate(srdata, date = .POSIXct(srdata$created_utc, tz="UTC"))
srdata <- mutate(srdata, day = as.integer(strftime(date, format="%w")))
srdata <- mutate(srdata, time = as.integer(strftime(date, format="%H")))
srdata <- mutate(srdata, type = as.integer(ifelse(domain %in% c("i.imgur.com", "imgur.com"), 1,
                                       ifelse(domain %in% c("youtube.com", "youtu.be", "gfycat.com"), 2,
                                              3))))
srdata <- mutate(srdata, length = nchar(title))

# Divide train (60%) and test (40%) sets.
set.seed(12345)
srdata <- mutate(srdata, train = ifelse((runif(nrow(srdata)) < 0.6), 1, 0))
trdata <- filter(srdata, train == 1)
tedata <- filter(srdata, train == 0)


