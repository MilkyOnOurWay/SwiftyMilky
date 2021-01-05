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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
        setTextView()
        setButton()
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        print("Modify - submitBtnClicked")
        
        guard let confirmVC = UIStoryboard(name: "Modify", bundle: nil).instantiateViewController(withIdentifier:"ModifyConfirmVC") as? ModifyConfirmVC else {
            return
        }
        confirmVC.modalPresentationStyle = .overCurrentContext
        present(confirmVC, animated: false, completion: nil)
    }
}

extension ModifyVC {
    
    func setLabel() {
        mainLabel.textAlignment = .center
        mainLabel.text = "수정할 정보를 작성해주세요"
        mainLabel.font = UIFont(name:"SFProText-Bold", size: 15.0)
        
        subLabel.textAlignment = .left
        subLabel.text = "*최소 5글자 이상"
        subLabel.font = UIFont(name:"SFProText-Regular", size: 12.0)
        subLabel.textColor = UIColor(named: "darkGrey")
    }
    
    func setTextView() {
        modifyTextView.delegate = self
        
        modifyTextView.text = "ex. 두유 밖에 팔지 않아요.\n콜드브루만 디카페인이래요."
        modifyTextView.font = UIFont(name:"SFProText-Regular", size: 16.0)
        modifyTextView.textColor = .gray

        modifyTextView.backgroundColor = UIColor(displayP3Red: 246/255, green: 245/255, blue: 242/255, alpha: 1)
        modifyTextView.layer.cornerRadius = 10
        modifyTextView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16);
    }

    func setButton() {
        submitBtn.isEnabled = false
        submitBtn.layer.cornerRadius = submitBtn.frame.height / 2
        submitBtn.setTitle("정보 수정 요청", for: .normal)
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.backgroundColor = UIColor(named: "darkGrey")
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
            textView.text = "ex. 두유 밖에 팔지 않아요.\n콜드브루만 디카페인이래요."
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
