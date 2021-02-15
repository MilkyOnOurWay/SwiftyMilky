//
//  SocialLoginVC.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/02/15.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class SocialLoginVC: UIViewController {

    @IBOutlet var kakaoSignInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func kakaoLoginDidTap(_ sender: Any) {
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
}
extension SocialLoginVC {
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
                print("id: \(user?.id)")
                
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
                self.navigationController?.pushViewController(nickVC, animated: true)
            }
        }
    }
}
