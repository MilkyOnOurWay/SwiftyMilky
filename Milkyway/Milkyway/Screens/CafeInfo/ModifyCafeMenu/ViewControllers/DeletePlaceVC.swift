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
    
    @IBOutlet var radioBtn1: DLRadioButton!
    @IBOutlet var radioBtn2: DLRadioButton!
    @IBOutlet var radioBtn3: DLRadioButton!
    @IBOutlet var radioBtn4: DLRadioButton!
    
    @IBOutlet var submitBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfirmView()
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
    
    @objc func sendBtnTag(_ sender:DLRadioButton) {
        print(sender.tag)
        if sender.tag != 0 {
            submitBtn.isEnabled = true
            submitBtn.backgroundColor = UIColor(named: "Milky")
        }
    }
    
    func setConfirmView() {
        rootView.backgroundColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        
        deleteReasonView.layer.cornerRadius = 15
    }
    
    func setRadioButton() {
        radioBtn1.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
        radioBtn2.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
        radioBtn3.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
        radioBtn4.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
        
//        radioBtn1.icon = UIImage(systemName: "hand.thumbsdown") ?? radioBtn1.icon
//        radioBtn2.icon = UIImage(systemName: "hand.thumbsdown") ?? radioBtn2.icon
//        radioBtn3.icon = UIImage(systemName: "hand.thumbsdown") ?? radioBtn3.icon
//        radioBtn4.icon = UIImage(systemName: "hand.thumbsdown") ?? radioBtn4.icon
//
//        radioBtn1.iconSelected = UIImage(systemName: "hand.thumbsup") ?? radioBtn1.iconSelected
//        radioBtn2.iconSelected = UIImage(systemName: "hand.thumbsup") ?? radioBtn2.iconSelected
//        radioBtn3.iconSelected = UIImage(systemName: "hand.thumbsup") ?? radioBtn3.iconSelected
//        radioBtn4.iconSelected = UIImage(systemName: "hand.thumbsup") ?? radioBtn4.iconSelected
    }
    
    func setSubmitButton() {
        submitBtn.isEnabled = false
        submitBtn.layer.cornerRadius = submitBtn.frame.height / 2
        submitBtn.setTitle("선택 완료", for: .normal)
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.backgroundColor = .darkGray
    }
}
