//
//  HoneyTipCell.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/04.
//

import UIKit

class HoneyTipCell: UITableViewCell {
    
    var select = [Bool](repeating: false, count: 6)

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
    
    @IBAction func honeyTipClicked(_ sender: UIButton) {
        if select[sender.tag-1] {
            (self.viewWithTag(sender.tag) as? UILabel)?.textColor = UIColor(named: "darkGrey")
            (self.viewWithTag(sender.tag) as? UILabel)?.layer.borderColor = UIColor(named: "darkGrey")?.cgColor
            select[sender.tag-1] = false
        }
        else {
            (self.viewWithTag(sender.tag) as? UILabel)?.textColor = UIColor(named: "Milky")
            (self.viewWithTag(sender.tag) as? UILabel)?.layer.borderColor = UIColor(named: "Milky")?.cgColor
            select[sender.tag-1] = false
        }
        
    }
    
    
}
