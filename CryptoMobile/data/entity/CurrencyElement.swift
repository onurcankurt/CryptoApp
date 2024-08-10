//
//  CurrencyElement.swift
//  CryptoMobile
//
//  Created by onur on 23.07.2024.
//

import Foundation

class CurrencyElement: Codable {
    var id: String?
    var symbol: String?
    var name: String?
    var image: String?
    var current_price: Double?
    var market_cap: Double?
    var market_cap_rank: Int?
    var fully_diluted_valuation: Double?
    var total_volume: Double?
    var high_24h: Double?
    var low_24h: Double?
    var price_change_24h: Double?
    var price_change_percentage_24h: Double?
    var market_cap_change_24h: Double?
    var market_cap_change_percentage_24h: Double?
    var circulating_supply: Double?
    var total_supply: Double?
    var max_supply: Double?
    var last_updated: String?
    var sparkline_in_7d: SparklineIn7D?
    var isFav: Bool?
    
    init(id: String, symbol: String, name: String, image: String, current_price: Double, market_cap: Double, market_cap_rank: Int, fully_diluted_valuation: Double?, total_volume: Double, high_24h: Double, low_24h: Double, price_change_24h: Double, price_change_percentage_24h: Double, market_cap_change_24h: Double, market_cap_change_percentage_24h: Double, circulating_supply: Double, total_supply: Double?, max_supply: Double?, last_updated: String, sparkline_in_7d: SparklineIn7D, isFav: Bool) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.image = image
        self.current_price = current_price
        self.market_cap = market_cap
        self.market_cap_rank = market_cap_rank
        self.fully_diluted_valuation = fully_diluted_valuation
        self.total_volume = total_volume
        self.high_24h = high_24h
        self.low_24h = low_24h
        self.price_change_24h = price_change_24h
        self.price_change_percentage_24h = price_change_percentage_24h
        self.market_cap_change_24h = market_cap_change_24h
        self.market_cap_change_percentage_24h = market_cap_change_percentage_24h
        self.circulating_supply = circulating_supply
        self.total_supply = total_supply
        self.max_supply = max_supply
        self.last_updated = last_updated
        self.sparkline_in_7d = sparkline_in_7d
        self.isFav = isFav
    }
}
