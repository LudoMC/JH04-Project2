#Retrieve the file
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
if (!file.exists("data")) {
    dir.create("data")
}
download.file(fileURL, destfile = "./data/nei.zip", method="curl")
unzip("data/nei.zip", exdir = "./data")

#Read the files
nei <- readRDS("./data/summarySCC_PM25.rds")
scc <- readRDS("./data/Source_Classification_Code.rds")
nei$year <- factor(nei$year)
nei$type <- factor(nei$type)
nei$Pollutant <- factor(nei$Pollutant)

#Getting Baltimore data
nei_baltimore <- subset(nei, fips =="24510")

library(ggplot2)
library(reshape2)

baltimoreMelt <- melt(nei_baltimore, id=c("year", "type"), measure.vars = "Emissions")
baltimoreMeltSum <- dcast(baltimoreMelt, year + type ~ "Emission", fun.aggregate = sum)

#Plot to png
png(filename = "plot3.png", width = 480, height = 480)
g <- ggplot(baltimoreMeltSum, aes(year, Emission))
g + geom_point(col = "steelblue", size = 3) +
    facet_grid(. ~ type) +
    geom_area(aes(group = 1), alpha=1/2, fill="steelblue") +
    geom_smooth(method="lm", aes(group=1), se=FALSE, col="red", lwd = 1) +
    labs(title="Total Emission per type in Baltimore City, MD")
dev.off()
