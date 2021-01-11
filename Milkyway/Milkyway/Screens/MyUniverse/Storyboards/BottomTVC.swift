//
//  BottomTVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/11.
//

import UIKit

class BottomTVC: UITableViewCell {
    @IBOutlet weak var deleteBtn: UIButton!
    
    var deleteBtnAction : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.deleteBtn.addTarget(self, action: #selector(deleteBtnClicked(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteBtnClicked(_ sender: Any) {
        print("delete")
        deleteBtnAction?()
    }
}

