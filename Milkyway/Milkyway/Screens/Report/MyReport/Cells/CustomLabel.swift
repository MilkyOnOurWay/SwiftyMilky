//
//  CustomLabel.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/06.
//

import UIKit

class CustomLabel: UILabel {

    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        self.textColor = UIColor(named: "Milky")
        self.font = UIFont(name: "SFProText-Semibold", size: 12.0)
        self.textAlignment = .center
        
    }
}
