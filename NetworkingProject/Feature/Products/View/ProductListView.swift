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
                ProductRow(product: product)
//                    .onAppear{
//                        print("onAppear: \(product.id) ")
//                    }
//                    .onDisappear(perform: {
//                        print("onDisappear \(product.id)")
//                    })
//                    .onAppear { //here .task can be used but downside is its cancellation. .onAppear is not so reliable
//                        Task {
//                            print("onAppear: \(product.id) ")
//                            await productsVM.fetchMore(for: product.id)
//                        }
//                    }
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
        .onScrollGeometryChange(for: Bool.self) { geometry in
            print("geometry \(geometry.contentOffset.y)")
            //contentSize - how many contents - here 10 cells
            guard geometry.contentSize.height > 0 else { return false }
// Initially, the list is empty, so contentSize.height is 0. That's why we need guard
            let maxOffsets = geometry.contentSize.height - geometry.containerSize.height
            
            let currentOffset = geometry.contentOffset.y
            let triggerDIstance: CGFloat = 300
            
            return currentOffset >= maxOffsets - triggerDIstance
            //Have we scrolled close enough to the bottom that I should trigger loading more items?
        } action: { wasNearBottom, isNearBottom in
            guard isNearBottom else { return }
            Task {
                await productsVM.fetchMore()
            }
        }
    }
}

struct ProductRow: View {
    let product: Product
    
    var body: some View {
        VStack {
            Text(product.id.description)
            Text(product.title)
        }
        .font(.title2)
        .padding(40)
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

#Preview("API Calls") {
    @State @Previewable var vm = ProductsViewModel(service: DefaultProductsService())
    ProductListView(productsVM: vm)
}
