//
//  Currency.swift
//  Eurates
//
//  Created by Daniel Frost on 18/04/2018.
//  Copyright © 2018 Daniel Frost. All rights reserved.
//

import Foundation

class Currency {
    let flag: String
    let abbreviation: String
    let symbol: String
    let rate: Float
    
    init(flag: String, abbreviation: String, symbol: String, rate: Float) {
        self.flag = flag
        self.abbreviation = abbreviation
        self.symbol = symbol
        self.rate = rate
    }
}
