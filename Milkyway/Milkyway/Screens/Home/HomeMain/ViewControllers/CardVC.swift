//
//  CardVC.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/04.
//

import UIKit
import DLRadioButton

class CardVC: UIViewController {

    @IBOutlet var handleArea: UIView!
    @IBOutlet var handleBar: UIView!
    @IBOutlet var mainLabel: UILabel!
    
    @IBOutlet var rootView: UIView!
    
    @IBOutlet var mangwonBtn: DLRadioButton!
    @IBOutlet var younnamBtn: DLRadioButton!
    @IBOutlet var hannamBtn: DLRadioButton!
    @IBOutlet var shinsaBtn: DLRadioButton!
    @IBOutlet var yuksamBtn: DLRadioButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setHandler()
        setRadioButton()
    }
}

extension CardVC {
    
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
        
        mainLabel.textAlignment = .center
        mainLabel.text = "다른 지역을 찾고있나요?"
        mainLabel.font = UIFont(name:"SFProText-Regular", size: 16.0)
    }
    
    func setRadioButton() {
        
        mangwonBtn.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
        younnamBtn.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
        hannamBtn.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
        shinsaBtn.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
        yuksamBtn.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
        
        mangwonBtn.icon = UIImage(named: "mangwon_w")!
        younnamBtn.icon = UIImage(named: "younnam_w")!
        hannamBtn.icon = UIImage(named: "hannam_w")!
        shinsaBtn.icon = UIImage(named: "shinsa_w")!
        yuksamBtn.icon = UIImage(named: "yuksam_w")!

        mangwonBtn.iconSelected = UIImage(named: "mangwon_p")!
        younnamBtn.iconSelected = UIImage(named: "younnam_p")!
        hannamBtn.iconSelected = UIImage(named: "hannam_p")!
        shinsaBtn.iconSelected = UIImage(named: "shinsa_p")!
        yuksamBtn.iconSelected = UIImage(named: "yuksam_p")!
    }
    
    @objc func sendBtnTag(_ sender:DLRadioButton) {

        print("if 전 \(sender.isSelected)")
        if sender.isSelected == true {
            sender.isSelected = false
            print("if 후 \(sender.isSelected)")
        } else {
            sender.isSelected = true
            print("if 후 \(sender.isSelected)")
        }
    }
}
