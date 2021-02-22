//
//  ModifyVC.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/02.
//

import UIKit

class ModifyVC: UIViewController {

    
    @IBOutlet var mainLabel: UILabel! //수정할 정보를 ~
    @IBOutlet var subLabel: UILabel! // 최소 5글자
    
    @IBOutlet var modifyTextView: UITextView!
    @IBOutlet var submitBtn: UIButton!
    
//    var dummyData = EditPost(id: 1, reason: String)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextView()
        setButton()
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        print("Modify - submitBtnClicked")
        
        ModifyCafeService.shared.EditCafe(cafeId: 17, editPost: EditPost(reason: modifyTextView.text)) { responseData in
            switch responseData {
            case .success(let res):
                print("success")
                print(res)
            case .requestErr(_):
                print("request error")
            case .pathErr:
                print(".pathErr")
            case .serverErr:
                print(".serverErr")
            case .networkFail:
                print("failure")
            }
        }
        
        guard let confirmVC = UIStoryboard(name: "Modify", bundle: nil).instantiateViewController(withIdentifier:"ModifyConfirmVC") as? ModifyConfirmVC else {
            return
        }
        confirmVC.modalPresentationStyle = .overCurrentContext
        present(confirmVC, animated: false, completion: nil)
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ModifyVC {
    
    func setTextView() {
        modifyTextView.delegate = self
        
        modifyTextView.text = "ex. 두유 옵션만 가능해요!\n콜드브루만 디카페인이래요."
        modifyTextView.textColor = .gray
        modifyTextView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16);
    }

    func setButton() {
        submitBtn.isEnabled = false
        submitBtn.layer.cornerRadius = submitBtn.frame.height / 2
    }
}

extension ModifyVC: UITextViewDelegate {
    // TextView Place Holder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "ex. 두유 옵션만 가능해요!\n콜드브루만 디카페인이래요."
            textView.textColor = UIColor.gray
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count >= 5 {
            submitBtn.isEnabled = true
            submitBtn.backgroundColor = UIColor(named: "Milky")
        } else {
            submitBtn.isEnabled = false
            submitBtn.backgroundColor = UIColor(named: "darkGrey")
        }
    }

}
