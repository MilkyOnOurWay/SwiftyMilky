//
//  TopTVCell.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/04.
//

import UIKit

class TopTVCell: UITableViewCell {

    static let identifier = "TopTVCell"
    @IBOutlet var milkyImageView: UIImageView!
    @IBOutlet var nickNameSignLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
