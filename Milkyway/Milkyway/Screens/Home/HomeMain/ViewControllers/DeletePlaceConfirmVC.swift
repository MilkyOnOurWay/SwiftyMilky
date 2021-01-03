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
    @IBOutlet var confirmBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfirmView()
        setButton()
    }
    
    @IBAction func confirmBtnClicked(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    func setConfirmView() {
        rootView.backgroundColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        
        deleteConfirmView.layer.cornerRadius = 15
    }
    func setButton() {
        confirmBtn.layer.cornerRadius = confirmBtn.frame.height / 2
        confirmBtn.setTitle("확인", for: .normal)
        confirmBtn.setTitleColor(.white, for: .normal)
        confirmBtn.backgroundColor = UIColor(named: "Milky")
    }
}
