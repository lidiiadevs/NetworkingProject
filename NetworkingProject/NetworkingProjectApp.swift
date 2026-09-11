//
//  NetworkingProjectApp.swift
//  NetworkingProject
//
//  Created by Lidiia Diachkovskaia on 8/15/26.
//

import SwiftUI

@main
struct NetworkingProjectApp: App {
    @State private var productsViewModel = ProductsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ProductListView(productsVM: productsViewModel)
        }
    }
}
