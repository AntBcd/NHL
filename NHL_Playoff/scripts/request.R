### This file only goal is to fetch the data from the API and transform it into
# a workable R format.

# DONE: Function to extract and format standings characteristics.
# TODO: Function to extract and format standings stats.


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

#for (x in standsChar$standingsEnd)
x <- "2023-04-14"
    {
    if ((year(as.Date(x)) >= startYear) & (year(as.Date(x)) <= endYear)) {
        print(rq)
        rq <- rq %>% req_url_path_append(as.character(as.Date(x)))
        print(rq)
        resp <- req_perform(rq)
        stands <- resp_body_json(resp)
    }
    }


class(stands$standings)
df <- data.frame()
df <- sapply(1:length(stands$standings), function(x) rbind(df, as.data.frame(stands$standings[[x]])))


for (i in 1:length(stands$standings)) {
    print(dim(as.data.frame(stands$standings[[i]])))
}

dim(df)
class(df)
length(df)
cbind(1:ncol(as.data.frame(stands$standings[[2]])), colnames(as.data.frame(stands$standings[[2]])))
df <- unlist(stands$standings)

# There's a mismatching number of columns which'll have to be fixed to transform
# the data into a usable data frame.
for (i in 1:length(stands$standings)) {
    print(dim(as.data.frame(stands$standings[[i]])))
}
Bruins <- as.data.frame(stands$standings[[1]])
Canes <- as.data.frame(stands$standings[[2]])
Flames <- as.data.frame(stands$standings[[16]])

# One difference comes from teams with a location, like Carolina, that have
# a different name in French and English (Caroline/Carolina) while other teams,
# like Boston, have the same 'placename' in French and English (Boston). 'placeName'
# is only called 'default' for teams with no French translation.

Canes[colnames(Canes) %in% colnames(Bruins)]

# The other difference (for teams with 81 columns) is that only the teams that
# made the playoffs have 'clinchIndicator' column.
Bruins[!colnames(Bruins) %in% colnames(Flames)]
# cbind(1:ncol(as.data.frame(stands$standings[[2]])), colnames(as.data.frame(stands$standings[[2]])), c(colnames(Bruins), NA))