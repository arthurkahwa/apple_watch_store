//
//  WristItemView.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/20/24.
//

import SwiftUI

struct WristItemView: View {
    let item: WristSize
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            Text(item.size)
                .condensedLowercased(.bold, size: 24)
            
            Text(item.desc)
                .condensed(.light, size: 16)
        }
        .frame(maxWidth: .infinity, alignment: .bottomLeading)
        .frame(height: 80)
        .padding()
    }
}

//#Preview {
//    WristItemView()
//}
