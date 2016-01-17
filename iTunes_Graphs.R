
setwd("Point R to where you have the iTunes Library Data.csv file")

tunes <- read.csv("iTunes Library Data.csv", header=TRUE)
head(tunes)

library(ggplot2)
library(chron)

#Create columns for last played date and time and date and time added
tunes$Last.Play.Date <- as.Date(substr(tunes$Play.Date.UTC, 0, 10))
tunes$Last.Play.Time <- chron(times=substr(tunes$Play.Date.UTC, 12, 19))
tunes$Time.Added <- chron(times=substr(tunes$Date.Added, 12, 19))
tunes$Date.Added <- as.Date(substr(tunes$Date.Added, 0, 10))
#Group play times by hour - note the lubridate will mask function from chron, so run it after lines above
library(lubridate)
tunes$Last.Play.Timestamp <- ymd_hms(paste(tunes$Last.Play.Date, tunes$Last.Play.Time, sep=" "))
tunes$Date.Added.Timestamp <- ymd_hms(paste(tunes$Date.Added, tunes$Time.Added, sep=" "))

#Total play count by genre
pcgenre <- ggplot(tunes, aes(Genre, Play.Count, width=0.8))
pcgenre + stat_summary(fun.y = sum, geom="bar", fill="dodgerblue", color="Black") + coord_flip() + ggtitle("Total Play Count by Genre") + scale_y_continuous(expand = c(0,0))
#Average play count by genre
pcgenre2 <- ggplot(tunes, aes(Genre, Play.Count, width=0.8))
pcgenre2 + stat_summary(fun.y = mean, geom="bar", fill="dodgerblue", color="Black") + coord_flip() + ggtitle("Average Play Count by Genre") + scale_x_discrete(expand = c(0,0)) + scale_y_discrete(expand = c(0,0))

#Library growth over time
growthdf <- data.frame(table(cut(tunes$Date.Added.Timestamp, breaks="weeks")), grp=1)
ggplot(growthdf, aes(Var1, Freq)) + geom_line(aes(group=grp))

#Hour during which songs were last played
playstable <- table(substr(tunes$Last.Play.Time, 1, 2))
playsdf <- data.frame(playstable, grp = 1)
ggplot(playsdf, aes(Var1, Freq)) + geom_line(aes(group = grp)) + xlab("Hour") + ylab("Songs Played") + ggtitle("Hour of the Day that Songs were Last Played")





