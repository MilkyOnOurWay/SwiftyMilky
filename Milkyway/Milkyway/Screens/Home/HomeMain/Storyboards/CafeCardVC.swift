//
//  CafeCardVC.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/11.
//

import UIKit

class CafeCardVC: UIViewController {

    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeAddressLabel: UILabel!
    @IBOutlet weak var cafeTimeLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


   
}

extension CafeCardVC {
    
    func setAddButton(){
        
        addButton.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
    }
    
    @objc func addButtonDidTap(){
        
        // 서버통신진행
        
        
    }
    
}
