//
//  CryptoDaoRepository.swift
//  CryptoMobile
//
//  Created by onur on 23.07.2024.
//

import Foundation
import RxSwift
import Alamofire
import FMDB

class CryptoDaoRepository {
    var cryptoCurrencies = BehaviorSubject(value: [CurrencyElement]())
    var favoriteCurrencies = BehaviorSubject(value: [CurrencyElement]())
    
    var db: FMDatabase?
    
    init() {
        let destinationPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let databaseURL = URL(filePath: destinationPath).appending(path: "favorites.sqlite")
        db = FMDatabase(path: databaseURL.path())
    }
    
    func fetchData() {
        let url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true"
        
        AF.request(url).responseDecodable(of: [CurrencyElement].self) { response in
            switch response.result {
                case .success(let cryptos):
                    
                    for crypto in cryptos{
                        crypto.isFav = false //Setting the fav values ​​of cryptos to false
                    }
                    // connect sqlite and control if crypto is in fav list
                    self.db?.open()                    
                    do {
                        let results = try self.db!.executeQuery("SELECT * FROM favorites", values: nil)
                        
                        while results.next(){
                            let currency = CurrencyElement(id: results.string(forColumn: "id")!,
                                                           symbol: results.string(forColumn: "symbol")!,
                                                           name: results.string(forColumn: "name")!
                            )
                            for crypto in cryptos {
                                if crypto.id == currency.id{
                                    crypto.isFav = true
                                }
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                    self.db?.close()
                    
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
                        if currency.name!.uppercased().contains(searchText.uppercased()) ||
                            currency.symbol!.uppercased().contains(searchText.uppercased()) {
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
    
    func fetchFavorites(){
        
        let url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true"
        
        AF.request(url).responseDecodable(of: [CurrencyElement].self) { response in
            switch response.result {
                case .success(let cryptos):
                    
                    for crypto in cryptos{
                        crypto.isFav = false //Setting the fav values ​​of cryptos to false
                    }
                    
                    
                    // connect sqlite and control if crypto is in fav list
                    self.db?.open()
                    var list = [CurrencyElement]()
                    
                    do {
                        let results = try self.db!.executeQuery("SELECT * FROM favorites", values: nil)
                        
                        while results.next(){
                            let currency = CurrencyElement(id: results.string(forColumn: "id")!,
                                                           symbol: results.string(forColumn: "symbol")!,
                                                           name: results.string(forColumn: "name")!
                            )
                            for crypto in cryptos {
                                if crypto.id == currency.id{
                                    crypto.isFav = true
                                    list.append(crypto)
                                }
                            }
                        }
                        self.favoriteCurrencies.onNext(list)
                    } catch {
                        print(error.localizedDescription)
                    }
                    self.db?.close()
                    
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func addToFavorites(id: String, name: String, symbol: String) {
        db?.open()
        do {
            try db!.executeUpdate("INSERT INTO favorites (id,name,symbol) VALUES (?,?,?)", values: [id, name, symbol])
        } catch {
            print(error.localizedDescription)
        }
        db?.close()
    }
    
    func removeFromFavorites(id: String) {
        db?.open()
        
        do {
            try db?.executeUpdate("DELETE FROM favorites WHERE id = ?", values: [id])
            fetchFavorites()
        } catch {
            print(error.localizedDescription)
        }
        db?.close()
    }
    
    func copySQLiteData(){
        let bundlePath = Bundle.main.path(forResource: "favorites", ofType: ".sqlite")
        let destinationPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let copyLocation = URL(filePath: destinationPath).appending(path: "favorites.sqlite")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: copyLocation.path()){
            print("There is already a database")
        } else {
            do {
                try fileManager.copyItem(atPath: bundlePath!, toPath: copyLocation.path())
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
