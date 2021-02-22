//
//  ModifyConfirmVC.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/03.
//

import UIKit

class ModifyConfirmVC: UIViewController {

    @IBOutlet var rootView: UIView!
    @IBOutlet var confirmView: UIView!
    
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var subLabel: UILabel!
    @IBOutlet var confirmBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfirmView()
    }
    
    @IBAction func confirmBtnClicked(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("modifyConfirm"), object: nil)
        self.dismiss(animated: false, completion: nil)
    }
}

extension ModifyConfirmVC {
    func setConfirmView() {
        confirmBtn.layer.cornerRadius = confirmBtn.frame.height / 2
    }
}
