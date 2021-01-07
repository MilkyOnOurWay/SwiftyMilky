//
//  MenuPlusVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/06.
//

import UIKit
import DLRadioButton

class MenuPlusVC: UIViewController {

    @IBOutlet weak var menuTF: FormTextField!
    @IBOutlet weak var priceTF: FormTextField!
    
    @IBOutlet weak var categoryFirstBtn: DLRadioButton!
    @IBOutlet weak var editEndBtn: UIButton!
    
    var editCafeMenu = CafeMenu(menu: "", selection: [], price: "")
    var areyouEdit = false
    var category = [Int]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryFirstBtn.isMultipleSelectionEnabled = true
        readyToEdit()
        
    }
}

extension MenuPlusVC  {
    
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func categoryBtnClicked(_ sender: Any) {
        // 버튼을 눌러도 키보드가 내려간다네...
        self.menuTF.resignFirstResponder()
        self.priceTF.resignFirstResponder()
        if menuTF.text != nil && priceTF.text != nil && category.count != 0 {
            
        }
        
    }
    
    @IBAction func menuPlusOkClicked(_ sender: Any) {
        
        // 수정이라면 이전꺼 지워줘야함.
        if areyouEdit {
            NotificationCenter.default.post(name: Notification.Name("remove"), object: nil)
        }
        
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
    
    
    
    
    func readyToEdit() {
        menuTF.text = editCafeMenu.menu
        priceTF.text = editCafeMenu.price
        editCafeMenu.selection.forEach { i in
            print(i)
            if i == 1 {
                categoryFirstBtn.isSelected = true
                print(categoryFirstBtn.isSelected)
            }
            else {
                print(categoryFirstBtn.otherButtons[i-2])
                categoryFirstBtn.otherButtons[i-2].isSelected = true
            }
        }
    }
    
    
    
    // 텍스트필드 아닌 곳을 터치하면 키보드가 내려간다네 ...
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.menuTF.resignFirstResponder()
        self.priceTF.resignFirstResponder()
    }
}



