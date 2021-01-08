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
    
    var menuCount = 0
    var priceCount = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTF.delegate = self
        priceTF.delegate = self
        
        categoryFirstBtn.isMultipleSelectionEnabled = true
        readyToEdit()
        
        // 처음에는 입력 완료를 누를 수 없다.
        editEndBtn.isUserInteractionEnabled = false
        
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
        countCategory()
        checkEditOK()
        
    }
    
    @IBAction func menuPlusOkClicked(_ sender: Any) {
        
        // 수정이라면 이전꺼 지워줘야함.
        if areyouEdit {
            NotificationCenter.default.post(name: Notification.Name("remove"), object: nil)
        }
        
      
        print(category)
        print("\(menuTF.text!) 메뉴 추가합니다")
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let changeToDouble = Double(priceTF.text ?? "0") ?? 0
        let price = numberFormatter.string(from: NSNumber(value: changeToDouble))!

        let menu = CafeMenu(menu: menuTF.text ?? "", selection: category, price: price )
        
        NotificationCenter.default.post(name: Notification.Name("menuPlus"), object: menu)
        self.navigationController?.popViewController(animated: true)
    }
    

    
    // 텍스트필드 아닌 곳을 터치하면 키보드가 내려간다네 ...
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.menuTF.resignFirstResponder()
        self.priceTF.resignFirstResponder()
    }
    
    
}



extension MenuPlusVC: UITextFieldDelegate {
    func  textFieldDidEndEditing(_ textField: UITextField) {
        print(menuTF.text!.count)
        print(priceTF.text!.count)
        menuCount = menuTF.text!.count
        priceCount = priceTF.text!.count
        countCategory()
        checkEditOK()
    
    }
        
       
    
}


extension MenuPlusVC {
    
    func checkEditOK() {
        
        if menuCount > 0 && priceCount > 0 && category.count > 0 {
            editEndBtn.setImage(UIImage(named: "btnInput"), for: .normal)
            editEndBtn.isUserInteractionEnabled = true
        }
        else {
            editEndBtn.setImage(UIImage(named: "btnInputOff"), for: .normal)
            editEndBtn.isUserInteractionEnabled = false
        }
        
        
    }
    
    func countCategory() {
        category = []
        if categoryFirstBtn.isSelected {
            category.append(1)
        }
        categoryFirstBtn.otherButtons.forEach{ i in
            if i.isSelected {
                category.append(i.tag)
            }
        }
        print(category)
    }
    
    
    // 수정하기 전에 필요한 작업
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
}
