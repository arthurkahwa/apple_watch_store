//
//  SizeItemView.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/20/24.
//

import SwiftUI

struct SizeItemView: View {
    let item: CaseSize
    
    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(item.size.uppercased())
                .condensed(.bold, size: 24)
            Spacer()
            
            Group {
                Text("€").ultraLight() + Text(item.price).heavy()
            }
        }
        .padding()
    }
}

//#Preview {
//    SizeItemView()
//}
