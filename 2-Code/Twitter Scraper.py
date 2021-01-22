# -*- coding: utf-8 -*-
"""
Editor de Spyder

Este es un archivo temporal.
"""

###Loading packages###
import pandas
import twitterscraper as ts
from twitterscraper import query_tweets
import datetime as dt
import pandas as pd


###Twitterscrapper settings
begin_date = dt.date(2016,1,1)
end_date = dt.date(2016,10,10)
limit = 8000
lang = "english"

#Tweets from the Wall Street Journal
tweets = query_tweets("Trump from:WSJ", begindate = begin_date, enddate = end_date, limit = limit, lang = lang, poolsize=100)

df1 = pd.DataFrame(t.__dict__ for t in tweets)

tweets = query_tweets("Clinton from:WSJ", begindate = begin_date, enddate = end_date, limit = limit, lang = lang, poolsize=1000)

df2 = pd.DataFrame (t.__dict__ for t in tweets)

#Tweets from Bloomberg
tweets = query_tweets("Trump from:business", begindate = begin_date, enddate = end_date, limit = limit, lang = lang, poolsize=100)

df3 = pd.DataFrame (t.__dict__ for t in tweets)

tweets = query_tweets("Clinton from:business", begindate = begin_date, enddate = end_date, limit = limit, lang = lang, poolsize=100)

df4 = pd.DataFrame (t.__dict__ for t in tweets)

#Tweets from TheEconomist
tweets = query_tweets("Trump from:TheEconomist", begindate = begin_date, enddate = end_date, limit = limit, lang = lang, poolsize=100)

df5 = pd.DataFrame (t.__dict__ for t in tweets)

tweets = query_tweets("Clinton from:TheEconomist", begindate = begin_date, enddate = end_date, limit = limit, lang = lang, poolsize=100)

df6 = pd.DataFrame (t.__dict__ for t in tweets)

#Joining the dataframes together
frames = [df1, df2, df3, df4, df5, df6]

df = pd.concat(frames)

#Export the final dataframe into a csv
export_csv = df.to_csv (r'trump_wsj.csv', index = None, header=True)
