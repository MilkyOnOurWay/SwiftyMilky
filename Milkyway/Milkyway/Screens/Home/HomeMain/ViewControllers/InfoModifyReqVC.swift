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
    }
    
    @IBAction func deleteBtnClicked(_ sender: Any) {
    }
    
}
