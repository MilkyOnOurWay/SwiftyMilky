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
    
    @IBOutlet weak var deletedOKView: UIImageView!
    @IBOutlet weak var deletedBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deletedOKView.isHidden = true
        deletedBtn.isEnabled = false
        
        
      
    }
    
    @IBAction func noBtnClicked(_ sender: Any) {
        print("noBtnClicked()")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeBtnClicked(_ sender: Any) {
        print("removeBtnClicked()")
        deletedBtn.isEnabled = true
        deletedOKView.isHidden = false
        noBtn.isEnabled = false
        removeBtn.isEnabled = false
        
        
        // tableview ... 삭제되어야함 ..... ㅠ
        NotificationCenter.default.post(name: Notification.Name("removeCafe"), object: nil)
        
    }
    
    @IBAction func deletedOKBtnClicked(_ sender: Any) {
        print("removeBtnClicked()")
        self.dismiss(animated: true, completion: nil)
    }
    
}
