##Loading Libraries##
library(car)
library(readr)
library(tidyverse)
library(magrittr)
library(stringr)
library(lubridate)
library(syuzhet)
library(forecast)
library(corrplot)
library(lmtest)
library(tempdisagg)
library(tsbox)
library(zoo)
library(here)

###Loading Datasets###


#Loading and cleaning Twitter dataset
twts16 = read_csv(here("1-CSV Input", "trump_wsj.csv")) %>% 
  distinct()
twts16$timestamp = as.numeric(format(twts16$timestamp, "%U"))
twts16 = twts16 %>% mutate(timestamp = timestamp + 1)
trump.cnn = twts16

#Loading and cleaning of USA GDP dataset
gdp = read_csv(here("1-CSV Input", "gdp.csv"))
colnames(gdp) = c("Date", "gdp")
gdp$Date = as.numeric(format(gdp$Date, "%U"))
gdp = gdp %>% mutate(Date = Date + 1, gdp_log = log(gdp)) %>% select(-gdp)

#Loading and cleaning of USA Unemployment dataset
unrate = read_csv(here("1-CSV Input","UNRATENSA.csv"))
colnames(unrate) = c("Date", "urate")
unrate$Date = as.numeric(format(unrate$Date, "%U"))
unrate = unrate %>% mutate(Date = Date + 1) 

#Loading and cleaning S&P500 dataset
sp500 = read_csv(here("1-CSV Input","SP500.csv")) %>% 
  select(Date, Open)
sp500$Date = as.numeric(format(sp500$Date, "%U"))
sp500 = sp500 %>% mutate(Date = Date+1)
sp500$Date = as.numeric(sp500$Date)


##Temporal disgregation of GDP and Unemployment datasets

#GDP Temporal disgregation
gdp.model = td(gdp$gdp_log ~ 1, conversion = "mean", to = 13.8, method = "uniform")
gdp.df = tibble(gdp.model$values)
gdp.df = gdp.df %>% 
  mutate(loggdpchange = `gdp.model$values` - lag(`gdp.model$values`)) %>% mutate(Date = c(1:56))

gdp.df[1,2] = gdp.df[2,2]
  
#Unemployment temporal disgregation
unrate.model = td(unrate$urate ~ 1, conversion = "mean", to = 5, method = "uniform")
unrate.df = tibble(unrate.model$values)
unrate.df = unrate.df %>% mutate(Date = c(1:60))

##Joining the macroeconomic dataframes together
sp500 = sp500 %>% left_join(unrate.df, by ="Date") %>% left_join(gdp.df, by= "Date")
colnames(sp500) = c("Date","Open","urate","loggdp", "loggdpchange")

  
##Deep cleaning of the tweets dataframe
trump.cnn$dateweek = (trump.cnn$timestamp)

clean_urls = function(x) {  #Deletes URLs from tweets
  x = gsub("http.*","", x)
  x =  gsub("https.*","", x) 
  x = gsub("#.*","", x)
  return(x) 
}

trump.cnn$text = clean_urls(trump.cnn$text)
trump.cnn$text <- str_replace(trump.cnn$text, "@[a-z,A-Z]*","") #deletes tweet handles

trump.cnn = distinct(trump.cnn) #eliminates duplicate tweets 

###Sentiment analysis preparation

word.df = as.vector(trump.cnn$text)
emotion.df = get_nrc_sentiment(word.df)

emotion.df2 = cbind(trump.cnn$dateweek, emotion.df) #Creates a dataframe with the sentiments from each week


feardf = emotion.df2 %>% mutate(num = 1) %>% rename(Date = "trump.cnn$dateweek") #Adds time variable
fearweek = aggregate(. ~Date, data = feardf, sum) #Adds the daily data, by week

##The resulting dataframe tells us how many "fear points" accumulate per week

df = left_join(sp500, fearweek, by= "Date") %>% 
  mutate(change = (((Open/lag(Open))-1)*100)) %>% 
  drop_na()#calcula cambio porcentual del sp500

ggplot(data = df.scaled, mapping = aes(x=Date, y=sc.fear)) +
  geom_line(color = "red")
  
cor(df$fear, df$num)

###Creating the scaled dataframe: how many "fear points" can we expect per tweet, for any given week?

df.scaled = df %>% transmute(sc.anger = anger/num, 
                             sc.anticipation = anticipation/num,
                             sc.disgust = disgust/num,
                             sc.fear = fear/num,
                             sc.joy = joy/num,
                             sc.sadness = sadness/num,
                             sc.surprise = surprise/num,
                             sc.trust = trust/num,
                             sc.positive = positive/num,
                             sc.negative = negative/num,
                             Open = Open,
                             sc.Open = scale(Open),
                             change = change,
                             Date = Date,
                             loggdpchange = loggdpchange,
                             loggdp = loggdp,
                             urate = urate/100)

###Quick data exploration
df.sc.corp = cor(df.scaled %>% select(-Date), method = "pearson") #mira correlaciones
round(df.sc.corp, digits = 2)



###Modelization


#Model 1: One regressor only
model = lm(Open ~ lag(sc.fear), data = df.scaled)

#Model 2: We add controls
model = lm(Open ~ lag(sc.fear) + loggdpchange  + urate + lag(Open), data = df.scaled)

#We test the second model
dwtest(Open ~ lag(sc.fear) + loggdpchange + lag(Open) + urate, data = df.scaled)
vif(model)
summary(model)

#Saving the dataframe used for modelling

write.csv(df.scaled, here("3-Output", "modeldf.csv"))
getwd()
