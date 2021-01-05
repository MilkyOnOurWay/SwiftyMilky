//
//  InfoModifyReqVC.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/02.
//

import UIKit

class InfoModifyReqVC: UIViewController {

    // 여기 네비는 테스트용으로 넣은 것!!
    
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var subLabel: UILabel!
    @IBOutlet var modifyBtn: UIButton!
    @IBOutlet var deleteBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
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
    
}
extension InfoModifyReqVC {
    
    func setLabel() {
        mainLabel.textAlignment = .center
        mainLabel.text = "제공 받으신 정보와 다른 점이 있나요?"
        mainLabel.font = UIFont(name:"SFProText-Semibold", size: 20.0)
        
        subLabel.textAlignment = .center
        subLabel.numberOfLines = 3
        subLabel.text = "불편을 드려 죄송합니다.\n정보 수정을 요청해 주시면 불편하셨던 만큼\n꼼꼼히 확인하여 다시 반영하도록 하겠습니다."
        subLabel.font = UIFont(name:"SFProText-Thin", size: 12.0)
    }
    
    func setButton() {
        modifyBtn.layer.cornerRadius = modifyBtn.frame.height / 2
        modifyBtn.setTitle("정보 수정", for: .normal)
        modifyBtn.setTitleColor(.white, for: .normal)
        modifyBtn.backgroundColor = UIColor(named: "Milky")
        
        deleteBtn.layer.cornerRadius = deleteBtn.frame.height / 2
        deleteBtn.setTitle("장소 삭제", for: .normal)
        deleteBtn.setTitleColor(UIColor(named: "Milky"), for: .normal)
        deleteBtn.borderWidth = 1
        deleteBtn.borderColor = UIColor(named: "Milky")
    }
}

