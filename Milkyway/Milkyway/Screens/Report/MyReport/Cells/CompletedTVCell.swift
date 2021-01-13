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
    
    @IBOutlet var categoryLabel1: CustomLabel!
    @IBOutlet var categoryLabel2: CustomLabel!
    @IBOutlet var categoryLabel3: CustomLabel!
    @IBOutlet var categoryLabel4: CustomLabel!
    
    @IBOutlet var decafWidth: NSLayoutConstraint!
    @IBOutlet var soyWidth: NSLayoutConstraint!
    @IBOutlet var lowWidth: NSLayoutConstraint!
    @IBOutlet var freeWidth: NSLayoutConstraint!
    
    
    var date: String = ""
    
    // 나중에 밑에 라벨붙는거,,
    var menuTag: [String] = ["", "디카페인", "두유", "저지방우유", "무지방우유"]
    var category = [Int]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension CompletedTVCell {
    func setCell(category: [Int]) {
//        categoryLabel1.isHidden = true
//        categoryLabel2.isHidden = true
//        categoryLabel3.isHidden = true
//        categoryLabel4.isHidden = true
        decafWidth.constant = 0
//        soyWidth.constant = 0
//        lowWidth.constant = 0
        freeWidth.constant = 0
        
        cardView.borderWidth = 1
        cardView.borderColor = UIColor(displayP3Red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0)
        cardView.backgroundColor = UIColor(named: "lightGrey")
        cardView.layer.cornerRadius = 8
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.15
        cardView.layer.shadowOffset = CGSize(width: 2, height: 2)
        cardView.layer.shadowRadius = 8
        cardView.layer.masksToBounds = false
        

//        for i in 0...myReportData.done[indexPath.row].category!.count-1 {
//            cell.viewWithTag(category[i])?.isHidden = false
//        }
    }
}
