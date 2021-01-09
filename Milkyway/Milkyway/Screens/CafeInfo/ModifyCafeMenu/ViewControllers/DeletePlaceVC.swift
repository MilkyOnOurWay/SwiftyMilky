//
//  DeletePlaceVC.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/03.
//

import UIKit
import DLRadioButton

class DeletePlaceVC: UIViewController {

    
    @IBOutlet var rootView: UIView!
    @IBOutlet var deleteReasonView: UIView!
    
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var barLabel: UILabel! //구분선
    
    @IBOutlet var radioBtn1: DLRadioButton!
    @IBOutlet var radioBtn2: DLRadioButton!
    @IBOutlet var radioBtn3: DLRadioButton!
    @IBOutlet var radioBtn4: DLRadioButton!
    
    @IBOutlet var submitBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfirmView()
        setLabel()
        setRadioButton()
        setSubmitButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        super.touchesBegan(touches, with: event)
        if let touch = touches.first , touch.view == self.view {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        print("submitBtnClicked")
        
        guard let pvc = self.presentingViewController else { return }
        guard let confirmVC = UIStoryboard(name: "DeletePlace", bundle: nil).instantiateViewController(withIdentifier:"DeletePlaceConfirmVC") as? DeletePlaceConfirmVC else {
            return
        }
        
        self.dismiss(animated: false) {
            confirmVC.modalPresentationStyle = .overCurrentContext
            pvc.present(confirmVC, animated: false, completion: nil)
        }
    }
}

extension DeletePlaceVC {
    func setConfirmView() {
        rootView.backgroundColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        
        deleteReasonView.layer.cornerRadius = 8
    }
    
    func setLabel() {
        mainLabel.textAlignment = .center
        mainLabel.text = "삭제를 요청하시는 이유를 알려주세요"
        mainLabel.font = UIFont(name:"SFProText-Bold", size: 16.0)
        
        barLabel.backgroundColor = UIColor(red: 229, green: 229, blue: 229)
    }
    
    func setRadioButton() {
        radioBtn1.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
        radioBtn2.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
        radioBtn3.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
        radioBtn4.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
        
        radioBtn1.icon = UIImage(named: "checkOff") ?? radioBtn1.icon
        radioBtn2.icon = UIImage(named: "checkOff") ?? radioBtn2.icon
        radioBtn3.icon = UIImage(named: "checkOff") ?? radioBtn3.icon
        radioBtn4.icon = UIImage(named: "checkOff") ?? radioBtn4.icon

        radioBtn1.iconSelected = UIImage(named: "checkOn") ?? radioBtn1.iconSelected
        radioBtn2.iconSelected = UIImage(named: "checkOn") ?? radioBtn2.iconSelected
        radioBtn3.iconSelected = UIImage(named: "checkOn") ?? radioBtn3.iconSelected
        radioBtn4.iconSelected = UIImage(named: "checkOn") ?? radioBtn4.iconSelected
        
        radioBtn1.titleLabel?.font = UIFont(name:"SFProText-Regular", size: 16.0)
        radioBtn2.titleLabel?.font = UIFont(name:"SFProText-Regular", size: 16.0)
        radioBtn3.titleLabel?.font = UIFont(name:"SFProText-Regular", size: 16.0)
        radioBtn4.titleLabel?.font = UIFont(name:"SFProText-Regular", size: 16.0)
            
        radioBtn1.setTitleColor(UIColor(named: "Milky"), for: .selected)
        radioBtn2.setTitleColor(UIColor(named: "Milky"), for: .selected)
        radioBtn3.setTitleColor(UIColor(named: "Milky"), for: .selected)
        radioBtn4.setTitleColor(UIColor(named: "Milky"), for: .selected)
        
    }
    
    func setSubmitButton() {
        submitBtn.isEnabled = false
        submitBtn.layer.cornerRadius = submitBtn.frame.height / 2
        submitBtn.setTitle("선택 완료", for: .normal)
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.backgroundColor = .darkGray
        submitBtn.titleLabel?.font = UIFont(name:"SFProText-Semibold", size: 15.0)
    }
    
    @objc func sendBtnTag(_ sender:DLRadioButton) {
        print(sender.tag)
        if sender.tag != 0 {
            submitBtn.isEnabled = true
            submitBtn.backgroundColor = UIColor(named: "Milky")
        }
    }
}
