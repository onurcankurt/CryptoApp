//
//  CryptoCell.swift
//  CryptoMobile
//
//  Created by onur on 23.07.2024.
//

import UIKit

protocol CryptoCellProtocol {
    func toggleFavorite(indexPath: IndexPath)
}

class CryptoCell: UITableViewCell {
    
    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var cryptoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var cryptoCellProtocol: CryptoCellProtocol?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func starButtonClicked(_ sender: Any) {
        cryptoCellProtocol?.toggleFavorite(indexPath: indexPath!)
    }
}
