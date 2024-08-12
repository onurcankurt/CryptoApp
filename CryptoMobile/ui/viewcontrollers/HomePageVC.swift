//
//  ViewController.swift
//  CryptoMobile
//
//  Created by onur on 23.07.2024.
//

import UIKit
import Kingfisher

class HomePageVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cryptoTableView: UITableView!
    
    var currencyList = [CurrencyElement]()
    var viewModel = HomePageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteStatusChanged), name: NSNotification.Name("FavoriteStatusChanged"), object: nil)
        
        searchBar.delegate = self
        cryptoTableView.delegate = self
        cryptoTableView.dataSource = self
        
        _ = viewModel.cryptoCurrencies.subscribe(onNext: { currencies in
            self.currencyList = currencies
            DispatchQueue.main.async {
                self.cryptoTableView.reloadData()
            }
        })
    }
    @objc func favoriteStatusChanged() {
        // Reload data
        viewModel.fetchData()
        print("favoritesStatusCanged func called - reload crypto data")
        cryptoTableView.reloadData()
    }
}

extension HomePageVC: CryptoCellProtocol {
    func toggleFavorite(indexPath: IndexPath) {
        let currency = currencyList[indexPath.row]
        print(currency.id!)
        print(currency.isFav ?? true)
        if currency.isFav == false {
            currency.isFav?.toggle()
            // add to sqlite fav list here
            viewModel.addToFavorites(id: currency.id!, name: currency.name!, symbol: currency.symbol!)
        } else {
            currency.isFav?.toggle()
            // delete from sqlite fav list here
            viewModel.removeFromFavorites(id: currency.id!)
        }
        cryptoTableView.reloadRows(at: [indexPath], with: .automatic)
        //NotificationCenter.default.post(name: NSNotification.Name("FavoriteStatusChanged"), object: nil)
    }
}

extension HomePageVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            viewModel.fetchData()
        } else {
            viewModel.uploadSearchingCurrencies(searchText: searchText)
        }
    }
}

extension HomePageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = currencyList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cryptoCell") as! CryptoCell
        
        if let url = URL(string: currency.image!){
            DispatchQueue.main.async {
                cell.cryptoImageView.kf.setImage(with: url)
            }
        }
        
        cell.nameLabel.text = currency.name
        cell.placeLabel.text = "\(currency.market_cap_rank!)"
        cell.priceLabel.text = "$\(currency.current_price!)"
        cell.symbolLabel.text = currency.symbol!.uppercased()
        
        if currency.price_change_24h! < 0 {
            cell.priceLabel.textColor = .systemRed
        } else if currency.price_change_24h! > 0 {
            cell.priceLabel.textColor = .systemGreen
        } else {
            cell.priceLabel.textColor = .black
        }
        
        cell.indexPath = indexPath
        cell.cryptoCellProtocol = self
        
        DispatchQueue.main.async {
            if currency.isFav == true{
                cell.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                cell.starButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = currencyList[indexPath.row]
        performSegue(withIdentifier: "toDetailVC", sender: currency)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let senderData = sender as? CurrencyElement {
                let destinationVC = segue.destination as! DetailVC
                destinationVC.detailCurrency = senderData
                destinationVC.navigationItem.title = senderData.name
            }
        }
        
        if segue.identifier == "toFavoritesVC" {
        }
    }
}

