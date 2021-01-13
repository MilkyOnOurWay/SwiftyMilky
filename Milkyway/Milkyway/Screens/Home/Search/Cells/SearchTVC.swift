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
    
    var searchedCafe: CafeHomeResult?
    var cafeName: String?
    var cafeAddress: String?
    var longitude: Double?
    var latitude: Double?
    var businessHours: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(){
        
        cafeName = searchedCafe?.cafeName
        cafeAddress = searchedCafe?.cafeAddress
        cafeNameLabel.text = searchedCafe?.cafeName
        cafeAddressLabel.text = searchedCafe?.cafeAddress
        longitude = searchedCafe?.longitude
        latitude = searchedCafe?.latitude
        businessHours = searchedCafe?.businessHours
        
    
    }
    
}
