////
////  CurrentDetailsView.swift
////  Weather
////
////  Created by Tomas Sanni on 6/2/23.
////
//
//import SwiftUI
//
//struct CurrentDetailsView: View {
//    @Environment(\.colorScheme) var colorScheme
//    let title: String
//    let details: DetailsModel
//        
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(title)
//                .bold()
//                .padding(.bottom)
//            
//            HStack {
//                VStack(alignment: .leading, spacing: 5.0) {
//                    if let _ = details.dewPoint, let _ = details.pressure {
//                        Text("Humidity")
//                        Text("Dew point")
//                        Text("Pressure")
//                    }
//                    
//                    
//                    Text("UV index")
//                    
//                    if let _ = details.visibility {
//                        Text("Visibility")
//                    }
//                    
//                    if let _ = details.sunData {
//                        Text("Sunrise/sunset")
//                    }
//                }
//                .foregroundColor(.secondary)
//                
//                Spacer()
//                
//                VStack(alignment: .leading, spacing: 5.0) {
//                    if let dewPoint = details.dewPoint, let pressure = details.pressure {
//                        Text(details.humidityPercentage)
//                        Text(dewPoint)
//                        Text(pressure)
//                        
//                    }
//                    
//                    Text(details.uvIndexValueDescription)
//                    
//                    if let visibility = details.visibility {
//                        Text(visibility)
//                    }
//                    
//                    if let sunData = details.sunData {
//                        Text("\(sunData.sunrise), \(sunData.sunset)")
//                    }
//                    
//                }
//                
//                Spacer()
//            }
//        }
//        .padding()
//        .padding(.vertical)
//        .background(colorScheme == .light ? K.Colors.goodLightTheme : K.Colors.goodDarkTheme)
//    }
//    
//    
//    
//    
//    
//}
//
//struct CurrentDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrentDetailsView(title: "Title", details: DetailsModel.detailsDataHolder)
//            .previewDevice("iPhone 12 Pro Max")
//    }
//}
