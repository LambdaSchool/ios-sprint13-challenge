//
//  QuakeFetcher.swift
//  Quakes
//
//  Created by Paul Solt on 2/13/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import Foundation

enum QuakeError: Int, Error {
    case invalidURL
    case noDataReturned
    case dateMathError
    case decodeError
}

class QuakeFetcher {
    let baseURL = URL(string: "https://earthquake.usgs.gov/fdsnws/event/1/query")!
    let dateFormatter = ISO8601DateFormatter()
    
    func fetchQuakes(completion: @escaping ([Quake]?, Error?) -> Void) {
        
        let endDate = Date()
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.day = -7 // 7 days in the past
        
        guard let startDate = Calendar.current.date(byAdding: dateComponents, to: endDate) else {
            print("Date math error")
            completion(nil, QuakeError.dateMathError)
            return
        }
        
        let interval = DateInterval(start: startDate, end: endDate)
        fetchQuakes(from: interval, completion: completion)
    }
    
    func fetchQuakes(from dateInterval: DateInterval,
                     completion: @escaping ([Quake]?, Error?) -> Void) {
        
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        // startTime, endTime, format
        let startTime = dateFormatter.string(from: dateInterval.start)
        let endTime = dateFormatter.string(from: dateInterval.end)
        
        let queryItems = [
            URLQueryItem(name: "starttime", value: startTime),
            URLQueryItem(name: "endtime", value: endTime),
            URLQueryItem(name: "format", value: "geojson"),
        ]
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            print("Error creating URL from components")
            completion(nil, QuakeError.invalidURL)
            return
        }
        print(url)
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error fetching quakes: \(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let data = data else {
                print("No data")
                DispatchQueue.main.async {
                    completion(nil, QuakeError.noDataReturned)
                }
                return
            }
                        
            do {
                // TODO: Implement decoding and completion call
                let decoder = JSONDecoder()
                
                
                
                decoder.dateDecodingStrategy = .millisecondsSince1970
                
                let quakeResults = try decoder.decode(QuakeResults.self, from: data)
                
                completion(quakeResults.quakes, nil)

                
            } catch {
                print("Decoding error: \(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
        }.resume()
    }
}
