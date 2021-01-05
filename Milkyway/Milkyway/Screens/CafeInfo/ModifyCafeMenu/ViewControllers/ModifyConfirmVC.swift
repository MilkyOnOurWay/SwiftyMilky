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
        setLabel()
        setButton()
    }
    
    @IBAction func confirmBtnClicked(_ sender: Any) {
        print("Home - confirmBtnClicked")
        let presentingVC = self.presentingViewController
        self.dismiss(animated: false) {
            presentingVC?.navigationController?.popToRootViewController(animated: false)
        }
    }
}

extension ModifyConfirmVC {
    func setConfirmView() {
        rootView.backgroundColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        confirmView.layer.cornerRadius = 15
    }
    
    func setLabel() {
        mainLabel.textAlignment = .center
        mainLabel.text = "요청이 접수 되었습니다"
        mainLabel.font = UIFont(name:"SFProText-Bold", size: 16.0)
        
        subLabel.textAlignment = .center
        subLabel.numberOfLines = 2
        subLabel.text = "꼼꼼히 검토 후 적용하도록 하겠습니다\n감사합니다!"
        subLabel.font = UIFont(name:"SFProText-Regular", size: 12.0)
        subLabel.textColor = UIColor(displayP3Red: 80/255, green: 85/255, blue: 92/255, alpha: 1)
    }
    func setButton() {
        confirmBtn.layer.cornerRadius = confirmBtn.frame.height / 2
        confirmBtn.setTitle("확인", for: .normal)
        confirmBtn.setTitleColor(.white, for: .normal)
        confirmBtn.backgroundColor = UIColor(named: "Milky")
        confirmBtn.titleLabel?.font = UIFont(name:"SFProText-Semibold", size: 15.0)
    }
}
