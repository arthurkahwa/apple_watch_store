//
//  Text+Extension.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/13/24.
//

import SwiftUI

extension Text {
    func ultraLight(size: CGFloat = 20) -> Text {
        let condensed = UIFont.systemFont(ofSize: size, weight: .ultraLight, width: .condensed)
        
        return self.font(Font(condensed))
    }
    
    func heavy(size: CGFloat = 60) -> Text {
        let heavy = UIFont.systemFont(ofSize: size, weight: .heavy, width: .condensed)
        
        return self.font(Font(heavy))
    }
    
    func customBold(size: CGFloat = 12) -> Text {
        let bold = UIFont.systemFont(ofSize: size, weight: .bold, width: .condensed)
        
        return self.font(Font(bold))
    }
}
