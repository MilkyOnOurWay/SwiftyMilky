//
//  SettingVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2020/12/30.
//

import UIKit
import MessageUI

class SettingVC: UIViewController, MFMailComposeViewControllerDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavi()
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            guard let nvc = self.storyboard?.instantiateViewController(identifier: "NicknameChangeVC") as? NicknameChangeVC else { return }
            nvc.modalPresentationStyle = .fullScreen
            self.present(nvc, animated: true, completion: nil)
        case 1:
            let mc = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            
            mc.setToRecipients(["wemakemilkyway@gmail.com"])
            if MFMailComposeViewController.canSendMail() { self.present(mc, animated: true, completion: nil) }
            else { let alertController: UIAlertController = UIAlertController(title:"메일 보내기", message:"현재 디바이스에서 이메일을 \n보낼 수가 없습니다.\n설정에서 이메일 관련 \n설정을 확인해주세요", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "확인", style: .default, handler: { (alert: UIAlertAction!) in })
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
                
            }
        case 3:
            guard let loginVC = self.storyboard?.instantiateViewController(identifier: "LogoutVC") as? LogoutVC else { return }
            loginVC.modalPresentationStyle = .overFullScreen
            loginVC.modalTransitionStyle = .crossDissolve
            self.present(loginVC, animated: true, completion: nil)
        case 4:
            guard let withdrawVC = self.storyboard?.instantiateViewController(identifier: "WithdrawVC") as? WithdrawVC else { return }
            withdrawVC.modalPresentationStyle = .overFullScreen
            withdrawVC.modalTransitionStyle = .crossDissolve
            self.present(withdrawVC, animated: true, completion: nil)
        default:
            print("nothing")
        }
      
    }
    
    
    
}

extension SettingVC {
    
    
    func setNavi(){
        self.navigationController?.navigationBar.topItem?.title = "설정"
        
    }
}



