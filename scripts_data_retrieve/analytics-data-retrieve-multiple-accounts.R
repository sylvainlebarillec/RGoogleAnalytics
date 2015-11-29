setwd("/Users/sylvain/Desktop") #set work directory
getwd() #check work directory
require(RGoogleAnalytics) #load RGoogleAnalytics library
fix(GetDataFeed)
GetDataFeed <- function(query.uri) {
  
  GA.Data <- GET(query.uri)
  GA.list <- ParseDataFeedJSON(GA.Data)
  if (is.null(GA.list$rows)) {
    cat("Your query matched 0 results. Please verify your query using the Query Feed Explorer and re-run it.\n")
    # break
    return(GA.list)
  } else {
    return (GA.list)
  }
}

# Authorize the Google Analytics account
# This need not be executed in every session once the token object is created 
# and saved

#token <- Auth(client.id,client.secret)

# Save the token object for future sessions
#save(token,file="token_file")

# In future sessions it can be loaded by running load("token")
load("token_file")

ValidateToken(token)

viewID<-GetProfiles(token)
viewID
category_1<- c("13708799", "39852040")
for (v in category_1){
  start.date <- "2014-04-01"
  end.date <- "2014-04-30"
  view.id <- paste("ga:",v,sep="") #the View ID parameter need to have "ga:" in front of the ID 
  
  query.list <- Init(start.date = start.date, end.date = end.date, dimensions = "ga:date,ga:deviceCategory", metrics = "ga:sessions, ga:users, ga:bounceRate", table.id = view.id, max.results = 10000)
  ga.query <- QueryBuilder(query.list)

   ga.data <- GetReportData(ga.query, token, paginate_query = F,split_daywise = F)
 # class(ga.data$date) # dates come as character
 # newDate<-as.Date(ga.data$date,"%Y%M%d")  #convert into date data type
 # newFormat<- format(newDate,"%m/%d/%y") #to change format, but it convets it back to character class
 # newFormat<- as.Date(newFormat,"%d/%m/%y")  #convert it back to date data type
  df<-rbind(df,ga.data)
}
write.csv(df, "google_analytics_API-Q.csv")