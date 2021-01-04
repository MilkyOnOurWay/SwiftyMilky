//
//  LoginVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2020/12/30.
//

import UIKit

class LoginVC: UIViewController{
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextfield()
        setCheckBox()
        setButton()
        setLabel()
        // Do any additional setup after loading the view.
    }
    
}


extension LoginVC {
    
    func setLabel(){
        
        stateLabel.isHidden = true
    }
    func setTextfield(){
        
        nicknameTextField.delegate = self
        nicknameTextField.addTarget(self, action: #selector(checkRegister), for: .editingChanged)
    }
    func setCheckBox(){
        checkBoxImageView.isHidden = true
    }
    
    // MARK: - 로그인 완료 버튼 눌렀을 때 액션
    func setButton(){
        
        startButton.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
    }
    
    func isValidNickname(_ nickname: String) -> Bool{
        
        let nicknameRegEx = "[가-힣0-9]{2,10}"
        let nicknameTest = NSPredicate(format: "SELF MATCHES %@", nicknameRegEx)
        
        return nicknameTest.evaluate(with: nickname)
    }
    
    @objc func startButtonDidTap(){
        
        let vc = UIStoryboard.init(name: "TabBar", bundle: nil).instantiateViewController(identifier: "TabBarController") as? TabBarController
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
    }
}

extension LoginVC: UITextFieldDelegate {
    
    // MARK: - 닉네임 유효성 판단
    @objc func checkRegister(_ textfield: UITextField) {
        
        let nickname = textfield.text
        //변경전
//        if !isValidNickname(nickname!){
//            stateLabel.isHidden = false
//            stateLabel.text = "영어, 특수문자, 이모티콘은 사용 불가합니다."
//            countLabel.text = String(nicknameTextField.text?.count ?? 0)
//
//            return
//        } else {
//
//            return
//        }
        //변경후
        while nicknameTextField.text?.count ?? 0 < 11 {
            
            if !isValidNickname(nickname!) {
                
                stateLabel.isHidden = false
                stateLabel.text = "영어, 특수문자, 이모티콘은 사용 불가합니다."
                countLabel.text = String(nicknameTextField.text?.count ?? 0)
                
                
                return
            } else {
                
                return
            }
        }
        
    }
    
    @objc func textFieldDidChange(){
        
        
    }
    
    
}
