//
//  ImageLoader.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/28/22.
//

import SwiftUI

struct ImageLoader<Content>: View where Content: View {
    
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    init(
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View {
        if let cached = ImageCache[url] {
            let _ = print("cached: \(url.absoluteString)")
            content(.success(cached))
        } else {
            let _ = print("Request: \(url.absoluteString)")
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ) { phase in
                cacheAndRender(phase: phase)
            }
        }
    }
    
        // MARK: - Cache and Render func
    private func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            ImageCache[url] = image
        }
        return content(phase)
    }
}

fileprivate class ImageCache {
    static private var cache: [URL: Image] = [:]
    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}

struct ImageLoader_Previews: PreviewProvider {
    static var previews: some View {
        ImageLoader(url: URL(string: "https://spoonacular.com/recipeImages/638257-556x370.jpg")!) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
            case .failure(_):
                Color.gray
            @unknown default:
                EmptyView()
            }
        }
    }
}
