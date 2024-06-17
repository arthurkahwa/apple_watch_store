//
//  Constants.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/11/24.
//

import Foundation
import SwiftUI

enum Constants {
    static let gradient = Gradient(stops: [
        .init(color: Color(.baseGraedientTop), location: 0.2),
        .init(color: Color(.baseGradientBottom), location: 0.5)
    ])
    
    static let columns = [
        GridItem(.flexible(minimum: 100, maximum: .infinity)),
        GridItem(.flexible(minimum: 100, maximum: .infinity))
    ]
}