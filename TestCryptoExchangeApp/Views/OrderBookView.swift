//
//  OrderBookView.swift
//  TestCryptoExchangeApp
//
//  Created by User on 2024-01-19.
//

import Foundation
import SwiftUI

struct OrderBookView: View {
    
    @ObservedObject var orderBookViewModel = OrderBookViewModel()
    
    @State private var timer: Timer?

    var body: some View {
        VStack {
            Text("Order Book")
                .foregroundStyle(Color.white)
            
            let trendColor: Color = {
                guard let firstClose = orderBookViewModel.candleData.prefix(30).first?.close,
                      let lastClose = orderBookViewModel.candleData.prefix(30).last?.close else {
                    return .gray // Default color if data is insufficient
                }
                return lastClose >= firstClose ? .green : .red
            }()
            
            EndingBalanceChart(endingBalance: orderBookViewModel.candleData.prefix(30).compactMap({ candle in
                candle.close
            }))
            .stroke(trendColor, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
            .background(
                EndingBalanceChart(endingBalance: orderBookViewModel.candleData.prefix(30).compactMap({ candle in
                    candle.close
                }), isBackground: true)
                    .fill(.linearGradient(colors: [trendColor.opacity(0.7), .clear], startPoint: .top, endPoint: .bottom))
            )
            .padding(.bottom, 16)
            .padding(.top, 35)
            .background(Color.black)

            HStack {
                List {
                    Section {
                        ForEach(orderBookViewModel.bids, id: \.self) { order in
                            Text("$\(order.price): \(order.amount)")
                                .foregroundStyle(Color.green)
                                .listRowBackground(Color.black)
                                .listRowSeparator(.hidden)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.black)
                
                List {
                    Section {
                        ForEach(orderBookViewModel.asks, id: \.self) { order in
                            Text("$\(order.price): \(order.amount)")
                                .foregroundStyle(Color.red)
                                .listRowBackground(Color.black)
                                .listRowSeparator(.hidden)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.black)
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .background(Color.black)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            DispatchQueue.main.async {
                self.orderBookViewModel.fetchChartData()
                self.orderBookViewModel.fetchOrderBook()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
