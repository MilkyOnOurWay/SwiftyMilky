//
//  UIView + AlertView.swift
//  Milkyway
//
//  Created by soyounglee on 2021/02/18.
//

import Foundation
import UIKit

public func makeAlert(title : String, message : String, vc : UIViewController)
{
    let alertViewController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)
    let action = UIAlertAction(title: "네", style: .cancel, handler: nil)
    let noAction = UIAlertAction(title: "아니오", style: .destructive, handler: nil)
    alertViewController.addAction(noAction)
    alertViewController.addAction(action)
    vc.present(alertViewController, animated: true, completion: nil)
}

