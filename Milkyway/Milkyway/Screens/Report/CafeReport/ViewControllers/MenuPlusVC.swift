//
//  MenuPlusVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/06.
//

import UIKit

class MenuPlusVC: UIViewController {
    @IBOutlet weak var menuTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func menuPlusOkClicked(_ sender: Any) {
        print("\(menuTF.text!) 메뉴 추가합니다")
        
        let menu = CafeMenu(menu: menuTF.text ?? "", selection: [2,3], price: priceTF.text ?? "")
        
        NotificationCenter.default.post(name: Notification.Name("menuPlus"), object: menu)
        self.navigationController?.popViewController(animated: true)
    }
}


