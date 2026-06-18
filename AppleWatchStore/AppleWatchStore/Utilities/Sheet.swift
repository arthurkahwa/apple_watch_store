//
//  Sheet.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/27/24.
//

import SwiftUI

struct Sheet: View {
    enum SheetType: Identifiable {
        case filter
        
        var id: String {
            switch self {
            case .filter: return "filter view"
            }
        }
    }
    
    let sheetType: SheetType
    
    @ViewBuilder
    private func make() -> some View {
        switch sheetType {
        case .filter:
            ProductFilterView()
        }
    }
    
    var body: some View {
        make()
    }
}
