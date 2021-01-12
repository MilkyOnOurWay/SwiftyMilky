//
//  AddSearchTVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/07.
//

import UIKit

class AddSearchTVC: UITableViewCell {

    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeAddressLabel: UILabel!
    @IBOutlet weak var cafeStateImageView: UIImageView!
    
    var searchedCafe: CafeResult?
    var isReported: Bool?
    // 위도 경도 넘길 필요가 있나...?
    var latitude: String?
    var longitude: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(){
        
        cafeNameLabel.text = searchedCafe?.cafeName
        cafeAddressLabel.text = searchedCafe?.cafeAddress
        if searchedCafe?.isReported == true {
            cafeStateImageView.isHidden = false
        }
    }
    
}
