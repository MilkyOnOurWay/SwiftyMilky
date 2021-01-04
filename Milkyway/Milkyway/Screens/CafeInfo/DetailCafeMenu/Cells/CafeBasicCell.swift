//
//  CafeBasicCell.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/04.
//

import UIKit

class CafeBasicCell: UITableViewCell {
    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var howManyLikeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var telNumBtn: UIButton!
    @IBOutlet weak var webPageBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
