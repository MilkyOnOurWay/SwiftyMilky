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
    
    
    // 전화번호 버튼 눌렸을 때
    @IBAction func telNumClicked(_ sender: Any) {
        let number = telNumBtn.titleLabel?.text
        if let url = URL(string: "tel://\(number!)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else {
            print("error")
        }
        
    }
    
    
}
