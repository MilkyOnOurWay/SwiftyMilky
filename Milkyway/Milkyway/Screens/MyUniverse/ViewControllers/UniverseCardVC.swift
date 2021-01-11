//
//  UniverseCardVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/09.
//

import UIKit

class UniverseCardVC: UIViewController {
    
    
    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeAddressLabel: UILabel!
    @IBOutlet weak var cafeTimeLabel: UILabel!
    @IBOutlet weak var DeleteButton: UIButton!
    @IBOutlet var rootView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDeleteButton()
        setView()
        // Do any additional setup after loading the view.
    }
    
    
    
}

extension UniverseCardVC {
    
    func setView(){
        
        rootView.layer.cornerRadius = 12
        rootView.layer.shadowColor = UIColor.black.cgColor
        rootView.layer.shadowOpacity = 0.1
        rootView.layer.shadowOffset = CGSize(width: 0.0, height: -4.0)
        rootView.layer.shadowRadius = 12
        rootView.layer.masksToBounds = false
        
    }
    func setDeleteButton(){
        
        DeleteButton.addTarget(self, action: #selector(deleteButtonDidTap), for: .touchUpInside)
    }
    
    @objc func deleteButtonDidTap(){
        
        // 서버통신진행
        
        
    }
    
}
