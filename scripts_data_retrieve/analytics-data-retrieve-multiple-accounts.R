setwd("/Users/sylvain/Desktop") #set work directory
getwd() #check work directory
require(RGoogleAnalytics) #load RGoogleAnalytics library
# Authorize the Google Analytics account
# This need not be executed in every session once the token object is created 
# and saved

#client.id<-""
#client.secret<-""
#token <- Auth(client.id,client.secret)

# Save the token object for future sessions
#save(token,file="token")

# In future sessions it can be loaded by running load("token")
load("token")

ValidateToken(token)

viewID<-GetProfiles(token)
viewID

df<-data.frame()
analyticsviewID<-data.frame() #initialize frame to add one column in the CSV with the analytics View ID
for (v in c("13708799","39852040")){ #GA accounts
  start.date <- "2014-04-01"
  end.date <- "2014-04-05"
  view.id <- paste("ga:",v,sep="") #the View ID parameter needs to have "ga:" in front of the ID 
  query.list <- Init(start.date = start.date, 
                     end.date = end.date, 
                     dimensions = "ga:date,ga:deviceCategory", 
                     metrics = "ga:sessions, ga:users", 
                     table.id = view.id, 
                     max.results = 10000)
  ga.query <- QueryBuilder(query.list)
  ga.data <- GetReportData(ga.query, token,split_daywise = T,paginate_query = F)

analyticsviewID<-cbind(ga.data,v)
df<-rbind(df,analyticsviewID)

}
class(df$date)
newDate<-as.Date(df$date,"%Y%m%d")  #convert into date data type
df$date<- format(newDate,"%d/%m/%Y") #to change format, but it convets it back to character class
df$date<- as.Date(df$date,"%d/%m/%Y")  #convert it back to date data type
print(df) #print the final file in the console
write.csv(df, "google_analytics.csv")