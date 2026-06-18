//
//  WifiCellularView.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/20/24.
//

import SwiftUI

struct WifiCellularView: View {
    var type: ProductCellularType
    
    var body: some View {
        HStack {
            Image(.iconWifi)
            
            HStack {
                Image(systemName: "plus")
                
                Image(.icon5G)
            }
            .frame(width: type == .wifiAndCellular ? 52 : 0,
                   height: type == .wifiAndCellular ? 32 : 0)
            .opacity(type == .wifiAndCellular ? 1 : 0)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(height: 80)
        .padding()
    }
}

#Preview {
    VStack {
        WifiCellularView(type: .wifiOnly)
        WifiCellularView(type: .wifiAndCellular)
    }
}
