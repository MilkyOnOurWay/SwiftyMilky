//
//  CustomLabel.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/06.
//

import UIKit

class CustomLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 6.0
    @IBInspectable var bottomInset: CGFloat = 6.0
    @IBInspectable var leftInset: CGFloat = 12.0
    @IBInspectable var rightInset: CGFloat = 12.0
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        self.textColor = UIColor(named: "Milky")
        self.font = UIFont(name: "SFProText-Semibold", size: 12.0)
        self.textAlignment = .center
    }
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
    }
}
