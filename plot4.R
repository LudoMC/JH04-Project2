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

#Filter on coal only
sccCoal <- scc[grep("Coal", scc$SCC.Level.Three),]
neiCoal <- subset(nei, SCC %in% sccCoal$SCC)

#Plot to png
png(filename = "plot4.png", width = 480, height = 480)
plot(levels(neiCoal$year), tapply(neiCoal$Emissions, neiCoal$year, sum),
     col="red", type="l", lwd=2, xlab="Year", ylab="Sum of Emissions", main="Coal-related emissions")
dev.off()
