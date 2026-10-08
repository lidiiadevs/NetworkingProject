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
        .overlay(alignment: .bottom, content: {
            switch productsVM.loadingState {
            case .initial, .loading:
                ProgressView()
                    .controlSize(.large)
                    .frame(maxHeight: .infinity) //makes centered bc ProgressView alignment is initially at the bottom
                
            case .loaded: EmptyView()
                
            case .loadingMore:
                ProgressView()
                    .controlSize(.small)
                    .padding()
                
            case .initialLoadError(let error):
                Text(error)
                    .foregroundStyle(.red)
                    .font(.title)
                    .padding()
                    .frame(maxHeight: .infinity)
                
            case .loadMoreError(let error):
                // smaller overlay
                Text(error)
                    .foregroundStyle(.red)
                    .padding()
                    .background(.thinMaterial).cornerRadius(5)
                    .shadow(radius: 5)
                    .frame(maxHeight: .infinity)
            }
            
        })
        .task {
            await productsVM.initialFetchProducts()
        }
        .onTriggerLoadAt(triggerDistance: 300, of: {
                    Task {
                        await productsVM.fetchMore()
                    }
        })
    }
}



extension View {
    
    func onTriggerLoadAt(triggerDistance: CGFloat, of transform: @escaping () -> Void) -> some View {
        
        return self
            .onScrollGeometryChange(for: Bool.self) { geometry in
               // print("geometry \(geometry.contentOffset.y)")
                //contentSize - how many contents - here 10 cells
                guard geometry.contentSize.height > 0 else { return false }
                // Initially, the list is empty, so contentSize.height is 0. That's why we need guard
                let maxOffsets = geometry.contentSize.height - geometry.containerSize.height
                let currentOffset = geometry.contentOffset.y
                
                return currentOffset >= maxOffsets - triggerDistance
                //Have we scrolled close enough to the bottom that I should trigger loading more items?
            } action: { wasNearBottom, isNearBottom in
                //Action: ONLY fires when the Bool changes
                if isNearBottom && !wasNearBottom {
                    transform()
                }
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

#Preview("API Calls") {
    @State @Previewable var vm = ProductsViewModel(service: DefaultProductsService())
    ProductListView(productsVM: vm)
}
