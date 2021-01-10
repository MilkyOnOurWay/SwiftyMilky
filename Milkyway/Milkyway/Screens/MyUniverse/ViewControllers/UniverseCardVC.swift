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
    override func viewDidLoad() {
        super.viewDidLoad()
        setDeleteButton()
        setView()
        // Do any additional setup after loading the view.
    }


   
}

extension UniverseCardVC {
    
    func setView(){
        
        //rootView.layer.cornerRadius = 12
        
    }
    func setDeleteButton(){
        
        DeleteButton.addTarget(self, action: #selector(deleteButtonDidTap), for: .touchUpInside)
    }
    
    @objc func deleteButtonDidTap(){
        
        // 서버통신진행
        
        
    }
    
}
