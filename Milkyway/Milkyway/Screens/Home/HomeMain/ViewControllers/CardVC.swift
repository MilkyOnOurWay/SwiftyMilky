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
        setHandler()
        setRadioButton()
    }
}

extension CardVC {
    func setHandler() {
        handleBar.layer.cornerRadius = handleBar.frame.height / 2
        
        mainLabel.textAlignment = .center
        mainLabel.text = "다른 지역을 찾고있나요?"
        mainLabel.font = UIFont(name:"SFProText-Regular", size: 16.0)
        
        rootView.layer.cornerRadius = 12
        
        rootView.layer.shadowColor = UIColor.black.cgColor
        rootView.layer.shadowOpacity = 0.1
        rootView.layer.shadowOffset = CGSize(width: 0.0, height: -4.0)
        rootView.layer.shadowRadius = 12
        rootView.layer.masksToBounds = false
    }
    
    func setRadioButton() {
        mangwonBtn.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
        younnamBtn.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
        hannamBtn.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
        shinsaBtn.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
        yuksamBtn.addTarget(self, action: #selector(sendBtnTag(_:)), for: .touchUpInside)
        
        mangwonBtn.icon = UIImage(named: "mangwon_w") ?? mangwonBtn.icon
        younnamBtn.icon = UIImage(named: "younnam_w") ?? younnamBtn.icon
        hannamBtn.icon = UIImage(named: "hannam_w") ?? hannamBtn.icon
        shinsaBtn.icon = UIImage(named: "shinsa_w") ?? shinsaBtn.icon
        yuksamBtn.icon = UIImage(named: "yuksam_w") ?? yuksamBtn.icon

        mangwonBtn.iconSelected = UIImage(named: "mangwon_p") ?? mangwonBtn.iconSelected
        younnamBtn.iconSelected = UIImage(named: "younnam_p") ?? younnamBtn.iconSelected
        hannamBtn.iconSelected = UIImage(named: "hannam_p") ?? hannamBtn.iconSelected
        shinsaBtn.iconSelected = UIImage(named: "shinsa_p") ?? shinsaBtn.iconSelected
        yuksamBtn.iconSelected = UIImage(named: "yuksam_p") ?? yuksamBtn.iconSelected
    }
    
    @objc func sendBtnTag(_ sender:DLRadioButton) {
        print(sender.tag)
    }
}
