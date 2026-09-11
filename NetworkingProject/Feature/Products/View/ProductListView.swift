//
//  ProductListView.swift
//  NetworkingProject
//
//  Created by Lidiia Diachkovskaia on 8/21/26.
//

import SwiftUI

struct ProductListView: View {
    
    let productsVM: ProductsViewModel
    
    var body: some View {
        List {
            ForEach(productsVM.products) { product in
                Text(product.title)
            }
        }
        .overlay(content: {
            if let error = productsVM.errorMessage {
                Text(error)
                    .foregroundStyle(.pink)
            }
        })
        .task {
            await productsVM.fetchProducts()
        }
    }
}

#Preview("Happy Path") {
    @State @Previewable var vm = ProductsViewModel(service: MockProductsService())
    ProductListView(productsVM: vm)
}

#Preview("Unhappy Path") {
    @State @Previewable var vm = ProductsViewModel(service: MockProductsService(error: .invalidResponse))
    ProductListView(productsVM: vm)
}
