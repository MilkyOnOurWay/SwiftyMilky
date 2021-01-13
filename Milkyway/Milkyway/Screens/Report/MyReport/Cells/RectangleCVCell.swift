//
//  RectangleCVCell.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/07.
//

import UIKit

class RectangleCVCell: UICollectionViewCell {

    static let identifier = "RectangleCVCell"
    
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var storeNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCell(backName: String) {
        backgroundImage.image = UIImage(named: backName)
    }
    
    func setLabel(storeName: String, date: String, color: String) {
        storeNameLabel.text = storeName
        storeNameLabel.textColor = UIColor(named: color)
        
        dateLabel.textColor = UIColor(named: color)
    }

}
