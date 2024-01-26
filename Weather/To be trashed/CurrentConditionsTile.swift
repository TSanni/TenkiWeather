////
////  CurrentConditionsTile.swift
////  Tenki Weather
////
////  Created by Tomas Sanni on 1/22/24.
////
//
//import SwiftUI
//
//struct CurrentConditionsTile: View {
//    
//
//    let title: String
//    let width: CGFloat
//    let value: String
//    let subValue: String
//    let backgroundColor: Color
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(title)
//                .padding(.bottom)
//            
//            HStack {
//                VStack(alignment: .leading) {
//                    Text(value)
//                        .font(.title)
//                    Text(subValue)
//                }
//                
//                Spacer()
//            }
//        }
//        .foregroundStyle(.white)
//        .padding()
//        .background(backgroundColor)
//        .clipShape(RoundedRectangle(cornerRadius: 10))
//        .frame(width: width)
//        .brightness(-0.15)
//
//    }
//}
//
//#Preview {
//    CurrentConditionsTile(title: "Humidity", width: 200, value: "95%", subValue: "Dew point 63°", backgroundColor: Color(uiColor: K.Colors.cloudMoonRainColor))
//        .brightness(-0.15)
//}
