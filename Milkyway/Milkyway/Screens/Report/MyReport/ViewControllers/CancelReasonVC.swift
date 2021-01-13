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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setReasonView()
        setLabel()
        setButton()
    }
    
    @IBAction func confirmBtnClicked(_ sender: Any) {
        print("MyReportMain - confirmBtnClicked")
//        let presentingVC = self.presentingViewController
        self.dismiss(animated: false)
    }
}

extension CancelReasonVC {
    func setReasonView() {
        rootView.backgroundColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        reasonView.layer.cornerRadius = 8
    }
    
    func setLabel() {
//        if rejectReasonId == 1 {
//
//        }
        mainLabel.textAlignment = .center
        mainLabel.text = "제보가 취소 되었습니다"
        mainLabel.font = UIFont(name:"SFProText-Bold", size: 20.0)
        
        reasonLabel.textAlignment = .center
        reasonLabel.text = "취소 사유 : 찾을 수 없는 카페 및 불명확한 메뉴"
        reasonLabel.font = UIFont(name:"SFProText-Bold", size: 12.0)
        
        subLabel.textAlignment = .center
        subLabel.numberOfLines = 2
        subLabel.text = "밀키웨이에 대한 관심에 감사드리며\n확인 버튼을 누르시면 제보는 자동 삭제 됩니다."
        subLabel.font = UIFont(name:"SFProText-Regular", size: 12.0)
        subLabel.textColor = UIColor(displayP3Red: 80/255, green: 85/255, blue: 92/255, alpha: 1)
    }
    func setButton() {
        confirmBtn.layer.cornerRadius = confirmBtn.frame.height / 2
        confirmBtn.setTitle("확인", for: .normal)
        confirmBtn.setTitleColor(.white, for: .normal)
        confirmBtn.backgroundColor = UIColor(named: "Milky")
        confirmBtn.titleLabel?.font = UIFont(name:"SFProText-Semibold", size: 15.0)
    }
}
