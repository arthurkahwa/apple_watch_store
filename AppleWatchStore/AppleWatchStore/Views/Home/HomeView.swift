//
//  HomeView.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/17/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(DataManager.self) private var manager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                content
            }
            .navigationTitle("nav.welcome")
            .navigationBarTitleDisplayMode(.large)
            .overlay {
                if manager.dbInitializationProgress {
                    ProgressView("loading")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .background(.white)
                }
            }
            .background(Color(.baseBackground))
        }
    }
    
    var content: some View {
        VStack {
            BrowseSection()
            
            PopularSection()
            
            CategorySection()
        }
    }
}

#Preview {
    HomeView()
}
