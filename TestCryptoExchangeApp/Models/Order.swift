//
//  Order.swift
//  TestCryptoExchangeApp
//
//  Created by User on 2024-01-19.
//

import Foundation

struct OrderBookResponse: Decodable {
    let bids: [Order]
    let asks: [Order]
}

struct Order: Decodable, Hashable {
    let price: String
    let amount: String
}
