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

    @IBOutlet var collectionView: UICollectionView!
    
    var date: String = ""
    
    // 나중에 밑에 라벨붙는거,,
    var tagStr: [String] = ["", "디카페인", "두유", "저지방우유", "무지방우유"]
    var category = [Int]()
//    var categoryData = [String]()
    var categoryData: [String] = ["디카페인", "두유", "저지방우유", "무지방우유", "웅앵", "웅앵"]
//    var size: CGFloat!
//    var text: NSAttributedString!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let categoryCVCellNib = UINib(nibName: "CategoryLabelCell", bundle: nil)
        collectionView.register(categoryCVCellNib, forCellWithReuseIdentifier: "CategoryLabelCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
//        NotificationCenter.default.addObserver(self, selector: #selector(categoryLabelSize), name: Notification.Name("categoryLabelSize"),object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension CompletedTVCell {
    func setCell() {
//        categoryLabel1.isHidden = true
//        categoryLabel2.isHidden = true
//        categoryLabel3.isHidden = true
//        categoryLabel4.isHidden = true
    }
    func setCategory(category: [Int]) {
        self.category = category
        print("완료제보 카테고리 \(category), \(category.count)")

        for i in 0...self.category.count-1 {            categoryData.append(tagStr[self.category[i]])
        }

//        for i in 0...self.category.count-1 {
//            let label = self.viewWithTag(i+1) as! UILabel
//            label.text = tagStr[self.category[i]]
//            label.isHidden = false
//            //print("여기는 카테고리 \(self.viewWithTag(i+1)!)")
//        }
    }
//
//    @objc func categoryLabelSize(_ noti: NSNotification) {
//        size = noti.object as! CGFloat
//        print(size)
//    }
}
extension CompletedTVCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryLabelCell.identifier, for: indexPath) as? CategoryLabelCell else {
            return UICollectionViewCell()
        }
        cell.setCell(category: categoryData[indexPath.row])
        return cell
    }
}

extension CompletedTVCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dynamicFrame = NSAttributedString(string: categoryData[indexPath.item])
        let width = dynamicFrame.size().width + 25
        return CGSize(width: width,  height: self.collectionView.frame.height )
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
