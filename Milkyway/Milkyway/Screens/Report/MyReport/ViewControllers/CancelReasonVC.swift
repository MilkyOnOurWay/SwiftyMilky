//
//  CancelReasonVC.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/09.
//

import UIKit

class CancelReasonVC: UIViewController {

    @IBOutlet var rootView: UIView!
    @IBOutlet var reasonView: UIView!
    
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var reasonLabel: UILabel!
    @IBOutlet var subLabel: UILabel!
    @IBOutlet var confirmBtn: UIButton!
    
    var rejectReasonId: Int = 0
    var cafeId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setReasonView()
        setLabel()
        setButton()
    }
    
    @IBAction func confirmBtnClicked(_ sender: Any) {
        print("MyReportMain - confirmBtnClicked")
//        let presentingVC = self.presentingViewController
        
        MyReportService.shared.deleteCancelCafe(self.cafeId) { [self] (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                print("success")
                NotificationCenter.default.post(name: Notification.Name("cancelremove"), object: nil)
            case .requestErr( _):
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")

            }
            
            self.dismiss(animated: true)
        }
    }
}

extension CancelReasonVC {
    func setReasonView() {
        rootView.backgroundColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        reasonView.layer.cornerRadius = 8
    }
    
    func setLabel() {
        print("rejectReasonId \(rejectReasonId)")
        
        if rejectReasonId == 1 {
            reasonLabel.text = "취소 사유 : 찾을 수 없는 카페 및 불명확한 메뉴"
        } else if rejectReasonId == 2 {
            reasonLabel.text = "취소 사유 : 찾을 수 없는 카페 정보"
        } else {
            reasonLabel.text = "취소 사유 : 불명확한 메뉴"
        }
    }
    func setButton() {
        confirmBtn.layer.cornerRadius = confirmBtn.frame.height / 2
//        confirmBtn.setTitle("확인", for: .normal)
//        confirmBtn.setTitleColor(.white, for: .normal)
//        confirmBtn.backgroundColor = UIColor(named: "Milky")
//        confirmBtn.titleLabel?.font = UIFont(name:"SFProText-Semibold", size: 15.0)
    }
}
