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
        .task {
            await productsVM.fetchProducts()
        }
    }
}

#Preview {
    @State @Previewable var vm = ProductsViewModel(service: DefaultProductsService())
    ProductListView(productsVM: vm)
}
