//
//  NicknameChangeVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/12.
//

import UIKit
import Lottie
import SwiftKeychainWrapper

class NicknameChangeVC: UIViewController {
    
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    @IBOutlet weak var backButton: UIButton!
    var uuid: String?
    var count = 0
    var nickname: String?
    let loadingView = AnimationView(name: "loadingLottie")
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
        setLabel()
        setTextfield()
        setCheckBox()
        addKeyboardNotification()
        setBackButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showLottie), name: Notification.Name("startlottiehome"),object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopLottie), name: Notification.Name("stoplottiehome"),object: nil)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func textfieldDidTap(_ sender: Any) {
        
    }
    
}

extension NicknameChangeVC {
    
    @objc func showLottie(){
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        loadingView.center = self.view.center
        loadingView.contentMode = .scaleAspectFill
        loadingView.loopMode = .loop
        self.view.addSubview(loadingView)
        
        loadingView.play()
        
    }
    
    @objc func stopLottie(){
        
        loadingView.stop()
        loadingView.removeFromSuperview()
        
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
    
    func setButton(){
        
        changeButton.addTarget(self, action: #selector(changeButtonDidTap), for: .touchUpInside)
        changeButton.isEnabled = false
    }
    
    func setBackButton(){
        
        backButton.addTarget(self, action: #selector(backbuttondidTap), for: .touchUpInside)
    }
    
    func isValidNickname(_ nickname: String) -> Bool{
        
        let nicknameRegEx = "[가-힣0-9]{1,10}"
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
    
    @objc func changeButtonDidTap(){
        uuid = UUID().uuidString
        // 여기서 서버코드 연결할 것
        // 지금 닉네임 변경만 되고 홈 넘어가는게 안되는데 그 이슈 다시 생각해봐야할듯
        //        let vc = UIStoryboard.init(name: "TabBar", bundle: nil).instantiateViewController(identifier: "TabBarController") as? TabBarController
        //        vc?.modalPresentationStyle = .fullScreen
        //        self.present(vc!, animated: true, completion: nil)
        changeNicknameService(nickname ?? "", uuid ?? "")
        let vc = UIStoryboard.init(name: "TabBar", bundle: nil).instantiateViewController(identifier: "TabBarController") as? TabBarController
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
    @objc func backbuttondidTap(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 닉네임 변경 서버
    
    func changeNicknameService(_ nickname: String, _ uuid: String){
        
        UserService.shared.changeNickname(nickname) {
            responseData in
            switch responseData {
            case .success(let res):
                
                let response = res as! ResponseTempResult
                //                self.showLottie()
                //                print(response.message ?? "")
                let changedNickname = nickname
                print(changedNickname)
            //self.loginService(self.uuid ?? "", changedNickname)
            //                let vc = UIStoryboard.init(name: "TabBar", bundle: nil).instantiateViewController(identifier: "TabBarController") as? TabBarController
            //                vc?.modalPresentationStyle = .fullScreen
            //                self.present(vc!, animated: true, completion: nil)
            case .requestErr(_):
                print(".requestErr")
            case .pathErr:
                print(".pathErr")
            case .serverErr:
                print(".serverErr")
            case .networkFail:
                print(".networkErr")
            }
        }
    }
    
    @objc func loginService(_ uuid: String, _ nickname: String){
        
        UserService.shared.signIn(uuid, nickname) { responseData in
            switch responseData {
            
            case .success(let res):
                dump(res)
                let response: Token = res as! Token
                KeychainWrapper.standard.set(response.accessToken, forKey: "Token")
                
                let vc = UIStoryboard.init(name: "TabBar", bundle: nil).instantiateViewController(identifier: "TabBarController") as? TabBarController
                self.stopLottie()
                vc?.modalPresentationStyle = .fullScreen
            case .requestErr(_):
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("")
            }
            
        }
    }
    
}

extension NicknameChangeVC: UITextFieldDelegate {
    
    
    // MARK: - 닉네임 유효성 판단
    @objc func checkRegister(_ textfield: UITextField) {
        
        nickname = textfield.text
        let count = String(nickname?.count ?? 0)
        countLabel.text = "\(count)/10"
        
        if nickname?.count ?? 0 > 10 {
            countLabel.isHidden = true
        }
        
        if !isValidNickname(nickname!){
            stateLabel.isHidden = false
            countLabel.isHidden = false
            if nickname?.count == 0 {
                countLabel.isHidden = true
            }
            checkBoxImageView.isHidden = true
            changeButton.setBackgroundImage(UIImage(named: "btnStartDisabled"), for: .normal)
            stateLabel.text = "사용 불가한 닉네임입니다."
            stateLabel.textColor = .red
            backgroundImageView.image = UIImage(named: "inputError")
            return
        }else {
            
            stateLabel.isHidden = true
            changeButton.setBackgroundImage(UIImage(named: "btnStart"), for: .normal)
            changeButton.isEnabled = true
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




