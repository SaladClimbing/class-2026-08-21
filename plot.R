latitude <- 27.3364
longitude <- -82.5307
end_date <- Sys.Date() - 1
start_date <- end_date - 6

request_url <- paste0(
  "https://archive-api.open-meteo.com/v1/archive?",
  "latitude=", latitude,
  "&longitude=", longitude,
  "&start_date=", start_date,
  "&end_date=", end_date,
  "&hourly=temperature_2m,relative_humidity_2m,precipitation,wind_speed_10m",
  "&temperature_unit=fahrenheit",
  "&wind_speed_unit=mph",
  "&precipitation_unit=inch",
  "&timezone=America%2FNew_York",
  "&format=csv"
)

download.file(request_url, "sarasota_hourly_weather.csv", mode = "wb")

weather <- read.csv("sarasota_hourly_weather.csv", skip = 3)
names(weather) <- c("time", "temperature_f", "relative_humidity_percent",
                    "precipitation_inches", "wind_speed_mph")
weather$time <- as.POSIXct(weather$time, format = "%Y-%m-%dT%H:%M", tz = "America/New_York")

png("sarasota_weather.png", width = 1000, height = 700)
plot(weather$time, weather$temperature_f, type = "l", col = "firebrick", lwd = 2,
     xlab = "Date and time", ylab = "Temperature (F)",
     main = "Hourly Weather in Sarasota, Florida")
dev.off()

message("Downloaded ", nrow(weather), " hourly observations from ", start_date,
        " through ", end_date, ".")