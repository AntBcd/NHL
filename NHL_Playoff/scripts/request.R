library(httr2)
library(lubridate)
library(dplyr)
library(data.table)

getStandingsCharacts <- function() {
base_url <- "https://api-web.nhle.com/"

rq <- request(base_url)

rq <- rq %>% req_url_path("v1/standings-season")

resp <-  req_perform(rq)
resp %>% resp_status_desc()

stands <- resp_body_json(resp)


stands <- data.frame(matrix(unlist(rbind(stands$seasons)),
                               nrow = length(stands$seasons),
                               byrow = TRUE))

colnames(stands) <- c("id", "conferencesInUse", "divisionsInUse",
                         "pointForOTlossInUse", "regulationWinsInUse",
                         "rowInUse", "standingsEnd", "standingsStart",
                         "tiesInUse", "wildcardInUse")

for (i in c("conferencesInUse", "divisionsInUse", "pointForOTlossInUse",
            "regulationWinsInUse", "rowInUse", "tiesInUse", "wildcardInUse")) {
    stands[, i] <- as.logical(stands[, i])
}

for (i in c("standingsEnd", "standingsStart")) {
    stands[, i] <- as.Date(stands[, i], format = "%Y-%m-%d")
}
stands
}

standsChar <- getStandingsCharacts()

startYear <- 2000
endYear <- 2025

# getStandings(startYear, endYear (default == year(sys.time)), standsChar=standsChar)

base_url <- "https://api-web.nhle.com/v1/standings/"
rq <- request(base_url)

annees <- c()

for (x in standsChar$standingsEnd)
    {
    if ((year(as.Date(x)) >= startYear) & (year(as.Date(x)) <= endYear)) {
        print(rq)
        rq <- rq %>% req_url_path_append(as.character(as.Date(x)))
        print(rq)
        resp <- req_perform(rq)
        stands <- resp_body_json(resp)
    }
    }

for (i in years) {

rq <- rq %>% req_url_path(standEnd)

resp <-  req_perform(rq)
resp %>% resp_status_desc()

stands <- resp_body_json(resp)
}
class(stands$standings)

df <- sapply(1:ncol(df), function(x) rbind(stands$standings)

df <- unlist(stands$standings)
