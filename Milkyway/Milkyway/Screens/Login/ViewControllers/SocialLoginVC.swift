//
//  SocialLoginVC.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/02/15.
//

import UIKit
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser

class SocialLoginVC: UIViewController {

    @IBOutlet var kakaoSignInBtn: UIButton!
    @IBOutlet var appleSignInBtn: UIStackView!
    
    var userIdentifier: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLoginButton()
    }
    
}

extension SocialLoginVC {
    func setLoginButton() {
        kakaoSignInBtn.layer.cornerRadius = kakaoSignInBtn.frame.height / 2
        kakaoSignInBtn.addTarget(self, action: #selector(kakaoLogin), for: .touchUpInside)
        
        let authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        
        authorizationButton.setValue(authorizationButton.frame.height / 2, forKey: "cornerRadius")
        authorizationButton.addTarget(self, action: #selector(appleSignInButtonPress), for: .touchUpInside)
        self.appleSignInBtn.addArrangedSubview(authorizationButton)
    }
    // MARK: - KAKAO Login
    @objc func kakaoLogin() {
        // 카카오톡 설치 여부 확인
        if (AuthApi.isKakaoTalkLoginAvailable()) {
            // 카카오톡 로그인. api 호출 결과를 클로저로 전달.
            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    // 예외 처리 (로그인 취소 등)
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    
                    _ = oauthToken
                    
                    let accessToken = oauthToken?.accessToken
                    
                    //카카오 로그인을 통해 사용자 토큰을 발급 받은 후 닉네임 설정 뷰로 이동
                    self.moveToNickView()
                }
            }
        }
        else { // 카카오 계정으로 로그인
            AuthApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    
                    //do something
                    _ = oauthToken
                    // 어세스토큰
//                    let accessToken = oauthToken?.accessToken
                    self.moveToNickView()
                }
            }
        }
    }
    func moveToNickView() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                //do something
                _ = user
                
                guard let nickVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else {
                    return
                }
                print("kakao id: \(user?.id)")
                
                // id, sns 구분자
//                if let snsId = user?.id {
//                    nickVC.snsId = String(snsId)
//                }
//                nickVC.provider = "kakao"
                
                // 프로필 이미지
//                if let url = user?.kakaoAccount?.profile?.profileImageUrl,
//                   let data = try? Data(contentsOf: url) {
//                    self.profileImageView.image = UIImage(data: data)
//                }
                nickVC.modalPresentationStyle = .fullScreen
                self.present(nickVC, animated: false, completion: nil)
            }
        }
    }
    
    //MARK:- APPLE Login
    @objc func appleSignInButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
            
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}
extension SocialLoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
extension SocialLoginVC: ASAuthorizationControllerDelegate {
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                
            // 계정 정보 가져오기
            userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
                
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
     
            self.saveUserInKeychain(userIdentifier)
            self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
            
        case let passwordCredential as ASPasswordCredential:
        
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                self.showPasswordCredentialAlert(username: username, password: password)
            }
        default:
            break
        }
    }
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "com.milkys.Milkyway", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
    private func showResultViewController(userIdentifier: String, fullName: PersonNameComponents?, email: String?) {
        guard let nickVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else {
            return
        }
//        NickVC.snsId = userIdentifier
//        NickVC.provider = "apple"
        nickVC.modalPresentationStyle = .fullScreen
        self.present(nickVC, animated: false, completion: nil)

        DispatchQueue.main.async {
//            viewController.userIdentifierLabel.text = userIdentifier
//            if let givenName = fullName?.givenName {
//                viewController.givenNameLabel.text = givenName
//            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("apple id 연동 실패")
    }
}
