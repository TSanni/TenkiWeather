////
////  PrecipitationTileView.swift
////  Tenki Weather
////
////  Created by Tomas Sanni on 1/25/24.
////
//
//import SwiftUI
//
//struct PrecipitationTileView: View {
//    let precipitationDetails: DailyWeatherModel
//    let backgroundColor: Color
//    
//    
//    ///The humidity passed in is a value 0-1 representing a percentage.
//    ///This function multiplies that value by 100 to get a regular number
//    ///Ex) 0.2 will return 20
//    func convertPrecipitationFromPercentToDouble(precipitation: Double) -> CGFloat {
//        let newPrecipitation = precipitation * 100
//        return newPrecipitation
//    }
//    
//    
//    var body: some View {
//        let precipitation = convertPrecipitationFromPercentToDouble(precipitation: precipitationDetails.precipitationChance)
//        VStack(alignment: .leading) {
//            HStack {
//                Image(systemName: "drop.fill")
//                Text("Precipitation")
//                Spacer()
//                
//            }
//            .foregroundStyle(.secondary)
//            
//            Spacer()
//            
//            HStack {
//                VStack(alignment: .leading, spacing: 0.0) {
//                    
//                    Text(precipitationDetails.dayChanceOfPrecipitation)
//                        .font(.largeTitle)
//                        .bold()
//                    
//                    Text(precipitationDetails.precipitation.description.capitalized)
//                        .font(.title3)
//                        .bold()
//                }
//                
//                Spacer()
//                
//                TileImageProgressView(
//                    height: 50,
//                    value: precipitation,
//                    sfSymbol: "drop.fill",
//                    color: K.Colors.precipitationBlue
//                )
//                .aspectRatio(1, contentMode: .fit)
//            }
//            
//            
//            Spacer()
//            
//            Text("\(precipitationDetails.dayChanceOfPrecipitation) chance of precipitation.")
//                .font(.footnote)
//
//            
//        }
//        .cardTileModifier(backgroundColor: backgroundColor)
//    }
//
//}
//
//#Preview {
//    PrecipitationTileView(
//        precipitationDetails: DailyWeatherModel.placeholder,
//        backgroundColor: Color(uiColor: K.Colors.haze)
//    )
//    .frame(width: 200)
//    .environmentObject(AppStateManager.shared)
//}
