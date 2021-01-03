//
//  InfoModifyReqVC.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/02.
//

import UIKit

class InfoModifyReqVC: UIViewController {

    
    @IBOutlet var modifyBtn: UIButton!
    @IBOutlet var deleteBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
        
    }
    
    func setButton() {
        modifyBtn.layer.cornerRadius = 20
        modifyBtn.setTitle("정보 수정", for: .normal)
        modifyBtn.setTitleColor(.white, for: .normal)
        modifyBtn.backgroundColor = UIColor(named: "Milky")
        
        deleteBtn.layer.cornerRadius = 20
        deleteBtn.setTitle("장소 삭제", for: .normal)
        deleteBtn.setTitleColor(.white, for: .normal)
        deleteBtn.backgroundColor = UIColor(named: "Milky")
    }
    @IBAction func modifyBtnClicked(_ sender: Any) {
        print("Home - modifyBtnClicked")
        guard let nvc = UIStoryboard(name: "Modify", bundle: nil).instantiateViewController(withIdentifier:"ModifyVC") as? ModifyVC else {
            return
        }
        
        self.navigationController?.pushViewController(nvc, animated: true) // 다음 뷰 띄우기
    }
    
    @IBAction func deleteBtnClicked(_ sender: Any) {
    }
    
}
