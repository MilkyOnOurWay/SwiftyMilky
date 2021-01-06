//
//  MenuPlusVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/06.
//

import UIKit
import DLRadioButton

class MenuPlusVC: UIViewController {
    @IBOutlet weak var menuTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var categoryFirstBtn: DLRadioButton!
    @IBOutlet weak var editEndBtn: UIButton!
    
    
    var category = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryFirstBtn.isMultipleSelectionEnabled = true
        
    }
    
    
}


extension MenuPlusVC  {
    
    
    @IBAction func categoryBtnClicked(_ sender: Any) {
        // 버튼을 눌러도 키보드가 내려간다네...
        self.menuTF.resignFirstResponder()
        self.priceTF.resignFirstResponder()
        if menuTF.text != nil && priceTF.text != nil && category.count != 0 {
            
        }
        
    }
    
    @IBAction func menuPlusOkClicked(_ sender: Any) {
        if categoryFirstBtn.isSelected {
            category.append(1)
        }
        categoryFirstBtn.otherButtons.forEach{ i in
            if i.isSelected {
                category.append(i.tag)
            }
        }
        print(category)
        print("\(menuTF.text!) 메뉴 추가합니다")
        
        let menu = CafeMenu(menu: menuTF.text ?? "", selection: category, price: priceTF.text ?? "")
        
        NotificationCenter.default.post(name: Notification.Name("menuPlus"), object: menu)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    // 텍스트필드 아닌 곳을 터치하면 키보드가 내려간다네 ...
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.menuTF.resignFirstResponder()
        self.priceTF.resignFirstResponder()
    }
}



