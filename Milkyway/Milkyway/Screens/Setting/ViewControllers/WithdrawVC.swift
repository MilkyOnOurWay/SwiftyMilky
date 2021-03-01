//
//  WithdrawVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/03/02.
//

import UIKit

class WithdrawVC: UIViewController {
    @IBOutlet weak var explainLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        explainLabel.text = "더 이상 밀키웨이의 서비스를\n이용하실 수 없습니다.\n정말 탈퇴하시겠습니까?"
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func noBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func yesBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
