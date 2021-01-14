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
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var cafeNameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    @IBOutlet var categoryLabel1: CustomLabel!
    @IBOutlet var categoryLabel2: CustomLabel!
    @IBOutlet var categoryLabel3: CustomLabel!
    @IBOutlet var categoryLabel4: CustomLabel!
    
    var date: String = ""
    
    // 나중에 밑에 라벨붙는거,,
    var tagStr: [String] = ["", "디카페인", "두유", "저지방우유", "무지방우유"]
    var category = [Int]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension CompletedTVCell {
    func setCell() {
        categoryLabel1.isHidden = true
        categoryLabel2.isHidden = true
        categoryLabel3.isHidden = true
        categoryLabel4.isHidden = true
    }
    func setCategory(category: [Int]) {
        self.category = category
        print("완료제보 카테고리 \(category), \(category.count)")


        for i in 0...self.category.count-1 {
            let label = self.viewWithTag(i+1) as! UILabel
            label.text = tagStr[self.category[i]]
            label.isHidden = false
            print("여기는 카테고리 \(self.viewWithTag(i+1)!)")
        }
    }
}
