//
//  Networking.swift
//  FinalProjectTatia
//
//  Created by Tatia on 18.01.24.
//

import Foundation

class Networking {
    let urlString = "https://dummyjson.com/products"
    
    enum ModelLayerError: Error {
        case urlNil
        case dataIsNil
        case decodeError
    }
    
    func fetch() async -> Result<ProductsContainer, ModelLayerError> {
        guard let url = URL(string: urlString) else {
            print("URL is Nil")
            return .failure(.urlNil)
        }
        guard let data = try? await URLSession.shared.data(from: url).0 else {
            return .failure(.dataIsNil)
        }
        
        do {
            let decodedData = try JSONDecoder().decode(ProductsContainer.self, from: data)
            return .success(decodedData)
        } catch(let error) {
            print("Error: \(error)")
        }
        return .failure(.decodeError)
    }
}
