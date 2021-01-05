//
//  CardVC.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/04.
//

import UIKit

class CardVC: UIViewController {

    @IBOutlet var handleArea: UIView!
    @IBOutlet var handleBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHandler()
    }

    func setHandler() {
        handleBar.layer.cornerRadius = handleBar.frame.height / 2
    }

}
