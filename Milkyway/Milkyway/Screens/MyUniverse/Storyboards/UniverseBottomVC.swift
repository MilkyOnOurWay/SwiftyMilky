//
//  UniverseBottomVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/10.
//

import UIKit

class UniverseBottomVC: UIViewController {
    
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var handleBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setHandler()

    }

}


extension UniverseBottomVC {
    
    func setView() {
        rootView.layer.cornerRadius = 12
        
        rootView.layer.shadowColor = UIColor.black.cgColor
        rootView.layer.shadowOpacity = 0.1
        rootView.layer.shadowOffset = CGSize(width: 0.0, height: -4.0)
        rootView.layer.shadowRadius = 12
        rootView.layer.masksToBounds = false
    }
    func setHandler() {
        handleBar.layer.cornerRadius = handleBar.frame.height / 2
    
       
    }
}
