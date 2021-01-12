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
    
    var cafeID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deletedOKView.isHidden = true
        deletedBtn.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(getcafeID(_:)), name: Notification.Name("removeCafeID"),object: nil)

    }
    
    @IBAction func noBtnClicked(_ sender: Any) {
        print("noBtnClicked()")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeBtnClicked(_ sender: Any) {
        print("removeBtnClicked()")
        deletedBtn.isEnabled = true
        deletedOKView.isHidden = false
        noBtn.isEnabled = false
        removeBtn.isEnabled = false
        
        UniverseService.shared.deleteUniverse(cafeID ?? 0) { [self] (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let loadData = data as? DeleteUniverse {
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
    
    @IBAction func deletedOKBtnClicked(_ sender: Any) {
        print("removeBtnClicked()")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func getcafeID(_ noti: NSNotification) {
        cafeID = noti.object as! Int
    }
    
}
