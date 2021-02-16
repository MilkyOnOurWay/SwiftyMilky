//
//  CategoryLabelCell.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/02/16.
//

import UIKit

class CategoryLabelCell: UICollectionViewCell {

    static let identifier = "CategoryLabelCell"
    
    @IBOutlet var categoryLabel: CustomLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCell(category: String) {
        categoryLabel.text = category
    }
}
