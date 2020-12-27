//
//  UITableView+Extension.swift
//  Milkyway
//
//  Created by 이윤진 on 2020/12/28.
//


import UIKit.UITableView

import Then
import SnapKit

extension UITableView {
    
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let titleLabel = UILabel().then {
            $0.textColor = .black
            $0.text = title
            $0.font = Font.emptyTableBoldLabel
        }
        let messageLabel = UILabel().then {
            $0.text = message
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.textColor = .lightGray
            $0.font = Font.emptyTableLabel
        }

        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(emptyView.snp.centerY)
            make.centerX.equalTo(emptyView.snp.centerX)
        }
        
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalTo(emptyView.snp.left).offset(20)
            make.right.equalTo(emptyView.snp.right).offset(-20)
        }

        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
}
