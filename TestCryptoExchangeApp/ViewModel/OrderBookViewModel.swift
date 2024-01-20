//
//  OrderBookViewModel.swift
//  TestCryptoExchangeApp
//
//  Created by User on 2024-01-19.
//

import Foundation
import SwiftUI
import Combine

final class OrderBookViewModel: ObservableObject {
    
    @Published var bids: [Order] = []
    @Published var asks: [Order] = []
    @Published var candleData: [Candle] = []

    private var cancellables: Set<AnyCancellable> = []

    func fetchOrderBook() {
        guard let url = URL(string: "https://api.bitfinex.com/v1/book/btcusd") else {
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: OrderBookResponse.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] orderBookResponse in
                DispatchQueue.main.async {
                    self?.asks = orderBookResponse.asks
                    self?.bids = orderBookResponse.bids
                }
            })
            .store(in: &cancellables)
    }
    
    func fetchChartData() {
        guard let url = URL(string: "https://api.bitfinex.com/v2/candles/trade:1m:tBTCUSD/hist?limit=1000") else {
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [[Double]].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] candles in
                DispatchQueue.main.async {
                    let candleObjects = candles.map { Candle(data: $0) }
                    self?.candleData = candleObjects
                }
            })
            .store(in: &cancellables)
    }
}
