//
//  Candle.swift
//  TestCryptoExchangeApp
//
//  Created by User on 2024-01-19.
//

import Foundation

struct Candle {
    let timestamp: Double
    let open: Double
    let close: Double
    let high: Double
    let low: Double
    // Additional properties if needed

    init(data: [Any]) {
        timestamp = data[0] as! Double
        open = data[1] as! Double
        close = data[2] as! Double
        high = data[3] as! Double
        low = data[4] as! Double
    }
}
