//
//  CategoryLabelCell.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/02/16.
//

import UIKit

class CategoryLabelCell: UICollectionViewCell {

    static let identifier = "CategoryLabelCell"
    
//    var text: NSAttributedString!
    @IBOutlet var categoryLabel: CustomLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCell(category: String) {
//        text = NSAttributedString(string: category)
        categoryLabel.text = category
//        print("text.size(): \(text.size())")
//        NotificationCenter.default.post(name: Notification.Name("categoryLabelSize"), object: text.size().width)
    }
}
