//
//  CompletedTVCell.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/04.
//

import UIKit

class CompletedTVCell: UITableViewCell {

    static let identifier = "CompletedTVCell"
    
    @IBOutlet var rootView: UIView!
    @IBOutlet var cardView: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var cafeNameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    var menuTag: [String] = ["디카페인", "두유", "저지방우유", "무지방우유"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setCardView() {
        cardView.borderWidth = 1
        cardView.borderColor = UIColor(displayP3Red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0)
        cardView.backgroundColor = UIColor(named: "lightGrey")
        cardView.layer.cornerRadius = 8
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.15
        cardView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        cardView.layer.shadowRadius = 8
        cardView.layer.masksToBounds = false
    }
    
    func setLabel(){
        dateLabel.font = UIFont(name: "SFProText-Regular", size: 12.0)
        cafeNameLabel.font = UIFont(name: "SFProText-Bold", size: 16.0)
        addressLabel.font = UIFont(name: "SFProText-Regular", size: 12.0)
        addressLabel.textColor = UIColor(displayP3Red: 151/255, green: 151/255, blue: 151/255, alpha: 1.0)
    }
}

