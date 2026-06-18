//
//  ProductsView.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/17/24.
//

import SwiftUI
import TipKit

struct ProductsView: View {
    @Environment(ProductsFilter.self) private var filter
    @State private var layout = ProductLayout.list
    @State private var sheet: Sheet.SheetType?
    
    private var layoutTip = ProductLayoutTip()
    private var filterTip = ProductFilterTip()
            
    var body: some View {
        NavigationStack {
            TipView(layoutTip, 
                    action: actionHandler)
            .padding(.horizontal)
            
            content
                .navigationTitle("nav.appleWatches")
                .navigationBarTitleDisplayMode(.large)
                .toolbar { toolBarContent() }
                .fullScreenCover(item: $sheet, content: { Sheet(sheetType: $0 ) })
        }
    }
    
    var content: some View {
        Group {
            if layout == .grid {
                ProductsGridView()
            }
            else {
                ProductsListView()
            }
        }
    }
    
    func actionHandler(action: Tip.Action) {
        if action.id == "next-action" {
            Task {
                layoutTip.invalidate(reason: .tipClosed)
                
                await ProductFilterTip.productSteps.donate()
            }
        }
    }
}

extension ProductsView {
    @ToolbarContentBuilder
    func toolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                sheet = .filter
            }, label: {
                Image(systemName: "slider.horizontal.3")
            })
            .buttonStyle(.plain)
            .fontWeight(.semibold)
            .popoverTip(
                filterTip,
                arrowEdge: .top) { action in
                    if action.id == "action.title.dismiss" {
                        filterTip.invalidate(reason: .tipClosed)
                    }
                }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Picker("layout.label", selection: $layout) {
                    ForEach(ProductLayout.allCases) { option in
                        if option != .none {
                            Label(option.title, systemImage: option.imageName)
                                .tag(option)
                        }
                    }
                }
                .pickerStyle(.inline)
            } label: {
                Label("layout.options", systemImage: layout.imageName)
                    .symbolVariant(.fill)
                    .labelStyle(.titleAndIcon)
            }
        }
    }
}

#Preview {
    ProductsView()
}
