//
//  UIViewController+Extension.swift
//  Milkyway
//
//  Created by 이윤진 on 2020/12/28.
//

import UIKit.UIViewController

extension UIViewController {

    // 2칸인 alert title - up, message - down
    func simpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인", style: .default) { (action) in
            
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    // 예 버튼을 누를때 핸들러로 핸들링하는 Alert with cancel
    func simpleAlertWithHandler(title: String, msg: String?, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "아니오", style: .default)
        let noAction = UIAlertAction(title: "예", style: .default, handler: handler)
        
        alert.addAction(okAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true)
    }
    
    func loginAlert(title: String, msg: String?, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "취소", style: .default)
        let noAction = UIAlertAction(title: "로그인", style: .default, handler: handler)
        
        alert.addAction(okAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true)
    }

    func normalAlertWithHandler(title: String,
                                msg: String?,
                                okTitle: String,
                                noTitle: String,
                                handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let noAction = UIAlertAction(title: noTitle, style: .default)
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: handler)

        alert.addAction(noAction)
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
    
    func oneAlertWithHandler(title: String, msg: String?, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "예", style: .cancel, handler: handler)
        
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    // 예 버튼을 누를때 핸들러로 핸들링하는 Alert without cancel
    func simpleDismissAlert(title: String, msg: String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "예", style: .cancel, handler: handler)
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
    
    func showToast(_ message: String,
                   _ yAnchor: CGFloat = 0,
                   _ textColor: UIColor = .white,
                   _ textFont: UIFont = .systemFont(ofSize: 15, weight: .bold),
                   _ backgroundColor: UIColor = .black,
                   _ backgroundRadius: CGFloat = 5,
                   _ duration: TimeInterval = 3) {
                   
        let label = UILabel()
        let backgroundView = UIView()
        
        backgroundView.backgroundColor = backgroundColor.withAlphaComponent(0.6)
        backgroundView.layer.cornerRadius = backgroundRadius;
        label.textColor = textColor
        label.textAlignment = .center;
        label.font = textFont
        label.text = message
        label.alpha = 1.0
        label.clipsToBounds  =  true

        self.view.addSubview(backgroundView)
        self.view.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                        constant: -yAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: label.topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: label.leadingAnchor,
                                                constant: -20).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: label.trailingAnchor,
                                                 constant: 20).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: label.bottomAnchor).isActive = true

        UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseOut, animations: {
            label.alpha = 0.0
            backgroundView.alpha = 0.0
        }, completion: {(isCompleted) in
            label.removeFromSuperview()
            backgroundView.removeFromSuperview()
        })
    }

}
