//
//  Theme.swift
//  AppleWatchAppStore
//
//  Created by Craig Clayton on 7/22/23.
//

import SwiftUI

struct CustomNavigationBar: ViewModifier {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .font : UIFont.systemFont(ofSize: 24, weight: .black, width: .condensed),
            NSAttributedString.Key.foregroundColor : UIColor(.primary)
        ]
        
        appearance.backButtonAppearance.normal.titleTextAttributes = [
            .font : UIFont.systemFont(ofSize: 24, weight: .semibold, width: .condensed),
            NSAttributedString.Key.foregroundColor : UIColor(.primary)
        ]
        
        appearance.largeTitleTextAttributes = [
            .font : UIFont.systemFont(ofSize: 48, weight: .black, width: .condensed),
            NSAttributedString.Key.foregroundColor : UIColor(.primary)
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func customNavigationBar() -> some View {
        self.modifier(CustomNavigationBar())
    }
}


struct CustomTabBarItem: ViewModifier {
    
    @Environment(\.colorScheme) var colorsScheme
    
    init(with itemColor: UIColor?) {
        UITabBarItem.appearance().badgeColor = itemColor
        UITabBarItem.appearance().setBadgeTextAttributes([
            .font : UIFont.systemFont(ofSize: 12, weight: .bold, width: .condensed),
            NSAttributedString.Key.foregroundColor : colorsScheme == .dark ? UIColor.white : UIColor.black], for: .normal)
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func customTabBarItem(with itemColor: UIColor?) -> some View {
        self.modifier(CustomTabBarItem(with: itemColor))
    }
}

