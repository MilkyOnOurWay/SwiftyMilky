//
//  DeletePlaceConfirmVC.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/03.
//

import UIKit

class DeletePlaceConfirmVC: UIViewController {

    @IBOutlet var rootView: UIView!
    @IBOutlet var deleteConfirmView: UIView!
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var subLabel: UILabel!
    @IBOutlet var confirmBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfirmView()
    }
    
    @IBAction func confirmBtnClicked(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}

extension DeletePlaceConfirmVC {
    func setConfirmView() {
        confirmBtn.layer.cornerRadius = confirmBtn.frame.height / 2
    }
}
