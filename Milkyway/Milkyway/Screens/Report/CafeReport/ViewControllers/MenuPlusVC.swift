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
    @IBOutlet weak var editImageView: UIImageView!
    
    var editCafeMenu: Menu?
    var areyouEdit = false
    var category = [Int]()
    
    var menuCount = 0
    var priceCount = 0
    
    
    override func viewDidLoad() {
        print(self.view.bounds.height)
        
        
        super.viewDidLoad()
        
        menuTF.delegate = self
        priceTF.delegate = self
        
        categoryFirstBtn.isMultipleSelectionEnabled = true
        readyToEdit()
        nextBtnAdd(priceTF)
        
        
        // 처음에는 입력 완료를 누를 수 없다.
        editEndBtn.isUserInteractionEnabled = false
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: priceTF)
        
    }
    
    /// 금액 , 찍어주기
    @objc private func textDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let pricetoDouble = Double(priceTF.text?.components(separatedBy: [","]).joined() ?? "")
            let price = numberFormatter.string(from: NSNumber(value: pricetoDouble ?? 0)) ?? ""
            textField.text = price == "0" ? "" : price
        }
    }
}

extension MenuPlusVC  {
    
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func menuPlusOkClicked(_ sender: Any) {
        
        // 수정이라면 이전꺼 지워줘야함.
        if areyouEdit {
            NotificationCenter.default.post(name: Notification.Name("remove"), object: nil)
        }
        
        
        print(category)
        print("\(menuTF.text!) 메뉴 추가합니다")
        
        let price = priceTF.text?.components(separatedBy: [","]).joined()
        
        let menu = Menu(menuName: menuTF.text ?? "", price: price ?? "", category: category )
        
        NotificationCenter.default.post(name: Notification.Name("menuPlus"), object: menu)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func categoryBtnClicked(_ sender: Any) {
        // 버튼을 눌러도 키보드가 내려간다네...
        self.menuTF.resignFirstResponder()
        self.priceTF.resignFirstResponder()
        countCategory()
        checkEditOK()
       
    }
    
    
    // 텍스트필드 아닌 곳을 터치하면 키보드가 내려간다네 ...
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.menuTF.resignFirstResponder()
        self.priceTF.resignFirstResponder()
    }
    
    // priceTF 오른쪽 상단에 done 버튼 넣기
    func nextBtnAdd(_ sender: UITextField) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width:   UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        self.priceTF.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.menuTF {
            self.priceTF.becomeFirstResponder()
        }
        
        return true
    }
    
    
}


extension MenuPlusVC {
    
    func checkEditOK() {
        
        if menuCount > 0 && priceCount > 0 && category.count > 0 {
            editImageView.image = UIImage(named: "btnInput")
            editEndBtn.isUserInteractionEnabled = true
        }
        else {
            editImageView.image = UIImage(named: "btnInputOff")
            editEndBtn.isUserInteractionEnabled = false
        }
        
    }
    
    // category 확인용
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
    }
    
    
    // 수정하기 전에 필요한 작업
    func readyToEdit() {
        menuTF.text = editCafeMenu?.menuName
        priceTF.text = editCafeMenu?.price
        editCafeMenu?.category.forEach { i in
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
