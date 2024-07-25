//
//  HomePageViewModel.swift
//  CryptoMobile
//
//  Created by onur on 23.07.2024.
//

import Foundation
import RxSwift

class HomePageViewModel {
    var crepo = CryptoDaoRepository()
    var cryptoCurrencies = BehaviorSubject(value: [CurrencyElement]())
    
    init() {
        cryptoCurrencies = crepo.cryptoCurrencies
        fetchData()
    }
    
    func fetchData() {
        crepo.fetchData()
    }
    
    func uploadSearchingCurrencies(searchText: String){
        crepo.uploadSearchingCurrencies(searchText: searchText)
    }
}
