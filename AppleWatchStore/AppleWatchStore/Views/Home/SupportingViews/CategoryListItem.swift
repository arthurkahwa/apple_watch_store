//
//  CategoryListItem.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/17/24.
//

import SwiftUI

struct CategoryListItem: View {
    var item: (name: String, icon: String)
    
    var body: some View {
        VStack (spacing: 4) {
            HStack {
                HStack {
                    Image(item.icon)
                        .resizable()
                        .frame(width: 32, height: 28)
                    
                    Text(item.name)
                        .condensed(.light, size: 16)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            
            Divider()
        }
        .padding(.horizontal)
    }
}

#Preview {
    CategoryListItem(item: (name: "Apple Watch Bands", icon: "icon-watch-bands"))
}
