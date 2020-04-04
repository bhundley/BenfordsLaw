//
//  DataRequestManager.swift
//  ProntoChallenge
//
//  Created by Byron Hundley on 4/4/20.
//  Copyright © 2020 Noryb. All rights reserved.
//

import Foundation

class DataRequestManager {
    fileprivate let trackingUrl = "https://covidtracking.com/api/states"
//    fileprivate let trackingUrl = "https://covidtracking.com/api/counties"
    
    static let shared = DataRequestManager()
    
    func getData(completion: (([StateData]) -> Void)?) {
        guard let url = URL(string: trackingUrl) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            if let handler = completion, let testData = try? JSONDecoder().decode([StateData].self, from: data) {
                handler(testData)
            }
        }.resume()
    }
}
