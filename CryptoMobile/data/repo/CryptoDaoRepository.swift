//
//  CryptoDaoRepository.swift
//  CryptoMobile
//
//  Created by onur on 23.07.2024.
//

import Foundation
import RxSwift
import Alamofire

class CryptoDaoRepository {
    var cryptoCurrencies = BehaviorSubject(value: [CurrencyElement]())
    
    func fetchData() {
        let url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true"
        
        AF.request(url).responseDecodable(of: [CurrencyElement].self) { response in
            switch response.result {
                case .success(let cryptos):
                    self.cryptoCurrencies.onNext(cryptos)
                    
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func uploadSearchingCurrencies(searchText: String){
        var resultList = [CurrencyElement]()
        let url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true"
        
        AF.request(url, method: .get).response { response in
            if let data = response.data {
                do {
                    let reply = try JSONDecoder().decode([CurrencyElement].self, from: data)
                    
                    for currency in reply {
                        if currency.name.uppercased().contains(searchText.uppercased()) ||
                            currency.symbol.uppercased().contains(searchText.uppercased()) {
                            resultList.append(currency)
                        }
                    }
                    
                    self.cryptoCurrencies.onNext(resultList)
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
