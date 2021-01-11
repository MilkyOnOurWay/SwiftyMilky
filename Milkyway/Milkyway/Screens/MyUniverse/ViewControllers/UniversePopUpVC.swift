//
//  UniversePopUpVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/11.
//

import UIKit

class UniversePopUpVC: UIViewController {

    @IBOutlet weak var askRemoveView: UIView!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    @IBAction func noBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
