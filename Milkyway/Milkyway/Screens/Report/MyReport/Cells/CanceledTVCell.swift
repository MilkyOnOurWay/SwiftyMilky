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
    
    var cafeName: String = ""
    var created_at: String = ""
    
    var cancelData = [MyReport]()
    var rejectId = 0
    var cafeId = 0
    
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
        return cancelData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RectangleCVCell.identifier, for: indexPath) as? RectangleCVCell else {
            return UICollectionViewCell()
        }
        cell.setCell(backName: "canceledReport")
        // 시간부분 date formatt
        let originAddTime = cancelData[indexPath.row].createdAt
        let formattedTime = originAddTime.getDateFormat(time: originAddTime) ?? ""
        print("포맷시간, \(formattedTime)")
        cell.setLabel(storeName: cancelData[indexPath.row].cafeName,
                      date: formattedTime,
                      color: "lightGrey")
        return cell
    }
    
    
}
extension CanceledTVCell {
    
    func setCell(cancelData: [MyReport]) {
        
        self.cancelData = cancelData
        
        let collectionViewCellNib = UINib(nibName: "RectangleCVCell", bundle: nil)
        collectionView.register(collectionViewCellNib, forCellWithReuseIdentifier: "RectangleCVCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.reloadData()
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
        
        
        print("취소된 제보 하나 누름 \(indexPath.row) - \(cancelData[indexPath.row].rejectReasonID!)")
        
        rejectId = cancelData[indexPath.row].rejectReasonID!
        cafeId = cancelData[indexPath.row].id
        
        NotificationCenter.default.post(name: Notification.Name("cancelReason"),
                                        object: [rejectId, cafeId,indexPath.row])
    }
}


