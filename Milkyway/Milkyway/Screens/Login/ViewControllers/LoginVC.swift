//
//  LoginVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2020/12/30.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
        // Do any additional setup after loading the view.
    }
    
}

extension LoginVC {
    
    func setButton(){
        
        startButton.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
    }
    
    @objc func startButtonDidTap(){
        
        let vc = UIStoryboard.init(name: "TabBar", bundle: nil).instantiateViewController(identifier: "TabBarController") as? TabBarController
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
    }
}
