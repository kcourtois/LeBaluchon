<img src="https://upload.wikimedia.org/wikipedia/fr/0/0d/Logo_OpenClassrooms.png" width="150" height="150" />

[![Build Status](https://travis-ci.com/kcourtois/LeBaluchon.svg?branch=master)](https://travis-ci.com/kcourtois/LeBaluchon) [![codecov](https://codecov.io/gh/kcourtois/LeBaluchon/branch/master/graph/badge.svg)](https://codecov.io/gh/kcourtois/LeBaluchon)

# LeBaluchon

LeBaluchon is an app made of three tabs:
- Exchange rate : Get the exchange rate between USD and your actual currency.
- Translate: Translate your favorite language to english.
- Weather: Compare the local weather to your good old living town.

# Exchange rate

In exchange rate, you can insert the amount of your local currency and see how much dollars is it worth.
We are retrieving the exchange rate from fixer.io API, updated every day.

# Translate

Here, the user can input text in his own language and get its translation in english.
We are using Google Translate API for this purpose.

# Weather

Here, we are printing weather informations from New York and my home town, Nemours, in France.
We will get these info from OpenWeatherMap API, so we can see temperatures and weather conditions.