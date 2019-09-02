//
//  DarkSkyAPI.swift
//  CalendarApp
//
//  Created by apple on 12/1/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

struct Weather{
    let icon: String
    let temperature: Double
    
    
    enum SerializationError: Error{
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json: [String: Any]) throws{
        guard let icon = json["icon"] as? String else {throw SerializationError.missing("Icon missing")}
        guard let temperature = json["temperatureMax"] as? Double else{throw SerializationError.missing("Temp is missing")}
        
        self.icon = icon
        self.temperature = temperature
    }

    static let basePath = "https://api.darksky.net/forecast/8c369e231f7a8faac24b213b5b271002/"

    static func forecast (withLocation location:String, completion: @escaping ([Weather]) -> ()) {
    
        let url = basePath + location
        let request = URLRequest(url: URL(string: url)!)
    
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
        
            var forecastArray:[Weather] = []
        
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["daily"] as? [String:Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? Weather(json: dataPoint) {
                                        forecastArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                    }
                }catch {
                    print(error.localizedDescription)
                }
                completion(forecastArray)
            }
        }
        task.resume()

    }
}
