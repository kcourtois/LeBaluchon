//
//  ApiKeys.swift
//  LeBaluchon
//
//  Created by Kévin Courtois on 06/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation

class ApiKeys {
    static let fixerBaseURL: String = "http://data.fixer.io/api/"
    /*
     GET
     http://data.fixer.io/api/latest?access_key=[APPKEY]&base=EUR&symbols=USD

     {
         "success": true,
         "timestamp": 1557122645,
         "base": "EUR",
         "date": "2019-05-06",
         "rates": {
         "USD": 1.119207
         }
     }

     */

    static let googleTranslateBaseURL: String = "https://translation.googleapis.com/language/translate/v2"
    /*
     POST key=apikey, source=fr, target =en, q=text to translate
     https://translation.googleapis.com/language/translate/v2?key=[APPKEY]&source=fr&target=en&q=bonjour

     {
         "data": {
             "translations": [
                 {
                 "translatedText": "Hello, my name is Kévin"
                 }
             ]
         }
     }

     */

    static let openWeatherBaseURL: String = "api.openweathermap.org/data/2.5/weather"
    /*
     GET appid=apikey, q=city

     api.openweathermap.org/data/2.5/weather?q=Nemours,FR&appid=[APPKEY]

    {
        "coord": {
            "lon": 2.7,
            "lat": 48.27
        },
        "weather": [
        {
        "id": 800,
        "main": "Clear",
        "description": "clear sky",
        "icon": "01d"
        }
        ],
        "base": "stations",
        "main": {
            "temp": 282.83,
            "pressure": 1024,
            "humidity": 61,
            "temp_min": 282.04,
            "temp_max": 284.26
        },
        "visibility": 10000,
        "wind": {
            "speed": 1.5,
            "deg": 340
        },
        "clouds": {
            "all": 0
        },
        "dt": 1557132399,
        "sys": {
            "type": 1,
            "id": 6543,
            "message": 0.0062,
            "country": "FR",
            "sunrise": 1557116575,
            "sunset": 1557169722
        },
        "id": 2990793,
        "name": "Nemours",
        "cod": 200
    }*/

    static let fixerKey: String = "55109e65d35de13bace3f8c5f0197fe6"
    static let googleTranslateKey: String = "AIzaSyBgwZKst7A-OkBx1uskllQ-6RE-IyTSzf8"
    static let openWeatherKey: String = "d7dd4dd708fae6201d133f948ab3ea38"
}
