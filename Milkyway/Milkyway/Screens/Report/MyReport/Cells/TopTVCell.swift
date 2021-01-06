//
//  TopTVCell.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/04.
//

import UIKit

class TopTVCell: UITableViewCell {

    static let identifier = "TopTVCell"
    @IBOutlet var milkyImageView: UIImageView!
    @IBOutlet var nickNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension TopTVCell {
    func setCell(nickName: String) {
        let boldAtt = [
            NSAttributedString.Key.font: UIFont(name: "SFProText-Bold", size: 20.0)!
        ]
        let regularAtt = [
            NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 20.0)!
        ]
        let boldText = NSAttributedString(string: "\(nickName)님 ", attributes: boldAtt)
        let regularText1 = NSAttributedString(string: "덕분에\n", attributes: regularAtt)
        let regularText2 = NSAttributedString(string: "밀키웨이가 빛나고 있어요!", attributes: regularAtt)
        
        
        let newString = NSMutableAttributedString()
        newString.append(boldText)
        newString.append(regularText1)
        newString.append(regularText2)
        nickNameLabel.attributedText = newString
        nickNameLabel.textColor = .white
        nickNameLabel.numberOfLines = 2
    }
}
