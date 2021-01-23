# Thesis: "Can the news media influence the stock market?"
> A Twitter Sentiment Analysis Case Study

## Table of contents
* [General info](#general-info)
* [Setup](#setup)
* [Features](#features)
* [Status](#status)
* [Inspiration](#inspiration)
* [Contact](#contact)

## General info
The whole point of this project was to test the power of sentiment analysis with a practical case study. 

The stock market depends on investor's decisions. Decisions depend on expectations. Expectations depend on information. And information is supplied by the news media.

Therefore, maybe the news media can influence the stock market, at least in an indirect way.

To test this hypothesis:

1. I scrapped over nine thousand tweets published during 2016 from The Economist, The Wall Street Journal, and Bloomberg
2. I classified the sentiment of the tweets via the syuzhet package. Each tweet received a sentiment score over 8 emotions and 2 valences
3. I ran a statistical test to check if a specific sentiment (fear) could influence the S&P500 Index

The results were surprising: even after controlling for macroeconomical variables, fear sentiment affected the stock market in a significant way. The surprising thing is that increasing fear drove the market up instead of down, which is counterintuitive.

## Setup
I used
· R (3.6.2 ver)
· Python (3.7.6 ver)

More recent versions can be used. The Python scrapper doesn't require OAuth identification, so you won't need to create a Twitter Developer Account.

Install both programs, install the required packages, change the query parameters if you wish, and you're good to go!

## Features

* Twitter Scrapper: The Python script is ready to scrap tweets. All you need to do is to modify the search terms to suit your needs.
* Sentiment Analysis: The R Script cleans the tweets, runs the sentiment analysis, and an OLS regression to test if a sentiment is relevant
* CSVs with macroeconomic data from 2016: GDP, Unemployment Rates, and the S&P500 prices, by week. 

## Status
Finished

## Inspiration
My thesis tutor inspired me to do "something different" for my thesis. At first I thought about testing the relationship between the sentiment of american politician's tweets and the exchange rate of cryptocurrencies. Such project was impossible: almost no politicians talked about cryptos, so the sample size was too low.

Then I found [a paper that found a relevant relationship between the news media and consumer sentiment](https://ideas.repec.org/p/fip/fedgfe/2004-51.html), and I thought it would be interesting to test if the news media could also affect investors.

## Contact
Created by [Daniel Beleña](https://www.linkedin.com/in/daniel-bele%C3%B1a-gonz%C3%A1lez-949917146/) - feel free to contact me!
