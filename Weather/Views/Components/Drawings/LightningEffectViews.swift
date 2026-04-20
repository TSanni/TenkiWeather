//
//  LightningEffectViews.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 6/9/25.
//

import Foundation
import SwiftUI

struct LightningView: View {
    @State private var isAnimating = false
    @State private var flashOpacity: Double = 0
    @State private var lightningPaths: [LightningPath] = []
    
    var body: some View {
        ZStack {
            
            // Lightning flash overlay
            Rectangle()
                .fill(Color.white)
                .opacity(flashOpacity)
                .ignoresSafeArea()
                .blendMode(.screen)
            
            // Lightning bolts
            ForEach(lightningPaths.indices, id: \.self) { index in
                LightningBolt(lightningPath: lightningPaths[index])
                    .stroke(
                        LinearGradient(
                            colors: [Color.white, Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                    )
                    .shadow(color: .white, radius: 10)
                    .shadow(color: .blue, radius: 20)
                    .opacity(lightningPaths[index].opacity)
            }
        }
        .onAppear {
            startLightningAnimation()
        }
    }
    
    private func startLightningAnimation() {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            triggerLightning()
        }
    }
    
    private func triggerLightning() {
        // Create new lightning path
        let newPath = LightningPath.random()
        lightningPaths.append(newPath)
        
        // Animate lightning appearance
        withAnimation(.easeIn(duration: 0.1)) {
            if let index = lightningPaths.firstIndex(where: { $0.id == newPath.id }) {
                lightningPaths[index].opacity = 1.0
            }
        }
        
        // Flash effect
        withAnimation(.easeIn(duration: 0.05)) {
            flashOpacity = 0.3
        }
        
        // Remove flash
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeOut(duration: 0.2)) {
                flashOpacity = 0
            }
        }
        
        // Remove lightning bolt
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeOut(duration: 0.3)) {
                if let index = lightningPaths.firstIndex(where: { $0.id == newPath.id }) {
                    lightningPaths[index].opacity = 0
                }
            }
        }
        
        // Clean up old paths
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            lightningPaths.removeAll { $0.opacity == 0 }
        }
    }
}

struct LightningBolt: Shape {
    let lightningPath: LightningPath
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let points = lightningPath.points
        guard points.count > 1 else { return path }
        
        // Convert normalized points to actual coordinates
        let actualPoints = points.map { point in
            CGPoint(
                x: point.x * rect.width,
                y: point.y * rect.height
            )
        }
        
        path.move(to: actualPoints[0])
        for i in 1..<actualPoints.count {
            path.addLine(to: actualPoints[i])
        }
        
        return path
    }
}

struct LightningPath {
    let id = UUID()
    let points: [CGPoint]
    var opacity: Double = 0
    
    static func random() -> LightningPath {
        var points: [CGPoint] = []
        
        // Start from top
        let startX = Double.random(in: 0.2...0.8)
        points.append(CGPoint(x: startX, y: 0))
        
        var currentX = startX
        var currentY = 0.0
        
        // Generate zigzag pattern downward
        let segments = Int.random(in: 5...12)
        for i in 1...segments {
            let segmentHeight = 1.0 / Double(segments)
            currentY += segmentHeight
            
            // Add some horizontal variation
            let maxDeviation = 0.15
            let deviation = Double.random(in: -maxDeviation...maxDeviation)
            currentX = max(0.1, min(0.9, currentX + deviation))
            
            points.append(CGPoint(x: currentX, y: currentY))
            
            // Occasionally add branches
            if i > 2 && Double.random(in: 0...1) < 0.3 {
                // Add a small branch
                let branchX = max(0.1, min(0.9, currentX + Double.random(in: -0.2...0.2)))
                let branchY = currentY + segmentHeight * 0.3
                points.append(CGPoint(x: branchX, y: branchY))
                points.append(CGPoint(x: currentX, y: currentY)) // Return to main path
            }
        }
        
        return LightningPath(points: points)
    }
}
