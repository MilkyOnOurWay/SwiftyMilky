//
//  HoneyTipCell.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/04.
//

import UIKit

class HoneyTipCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func menuPlusBtnClicked(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("gotomenuAdd"), object: nil)
    }
    
}
