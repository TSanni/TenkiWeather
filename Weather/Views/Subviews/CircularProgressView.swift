//
//  CircularProgressView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/2/24.
//

import SwiftUI

struct CircularProgressView: View {
    let pressure: Double
    
    
//    let maxPressure: Double = 31
    
    var body: some View {
        VStack {
            ZStack {
                
                Circle()
                    .trim(from: 0.0, to: 0.8)
                    .stroke(Color.gray, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(125))
                
                
                Circle()
                    .trim(from: 0.0, to: convertPressureToCircleTrim())
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(125))

                
            }
            
            HStack {
                Text("Low")
                Spacer()
                Text("High")
            }
        }
    }
    
    
    func convertPressureToCircleTrim() -> Double {
//        var circleTrim = (0.8 * pressure) / maxPressure
        var circleTrim: Double = 0
        
        print("CIRCLE TRIM: \(circleTrim)")
        
        if pressure < 29.4 {
            circleTrim = 0.1
        }
        
        if pressure > 29.4 && pressure < 29.8 {
            circleTrim = 0.3
        }
        
        if pressure > 29.8 && pressure < 30.2 {
            circleTrim = 0.4
        }
        
        if pressure > 30.2 && pressure <= 30.5 {
            circleTrim = 0.5
        }
        
        if pressure > 30.5 {
            circleTrim = 0.8
        }

        

        return circleTrim
    }
    
}

#Preview {
    CircularProgressView(pressure: 30)
        .padding()
}
