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
    func setView() {
        rootView.layer.cornerRadius = 12
    }
    func setAddButton(){
        addButton.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
    }
    
    @objc func addButtonDidTap(){
        
        // 서버통신진행
        
        
    }
    
}