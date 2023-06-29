//
//  TESTVIEW.swift
//  Weather
//
//  Created by Tomas Sanni on 6/26/23.
//

import SwiftUI

struct TESTVIEW: View {
    @State private var selection: Int = 0
    var body: some View {
        VStack {
            HStack {
                ForEach(0..<3, id: \.self) { num in
                    Button("\(num)") {
                        withAnimation {
                            
                            selection = num
                        }
                    }
                }
            }
            
            TabView(selection: $selection) {
                Text("0")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.red)
                    .tabItem {
                        Label("1", systemImage: "cloud")
                    }
                    .tag(0)
                
                Text("1")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.green)
                    .tabItem {
                        Label("2", systemImage: "sun.min")
                    }
                    .tag(1)
                
                
                Text("2")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.purple)
                    .tabItem {
                        Label("3", systemImage: "sun.max")
                    }
                    .tag(2)
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct TESTVIEW_Previews: PreviewProvider {
    static var previews: some View {
        TESTVIEW()
    }
}
