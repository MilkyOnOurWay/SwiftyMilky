//
//  CanceledTVCell.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/07.
//

import UIKit

class CanceledTVCell: UITableViewCell {

    //취소된 제보
    
    static let identifier = "CanceledTVCell"
    
    
    @IBOutlet var rootView: UIView!
    @IBOutlet var canceledLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var rootHeight: NSLayoutConstraint!
    
    let horizonInset: CGFloat = 20
    let rightSpacing: CGFloat = 20
    let lineSpacing: CGFloat = 5
    
    var count : Int = 0 //cell 개수 받아오기
    var cafeName: String = ""
    var created_at: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
extension CanceledTVCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RectangleCVCell.identifier, for: indexPath) as? RectangleCVCell else {
            return UICollectionViewCell()
        }
        cell.setCell(backName: "canceledReport")
        cell.setLabel(storeName: cafeName, date: created_at, color: "lightGrey")
        return cell
    }
    
    
}

extension CanceledTVCell: UICollectionViewDelegateFlowLayout {
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

extension CanceledTVCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: Notification.Name("cancelReason"), object: nil)
    }
}

extension CanceledTVCell {
    
    func setCell(count: Int, cafeName: String, created_at: String) {
        
        self.count = count
        self.cafeName = cafeName
        self.created_at = created_at
        
        canceledLabel.text = "취소된 제보"
        canceledLabel.font = UIFont(name:"SFProText-Bold", size: 16.0)
        
        let collectionViewCellNib = UINib(nibName: "RectangleCVCell", bundle: nil)
        collectionView.register(collectionViewCellNib, forCellWithReuseIdentifier: "RectangleCVCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
//    @objc func cancelCellTap () {
//
//    }
}
