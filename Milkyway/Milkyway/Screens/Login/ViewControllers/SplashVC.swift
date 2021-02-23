//
//  SplashVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/07.
//

import UIKit
import Lottie
import SwiftKeychainWrapper
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser

class SplashVC: UIViewController {
    
    var kakaoId: String!
    var appleId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSplashView()
        kakaoLogin()
        appleId = KeychainItem.currentUserIdentifier
        
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
           if KeychainWrapper.standard.string(forKey: "Token") != nil {
                let vc = UIStoryboard.init(name: "TabBar", bundle: nil).instantiateViewController(identifier: "TabBarController") as? TabBarController
                vc?.modalPresentationStyle = .fullScreen
                self.present(vc!, animated: true, completion: nil)
            }
            
            let vc = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(identifier: "LoginNaviController")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
            
            // 분기 처리
//            if self.kakaoId != nil {
//                // 나중에 서버에 snsId POST하고 넘어가기
//                print("splash kakao \(self.kakaoId)")
//                let vc = UIStoryboard.init(name: "TabBar", bundle: nil).instantiateViewController(identifier: "TabBarController") as? TabBarController
//                vc?.modalPresentationStyle = .fullScreen
//                self.present(vc!, animated: true, completion: nil)
//            }
//            else if self.appleId != nil {
//                // 나중에 서버에 snsId POST하고 넘어가기
//                print("splash apple \(self.appleId)")
//                let vc = UIStoryboard.init(name: "TabBar", bundle: nil).instantiateViewController(identifier: "TabBarController") as? TabBarController
//                vc?.modalPresentationStyle = .fullScreen
//                self.present(vc!, animated: true, completion: nil)
//            }
//            else {
//                let vc = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(identifier: "LoginNaviController")
//                vc.modalPresentationStyle = .fullScreen
//                self.present(vc, animated: false, completion: nil)
//            }
        })
        
    }
    
}

extension SplashVC {
    
    func setSplashView(){
        let animationView = AnimationView(name: "밀키웨이_ios_스플레쉬")
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFill
        view.addSubview(animationView)
        animationView.play()
    }
    func kakaoLogin() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("splash kakao me() success.")
                _ = user
                if let snsId = user?.id {
                    self.kakaoId = String(snsId)
                }
            }
        }
    }
}
