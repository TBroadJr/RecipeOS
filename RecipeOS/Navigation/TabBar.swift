//
//  TabBar.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/19/22.
//

import SwiftUI

struct TabBar: View {
    
        // MARK: - Properties
    @EnvironmentObject var manager: DataManager
    @State private var color: Color = .teal
    @State private var tabItemWidth: CGFloat = .zero
    private var tabItems = [
        TabItem(title: "Discover", icon: "magnifyingglass", color: .teal, tab: .discover),
        TabItem(title: "Create", icon: "plus", color: .blue, tab: .create),
        TabItem(title: "Plan", icon: "calendar", color: .red, tab: .plan),
        TabItem(title: "Favorite", icon: "bookmark", color: .teal, tab: .favorite)
    ]
    
        // MARK: - body
    var body: some View {
        GeometryReader { geo in
            let hasHomeIndicator = geo.safeAreaInsets.bottom - 88 > 20
            HStack {
                buttons
            }
            .padding(.horizontal, 8)
            .padding(.top, 14)
            .frame(height: hasHomeIndicator ? 88 : 62, alignment: .top)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: hasHomeIndicator ? 34 : 0, style: .continuous)
            )
            .background(background)
            .overlay(overlay)
            .strokeStyle(cornerRadius: hasHomeIndicator ? 34 : 0)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
        }
    }
    
        // MARK: - Buttons
    private var buttons: some View {
        ForEach(tabItems) { item in
            Button {
                buttonAction(item: item)
            } label: {
                VStack(spacing: 0) {
                    Image(systemName: item.icon)
                        .symbolVariant(.fill)
                        .font(.body.bold())
                        .frame(width: 80, height: 29)
                    Text(item.title)
                        .font(.caption2)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity)
            }
            .foregroundStyle(manager.selectedTab == item.tab ? .primary : .secondary)
            .blendMode(manager.selectedTab == item.tab ? .overlay : .normal)
            .scaleEffect(manager.selectedTab == item.tab ? 1.5 : 1)
            .overlay(
                GeometryReader { geo in
                    Color.clear.preference(key: TabPreferenceKey.self, value: geo.size.width)
                }
            )
            .onPreferenceChange(TabPreferenceKey.self) { value in
                tabItemWidth = value
            }
        }
    }
    
        // MARK: - Background
    private var background: some View {
        HStack {
            if manager.selectedTab == .favorite { Spacer() }
            if manager.selectedTab == .create { Spacer() }
            if manager.selectedTab == .plan {
                Spacer()
                Spacer()
            }
            Circle()
                .fill(color)
                .frame(width: tabItemWidth)
            if manager.selectedTab == .discover { Spacer() }
            if manager.selectedTab == .create {
                Spacer()
                Spacer()
            }
            if manager.selectedTab == .plan { Spacer() }
        }
        .padding(.horizontal, 8)
    }
    
        // MARK: - Overlay
    private var overlay: some View {
        HStack {
            if manager.selectedTab == .favorite { Spacer() }
            if manager.selectedTab == .create { Spacer() }
            if manager.selectedTab == .plan {
                Spacer()
                Spacer()
            }
            Rectangle()
                .fill(color)
                .frame(width: 28, height: 5)
                .cornerRadius(3)
                .frame(width: tabItemWidth)
                .frame(maxHeight: .infinity, alignment: .top)
            if manager.selectedTab == .discover { Spacer() }
            if manager.selectedTab == .create {
                Spacer()
                Spacer()
            }
            if manager.selectedTab == .plan { Spacer() }
        }
        .padding(.horizontal, 8)
    }
    
        // MARK: - Button Action
    private func buttonAction(item: TabItem) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            manager.selectedTab = item.tab
            color = item.color
        }
    }
    
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
            .environmentObject(DataManager())
    }
}
