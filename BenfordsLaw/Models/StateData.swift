//
//  StateData.swift
//  ProntoChallenge
//
//  Created by Byron Hundley on 4/3/20.
//  Copyright © 2020 Noryb. All rights reserved.
//

import Foundation

enum ResultType {
    case total, positive, negative
}

struct StateData: Codable {
    var state: String
    var positive: Int
    var negative: Int
    var totalTestResults: Int
}
