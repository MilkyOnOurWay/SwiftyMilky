//
//  SplashVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/07.
//

import UIKit
import Lottie

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setSplashView()
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {

            let vc = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(identifier: "LoginNaviController")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
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
}
