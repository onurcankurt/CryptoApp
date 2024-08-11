//
//  FavoritesViewModel.swift
//  CryptoMobile
//
//  Created by onur on 11.08.2024.
//

import Foundation
import RxSwift

class FavoritesViewModel {
    var crepo = CryptoDaoRepository()
    var favoriteCurrencies = BehaviorSubject(value: [CurrencyElement]())
    
    init() {
        copySQLiteData()
        favoriteCurrencies = crepo.favoriteCurrencies
        fetchFavorites()
    }
    
    func fetchFavorites(){
        crepo.fetchFavorites()
    }
    
    func removeFromFavorites(id: String) {
        crepo.removeFromFavorites(id: id)
    }
    
    func copySQLiteData(){
        crepo.copySQLiteData()
    }
}
