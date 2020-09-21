//
//  Networking.swift
//  Experience
//
//  Created by Lambda_School_Loaner_241 on 9/20/20.
//  Copyright © 2020 Lambda_School_Loaner_241. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
}


class Networking: NSObject {
    let baseURL = URL(string: "https://console.firebase.google.com/project/sprintexperience-491cb/database/sprintexperience-491cb/data")!
    var myExp: Experiences? = nil
    typealias CompletionHandler = (Result<Bool, NetworkError>)-> Void
    
    func put(experience: Experiences?, completion: @escaping CompletionHandler) {
        guard let id = experience?.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(id).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        URLSession.shared.dataTask(with: request) {
            (data, _, error) in
            
            if let error = error {
                NSLog("Error putting task to server: \(error)")
                
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
        
        
    }
    
    func fetchExperienceFromServer(completion: @escaping CompletionHandler = {_ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL){
            (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching experience: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                
                return
            }
            
            guard let data = data else {
                NSLog("Error: No data returned from data task")
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                
                let personalExp = try JSONDecoder().decode(Experiences.self, from: data)
                
                self.myExp = personalExp
                
                
                
            } catch {
                NSLog("Error decoding task representations: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.noDecode))
                    
                }
                
                
            }
        }.resume()
        
    }
    
    
    
    
    
}
