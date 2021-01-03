//
//  SearchTVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/03.
//

import UIKit
import SnapKit
import Then

class SearchTVC: UITableViewCell {

    
    // MARK: - UI components
    
    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeAddressLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
