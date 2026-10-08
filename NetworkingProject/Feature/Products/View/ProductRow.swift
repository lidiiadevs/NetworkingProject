//
//  ProductRow.swift
//  NetworkingProject
//
//  Created by Lidiia Diachkovskaia on 10/7/26.
//


import SwiftUI

struct ProductRow: View {
    let product: Product
//    var body: some View {
//        HStack(spacing: 12) {
//            AsyncImage(url: URL(string: product.thumbnail)) { phase in
//                switch phase {
//                case .success(let image):
//                    image
//                        .resizable()
//                        .scaledToFill()
//
//                case .empty, .failure:
//                    Circle()
//                        .fill(.gray.opacity(0.2))
//                        .overlay {
//                            Image(systemName: "photo")
//                                .foregroundStyle(.secondary)
//                        }
//
//                @unknown default:
//                    Circle()
//                        .fill(.gray.opacity(0.2))
//                }
//            }
//            .frame(width: 52, height: 52)
//            .clipShape(Circle())
//
//            VStack(alignment: .leading, spacing: 4) {
//                Text(product.title)
//                    .font(.title2)
//
//                Text(product.id.description)
//                    .font(.subheadline)
//                    .foregroundStyle(.secondary)
//            }
//
//            Spacer()
//        }
//        .padding(.horizontal, 16)
//        .padding(.vertical, 8)
//    }
        
            var body: some View {
                HStack {
                    AsyncImage(url: URL(string: product.thumbnail)) { phase in
                        switch phase {
                        case .empty:
                            Color.gray
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                        case .failure(let error):
                            Text(error.localizedDescription)
                        @unknown default:
                            Circle()
                                .fill(.gray.opacity(0.2))
                        }
                    }
                    .border(Color.red)
                    Text(product.title)
                    //Text(product.id.description)
                }
                .font(.title2)
            }
}

#Preview {
    List {
        ProductRow(product: .example)
    }
}
