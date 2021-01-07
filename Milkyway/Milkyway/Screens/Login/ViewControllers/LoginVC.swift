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
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoImageView: UIImageView!
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCheckBox()
        setButton()
        setLabel()
        setTextfield()
        addKeyboardNotification()
        setAnimation()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func textfieldDidTap(_ sender: Any) {
        checkMaxLength(nicknameTextField, maxLength: 10)
    }
}


extension LoginVC {
    
    
    func setAnimation(){
        logoImageView.alpha = 0
        UIView.animate(withDuration: 1.0, animations: ({
            self.logoImageView.alpha  = 1;
        }))
    }
    func setLabel(){
        
        countLabel.isHidden = true
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
        startButton.isEnabled = false
    }
    
    func isValidNickname(_ nickname: String) -> Bool{
        
        let nicknameRegEx = "[가-힣0-9]{2,10}"
        let nicknameTest = NSPredicate(format: "SELF MATCHES %@", nicknameRegEx)
        
        return nicknameTest.evaluate(with: nickname)
    }
    
    func addKeyboardNotification(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func startButtonDidTap(){
        
        let vc = UIStoryboard.init(name: "TabBar", bundle: nil).instantiateViewController(identifier: "TabBarController") as? TabBarController
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        print(#function)
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.bottomConstraint.constant = keyboardHeight + 20
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.bottomConstraint.constant = 20
            self.view.layoutIfNeeded()
        }
    }
}

extension LoginVC: UITextFieldDelegate {
    
    // MARK: - 닉네임 유효성 판단
    @objc func checkRegister(_ textfield: UITextField) {
        
        let nickname = textfield.text
        let count = String(nickname?.count ?? 0)
        countLabel.text = "\(count)/10"
        
        if !isValidNickname(nickname!){
            stateLabel.isHidden = false
            countLabel.isHidden = false
            if nickname?.count == 0 {
                countLabel.isHidden = true
            }
            checkBoxImageView.isHidden = true
            startButton.setBackgroundImage(UIImage(named: "btnStartDisabled"), for: .normal)
            stateLabel.text = "사용 불가한 닉네임입니다."
            stateLabel.textColor = .red
            backgroundImageView.image = UIImage(named: "inputError")
            return
        }else {
            stateLabel.isHidden = true
            startButton.setBackgroundImage(UIImage(named: "btnStart"), for: .normal)
            startButton.isEnabled = true
            checkBoxImageView.isHidden = false
            backgroundImageView.image = UIImage(named: "inputCorrect")
            return
        }
        
        
    }
    
    func checkMaxLength(_ textfield: UITextField, maxLength: Int){
        if(textfield.text?.count ?? 0 > maxLength){
            textfield.deleteBackward()
            textfield.resignFirstResponder()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
}
