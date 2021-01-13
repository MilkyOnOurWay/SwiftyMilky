//
//  UniversePopUpVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/11.
//

import UIKit

class UniversePopUpVC: UIViewController {

    @IBOutlet weak var askRemoveView: UIView!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var deletedOKView: UIImageView!
    @IBOutlet weak var deletedBtn: UIButton!
    
    // 삭제를 누르면 cafeID 전달
    var cafeID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deletedOKView.isHidden = true
        deletedBtn.isEnabled = false
        
        // 이전 화면에서 삭제 눌렸을 때 cafeID 전달하는 노티
        NotificationCenter.default.addObserver(self, selector: #selector(getcafeID(_:)), name: Notification.Name("removeCafeID"),object: nil)

    }
    
    
    // 노티 실행
    @objc func getcafeID(_ noti: NSNotification) {
        cafeID = noti.object as! Int
    }
    
    
    
    // 삭제하시겠습니까 ? no -> 그냥 화면 닫힘
    @IBAction func noBtnClicked(_ sender: Any) {
        print("noBtnClicked()")
        self.dismiss(animated: true, completion: nil)
    }
    
    // 삭제하시겠습니까? yes -> delete 서버통신 시작
    @IBAction func removeBtnClicked(_ sender: Any) {
        print("removeBtnClicked()")
        deletedBtn.isEnabled = true
        deletedOKView.isHidden = false
        noBtn.isEnabled = false
        removeBtn.isEnabled = false
        
        print(cafeID)
        
        UniverseService.shared.deleteUniverse(cafeID) { (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let loadData = data as? ThrowUniverse {
                    print("success")
                    print(loadData)
                    NotificationCenter.default.post(name: Notification.Name("removeCafe"), object: nil)
                    }
            case .requestErr( _):
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
            
        }
      
    }
    
    
    // 확인
    @IBAction func deletedOKBtnClicked(_ sender: Any) {
        print("removeBtnClicked()")
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
