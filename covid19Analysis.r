library(covid19.analytics)
library(dplyr)
library(prophet)
library(lubridate)
library(ggplot2)

#Data
tsc<-covid19.data(case = 'ts-confirmed')
View(tsc)
tsc<-tsc%>%filter(Country.Region=='India')
tsc<-data.frame(t(tsc))
tsc<-cbind(rownames(tsc),data.frame(tsc,row.names = NULL))
colnames(tsc)<-c('Date','Confirmed')
tsc<-tsc[-c(1:4),]
tsc$Date<-ymd(tsc$Date)
str(tsc)
tsc$Confirmed<-as.numeric(tsc$Confirmed)

#Plot
qplot(Date,Confirmed,data = tsc,
      main='Covid19 Confirmed Cases In India')
ds<-tsc$Date
y<-tsc$Confirmed
df<-data.frame(ds,y)

#Forecasting
m<-prophet(df)

#Predict
future<-make_future_dataframe(m,periods = 28)
forecast<-predict(m,future)

#Plot forecast
plot(m,forecast)
dyplot.prophet(m,forecast)

#Forecast Components
prophet_plot_components(m,forecast)

#Model performance
pred<-forecast$yhat[1:147]
actual<-m$history$y
plot(actual,pred)
abline(lm(pred~actual),col='red')
summary(lm(pred~actual))
