//
//  Product.swift
//  FinalProjectTatia
//
//  Created by Tatia on 18.01.24.
//

import Foundation

struct ProductsContainer: Codable, Hashable {
    let products: [Product]
}

struct Product: Codable, Hashable {
    var id: Int
    var brand: String
    var title: String
    var category: String
    var stock: Int
    var price: Int
    let images: [String]
}
