//
//  WeatherAPI.swift
//  WeatherBar
//
//  Created by Rob Porter on 24/10/2017.
//  Copyright © 2017 Etsy. All rights reserved.
//

import Foundation

struct Weather {
    var city: String
    var currentTemp: Float
    var conditions: String
    var icon: String
    
    var description: String {
        return "\(city): \(currentTemp)F and \(conditions)"
    }
}

class WeatherAPI {
    let API_KEY = "97ddcd39046245ef65bdc386d5449988"
    let BASE_URL = "http://api.openweathermap.org/data/2.5/weather"
    
    func fetchWeather(_ query: String, success: @escaping (Weather) -> Void) {
        let session = URLSession.shared
        let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: "\(BASE_URL)?APPID=\(API_KEY)&units=imperial&q=\(escapedQuery!)")
        let task = session.dataTask(with: url!) {data,response,err in
            if let error = err {
                NSLog("Weather API error: \(error)")
            }
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    if let weather = self.weatherFromJSONData(data!) {
                        success(weather)
                    }
                case 401:
                    NSLog("Weather API returned an 'unauthorised' response.  Did you set your API Key correctly?")
                default:
                    NSLog("Weather API returned response: %d %@",httpResponse.statusCode,HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                }
            }
        }
        task.resume()
    }
    
    func weatherFromJSONData(_ data: Data) -> Weather? {
        typealias JSONDict = [String:AnyObject]
        let json: JSONDict
        do {
            json = try JSONSerialization.jsonObject(with: data, options: []) as! JSONDict
        } catch {
            NSLog("JSON parsing failed: \(error)")
            return nil
        }
        
        var mainDict = json["main"] as! JSONDict
        var weatherList = json["weather"] as! [JSONDict]
        var weatherDict = weatherList[0]
        
        let weather = Weather(
            city: json["name"] as! String,
            currentTemp: mainDict["temp"] as! Float,
            conditions: weatherDict["main"] as! String,
            icon: weatherDict["icon"] as! String
        )
        
        return weather
    }
}
