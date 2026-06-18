//
//  FavoriteProductTip.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 7/5/24.
//

import Foundation
import SwiftUI
import TipKit

struct FavoriteProductTip: Tip {
    @Parameter
    static var showTip: Bool = false
    
    var title: Text {
        Text("tip.favorite.title")
    }
    
    var message: Text? {
        Text("tip.favorite.message")
    }
    
    var image: Image? {
        Image(systemName: "heart")
    }
}
