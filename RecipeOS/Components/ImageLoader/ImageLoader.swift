//
//  ImageLoader.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/28/22.
//

import SwiftUI

struct ImageLoader: View {
    var url: URL
    var body: some View {
        AsyncImage(url: url, transaction: Transaction(animation: .easeOut)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .transition(.scale(scale: 0.5, anchor: .center))
            case .empty:
                ProgressView()
            case .failure(_):
                Color.gray
            @unknown default:
                EmptyView()
            }
        }
    }
}

