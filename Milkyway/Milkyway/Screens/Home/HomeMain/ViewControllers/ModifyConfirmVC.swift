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
    @IBOutlet var confirmBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfirmView()
        setButton()
    }
    
    @IBAction func confirmBtnClicked(_ sender: Any) {
        print("Home - confirmBtnClicked")
        let presentingVC = self.presentingViewController
        self.dismiss(animated: false) {
            presentingVC?.navigationController?.popToRootViewController(animated: false)
        }
    }

    func setConfirmView() {
        rootView.backgroundColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        
        confirmView.layer.cornerRadius = 15
    }
    
    func setButton() {
        confirmBtn.layer.cornerRadius = confirmBtn.frame.height / 2
        confirmBtn.setTitle("확인", for: .normal)
        confirmBtn.setTitleColor(.white, for: .normal)
        confirmBtn.backgroundColor = UIColor(named: "Milky")
    }

}
