//
//  InProgressTVCell.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/07.
//

import UIKit

class InProgressTVCell: UITableViewCell {

    static let identifier = "InProgressTVCell"
    
    @IBOutlet var inProgressLabel: UILabel!
    @IBOutlet var completedLabel: UILabel!
    @IBOutlet var emptyLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var spaceLength: NSLayoutConstraint!
    
    
    let horizonInset: CGFloat = 20
    let rightSpacing: CGFloat = 20
    let lineSpacing: CGFloat = 6
    
    var count: Int = 0 // cell 개수 받아오기
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
extension InProgressTVCell {
    
    func setLabel() {
        inProgressLabel.text = "진행중인 제보"
        inProgressLabel.font = UIFont(name:"SFProText-Bold", size: 16.0)
        
        completedLabel.text = "완료된 제보"
        completedLabel.font = UIFont(name:"SFProText-Bold", size: 16.0)
        
        emptyLabel.text = "지금 진행중인 제보가 없습니다!"
        emptyLabel.textAlignment = .center
        emptyLabel.font = UIFont(name:"SFProText-Regular", size: 16.0)
        emptyLabel.textColor = UIColor(named: "darkGrey")
    }
    
    func setCell(count: Int) {
        
        self.count = count
        
        if count == 0 {
            collectionView.isHidden = true
        }
        let collectionViewCellNib = UINib(nibName: "RectangleCVCell", bundle: nil)
        collectionView.register(collectionViewCellNib, forCellWithReuseIdentifier: "RectangleCVCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}
extension InProgressTVCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RectangleCVCell.identifier, for: indexPath) as? RectangleCVCell else {
            return UICollectionViewCell()
        }
        cell.setCell(backName: "inprogressReport")
        cell.setLabel(storeName: "현빈스빈스카페", date: "2020.11.30", color: "darkGrey")
        return cell
    }
    
    
}

extension InProgressTVCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = collectionView.frame.height
        let cellWidth = (collectionView.frame.width - horizonInset - rightSpacing) / 2
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: horizonInset, bottom: 0, right: horizonInset) }
}
