//
//  CachedAsyncImageView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 8/6/25.
//

import SwiftUI

struct CachedAsyncImageView: View {
    let url: String
    
    @State private var image: UIImage?
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)

            } else if isLoading {
                ProgressView()
                    .frame(width: 25, height: 25)
            } else {
                Text("Failed to load image")
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        if let cachedImage = ImageCacheService.shared.getImage(for: url) {
            self.image = cachedImage
            self.isLoading = false
        } else {
            print("⛔️ Image url not found in cache.")
            fetchImage()
        }
    }
    
    private func fetchImage() {
        guard let url = URL(string: url) else {
            self.isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let downloadedImage = UIImage(data: data) {
                    ImageCacheService.shared.saveImage(downloadedImage, for: self.url)
                    self.image = downloadedImage
                    print("⚠️ Had to perform a network call and save the image to cache.")
                }
                self.isLoading = false
            }
        }
        .resume()
    }
}
