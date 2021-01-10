//
//  UITextField+Extension.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/07.
//


/// 텍스트필드 앞 쪽 약간 inset 두는 extension

import UIKit

@IBDesignable
class FormTextField: UITextField {

    @IBInspectable var inset: CGFloat = 0
    
    //let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset))
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset))
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset))
    }
    
    
    // 복붙 안되게 하기
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
           if action == #selector(UIResponderStandardEditActions.paste(_:)) {
               return false
           }
           return super.canPerformAction(action, withSender: sender)
      }
}
