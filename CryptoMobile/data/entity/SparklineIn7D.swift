//
//  SparklineIn7D.swift
//  CryptoMobile
//
//  Created by onur on 23.07.2024.
//

import Foundation

// MARK: - SparklineIn7D
class SparklineIn7D: Codable {
    var price: [Double]?

    init(price: [Double]?) {
        self.price = price
    }
}
