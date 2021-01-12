//
//  CafeCardVC.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/11.
//

import UIKit

class CafeCardVC: UIViewController {

    @IBOutlet var rootView: UIView!
    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeAddressLabel: UILabel!
    @IBOutlet weak var cafeTimeLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet var addCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }


   
}

extension CafeCardVC {
    func setView(){
        rootView.layer.cornerRadius = 12
        rootView.layer.shadowColor = UIColor.black.cgColor
        rootView.layer.shadowOpacity = 0.1
        rootView.layer.shadowOffset = CGSize(width: 0.0, height: -4.0)
        rootView.layer.shadowRadius = 12
        rootView.layer.masksToBounds = false
        
    }
    func setAddButton(){
        addButton.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
    }
    
    @objc func addButtonDidTap(){
        
        // 서버통신진행
        
        
    }
    
}
