//
//  CurrentDetailsView.swift
//  Weather
//
//  Created by Tomas Sanni on 6/2/23.
//

import SwiftUI

struct CurrentDetailsView: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let details: DetailsModel
        
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .bold()
                .padding(.vertical)
            
            HStack {
                VStack(alignment: .leading, spacing: 5.0) {
                    if let _ = details.humidity, let _ = details.dewPoint, let _ = details.pressure {
                        Text("Humidity")
                        Text("Dew point")
                        Text("Pressure")
                    }
                    
                    
                    Text("UV index")
                    
                    if let _ = details.visibility {
                        Text("Visibility")
                    }
                    
                    if let _ = details.sunData {
                        Text("Sunrise/sunset")
                    }
                }
                .foregroundColor(.secondary)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 5.0) {
                    if let humidity = details.humidity, let dewPoint = details.dewPoint, let pressure = details.pressure {
                        Text(humidity)
                        Text(dewPoint)
                        Text(pressure)
                        
                    }
                    
                    Text(details.uvIndex)
                    
                    if let visibility = details.visibility {
                        Text(visibility)
                    }
                    
                    if let sunData = details.sunData {
                        Text("\(sunData.sunrise), \(sunData.sunset)")
                    }
                    
                }
                
                Spacer()
            }
        }
        .padding()
        .background(colorScheme == .light ? Color.white : Color(red: 0.15, green: 0.15, blue: 0.15))
    }
    
    
    
    
    
}

struct CurrentDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentDetailsView(title: "Title", details: DetailsModel.detailsDataHolder)
            .previewDevice("iPhone 12 Pro Max")
    }
}
