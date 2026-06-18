//
//  AddProductReview.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/21/24.
//

import SwiftUI

struct AddProductReview: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(DataManager.self) private var manager
    
    @State private var rating: Float = 3.0
    @State private var reviewSummary = ""
    @State private var title = ""
    @State private var name = ""
    
    @Bindable var product: Product
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("review.title", text: $title)
                    TextField("review.yourName", text: $name)
                }
                
                Section {
                    TextEditor(text: $reviewSummary)
                    
                    RatingReview(rating: $rating)
                } header: {
                    Text("review.writeReview")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("button.save") {
                        withAnimation {
                            let data = ReviewData(title: title,
                                                  summary: reviewSummary,
                                                  name: name,
                                                  rating: Float(rating))
                            
                            manager.addProductReview(product: product, data: data)
                            
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    AddProductReview()
//}
