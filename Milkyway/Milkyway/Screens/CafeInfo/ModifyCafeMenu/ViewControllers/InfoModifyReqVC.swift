//
//  InfoModifyReqVC.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/02.
//

import UIKit

class InfoModifyReqVC: UIViewController {

    
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var subLabel: UILabel!
    @IBOutlet var modifyBtn: UIButton!
    @IBOutlet var deleteBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
    }
    
    @IBAction func modifyBtnClicked(_ sender: Any) {
        print("Home - modifyBtnClicked")
        guard let nvc = UIStoryboard(name: "Modify", bundle: nil).instantiateViewController(withIdentifier:"ModifyVC") as? ModifyVC else {
            return
        }
        
        self.navigationController?.pushViewController(nvc, animated: true)
    }
    
    @IBAction func deleteBtnClicked(_ sender: Any) {
        print("Home - deleteBtnClicked")
        
        guard let deleteVC = UIStoryboard(name: "DeletePlace", bundle: nil).instantiateViewController(withIdentifier:"DeletePlaceVC") as? DeletePlaceVC else {
            return
        }
        deleteVC.modalPresentationStyle = .overCurrentContext
        present(deleteVC, animated: false, completion: nil)
        
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension InfoModifyReqVC {
    func setButton() {
        modifyBtn.layer.cornerRadius = modifyBtn.frame.height / 2
        
        deleteBtn.layer.cornerRadius = deleteBtn.frame.height / 2
        deleteBtn.borderWidth = 1
        deleteBtn.borderColor = UIColor(named: "Milky")
    }
}

