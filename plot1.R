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

#Plot to png
png(filename = "plot1.png", width = 480, height = 480)
plot(levels(nei$year), tapply(nei$Emissions, nei$year, sum),
     col="red", type="l", lwd=2, xlab="Year", ylab="Sum of Emissions", main="Sum of PM2.5 Emission per year")
dev.off()
