//
//  CafeMenusCell.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/04.
//

import UIKit

class CafeMenusCell: UITableViewCell {
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var menuSelectionLabel: UILabel!
    @IBOutlet weak var menuPriceLabel: UILabel!
    @IBOutlet weak var deleteModifyBtn: UIButton!
    
    var deleteModifyBtnAction : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.deleteModifyBtn.addTarget(self, action: #selector(editModifyBtnClicked(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editModifyBtnClicked(_ sender: Any) {
        deleteModifyBtnAction?()
        
    }
    
    
    
}
