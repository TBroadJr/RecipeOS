//
//  SearchView.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/14/22.
//

import SwiftUI

struct SearchView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: []) var recipes: FetchedResults<Recipe>
    @Namespace var namespace
    @State private var text = ""
    @State private var show = false
    @State private var selectedIndex = UUID()
    @State private var selectedRecipe: Recipe?
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            scrollView
        }
    }
}

// MARK: - SearchView Extension
private extension SearchView {
    
    // MARK: - Scroll View
    private var scrollView: some View {
        ScrollView {
            VStack {
                content
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
            .strokeStyle(cornerRadius: 30)
            .padding(20)
            .background(Rectangle()
                .fill(.regularMaterial)
                .frame(height: 200)
                .frame(maxHeight: .infinity, alignment: .top)
                .blur(radius: 20)
                .offset(y: -150)
            )
            .background(Image("Blob 1").offset(y: -100))
        }
        .searchable(text: $text, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search Recipe"))
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .statusBarHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    withAnimation(.closeCard) {
                        dismiss()
                    }
                } label: {
                    Text("Done")
                }
            }
        }
        .onChange(of: selectedIndex, perform: { newValue in
            show = true
        })
        .sheet(isPresented: $show) {
            RecipeDetail(show: $show, namespace: namespace, recipe: selectedRecipe!)
        }
    }
    
    // MARK: - Content
    private var content: some View {
        ForEach(Array(recipes.enumerated()), id: \.offset) { index, recipe in
            if recipe.unwrappedTitle.contains(text) {
                if index != 0 { Divider() }
                Button {
                    selectedRecipe = recipe
                    selectedIndex = UUID()
                } label: {
                    HStack(alignment: .top, spacing: 12) {
                        ImageLoader(url: recipe.unwrappedImageURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .mask(Circle())
                            case .failure(_):
                                Color.gray
                            @unknown default:
                                EmptyView()
                            }
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(recipe.unwrappedTitle)
                                .bold()
                                .foregroundColor(.primary)
                            RecipeCookingItem(amountServed: recipe.cookingTimeInt, cookingTime: recipe.servingsInt)
                        }
                    }
                    .padding(.vertical, 4)
                    .listRowSeparator(.hidden)
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
