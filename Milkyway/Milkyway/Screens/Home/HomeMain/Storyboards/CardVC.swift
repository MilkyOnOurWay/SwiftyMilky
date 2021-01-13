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
    
    // 서버에서 모든 시작이 1이라고 해서 tag 값을 1부터 설정함. 여섯개 넣어줌
//    var beforeState: [Bool] = [false, false, false, false, false, false]
    
    // 망원 연남 한남 신사 역삼
//    let searchLocation = [[0, 0], [37.555941, 126.910067], [37.555941, 126.910067], [37.555941, 126.910067], [37.555941, 126.910067], [37.555941, 126.910067]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setHandler()
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
    
    func resetRadioButton() {
        mangwonBtn.isSelected = false
        younnamBtn.isSelected = false
        hannamBtn.isSelected = false
        shinsaBtn.isSelected = false
        yuksamBtn.isSelected = false
    }
}
