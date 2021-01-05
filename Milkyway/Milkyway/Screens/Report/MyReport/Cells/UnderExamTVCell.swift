//
//  UnderExamTVCell.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/05.
//

import UIKit

class UnderExamTVCell: UITableViewCell {

    static let identifier = "UnderExamTVCell"
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(state: String) {
        stateLabel.text = state
    }
    
}
