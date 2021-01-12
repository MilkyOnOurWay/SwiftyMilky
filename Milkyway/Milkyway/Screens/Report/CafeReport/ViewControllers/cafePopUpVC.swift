//
//  cafePopUpVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/09.
//

import UIKit

class cafePopUpVC: UIViewController {
    @IBOutlet weak var nickNameLabel: UILabel!
    
    var nickName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nickNameLabel.text = nickName
       
    }
    
    @IBAction func okBtnClicked(_ sender: Any) {
        
        // 탭바 움직이게
        NotificationCenter.default.post(name: Notification.Name("tabBarMove"), object: nil)
        
        // 카페제보 내용 초기화
        NotificationCenter.default.post(name: Notification.Name("cafeReset"), object: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    

}
