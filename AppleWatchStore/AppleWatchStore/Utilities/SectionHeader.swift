//
//  SectionHeader.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/11/24.
//

import SwiftUI

struct SectionHeader: View {
    var title: LocalizedStringKey
    var icon: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title)
                    .condensedLowercased(.bold, size: 24)
                
                Spacer()
                
                if icon.isNotEmpty { Image(systemName: icon) }
            }
            
            Divider()
        }
    }
}

#Preview {
    VStack {
        SectionHeader(title: "section.popular")
        SectionHeader(title: "section.popular", icon: "slider.horizontal.3")
    }
}
