//
//  EndingBalanceChart.swift
//  TestCryptoExchangeApp
//
//  Created by User on 2024-01-19.
//

import Foundation
import SwiftUI

struct EndingBalanceChart: Shape {
    
    var endingBalance: [Double]
    var isBackground: Bool = false
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            for index in endingBalance.indices {
                let xPosition: CGFloat = rect.width / CGFloat(endingBalance.count) * CGFloat(index + 1)
                
                let maxY = endingBalance.max() ?? 600
                let minY = endingBalance.min() ?? 600
                
                let yAxis: CGFloat = CGFloat(maxY - minY)
                
                let yPosition: CGFloat = (1 - CGFloat((Double(endingBalance[index]) - Double(minY)) / yAxis)) * rect.height
                
                if index == 0 {
                    path.move(to: CGPoint(x: 0, y: rect.height))
                }
                
                if index > 0 {
                    let prevXPosition = rect.width / CGFloat(endingBalance.count) * CGFloat(index)
                    let prevYPosition = (1 - CGFloat((Double(endingBalance[index - 1]) - Double(minY)) / yAxis)) * rect.height
                    
                    let controlPoint1 = CGPoint(x: prevXPosition + (xPosition - prevXPosition) * 0.5, y: prevYPosition)
                    let controlPoint2 = CGPoint(x: prevXPosition + (xPosition - prevXPosition) * 0.5, y: yPosition)
                    
                    path.addCurve(to: CGPoint(x: xPosition, y: yPosition), control1: controlPoint1, control2: controlPoint2)
                }
            }
            if isBackground {
                path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            }
        }
    }
}
