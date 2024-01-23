import SwiftUI

struct CustomProgressView: View {
    let progress: Double
    
    @EnvironmentObject var weather: WeatherViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.yellow.opacity(0.4))
                    .frame(width: geometry.size.width, height: 50)
                
                Rectangle()
                    .foregroundColor(.yellow)
                    .frame(width: CGFloat(self.progress) * geometry.size.width, height: 50)
            }
        }
        .cornerRadius(5)
    }
}

struct ContentView: View {
     var progress: Double = 0.5

    var body: some View {
        VStack {
            CustomProgressView(progress: progress)
                .frame(height: 20)
                .padding()
//                .rotationEffect(.degrees(-90))

//            Button("Update Progress") {
//                withAnimation {
//                    self.progress = Double.random(in: 0...1)
//                }
//            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
