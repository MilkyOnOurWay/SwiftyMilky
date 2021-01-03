//
//  ModifyVC.swift
//  Milkyway
//
//  Created by ✨EUGENE✨ on 2021/01/02.
//

import UIKit

class ModifyVC: UIViewController {

    
    @IBOutlet var modifyTextView: UITextView!
    @IBOutlet var submitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextView()
        setButton()
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        print("Home - submitBtnClicked")
        
        guard let confirmVC = UIStoryboard(name: "Modify", bundle: nil).instantiateViewController(withIdentifier:"ModifyConfirmVC") as? ModifyConfirmVC else {
            return
        }
        confirmVC.modalPresentationStyle = .overCurrentContext
        present(confirmVC, animated: false, completion: nil)
    }
    
    func setTextView() {
        modifyTextView.delegate = self
        modifyTextView.text = "ex. 두유 밖에 팔지 않아요.\n콜드브루만 디카페인이래요."
        modifyTextView.textColor = UIColor.lightGray

        modifyTextView.backgroundColor = UIColor(displayP3Red: 246/255, green: 245/255, blue: 242/255, alpha: 1)
        modifyTextView.layer.cornerRadius = 10
        modifyTextView.textContainerInset = UIEdgeInsets(top: 16, left: 14, bottom: 16, right: 14);
    }

    func setButton() {
        submitBtn.isEnabled = false
        submitBtn.layer.cornerRadius = submitBtn.frame.height / 2
        submitBtn.setTitle("정보 수정 요청", for: .normal)
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.backgroundColor = .darkGray
    }


}

extension ModifyVC: UITextViewDelegate {
    // TextView Place Holder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "ex. 두유 밖에 팔지 않아요.\n콜드브루만 디카페인이래요."
            textView.textColor = UIColor.lightGray
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count >= 5 {
            submitBtn.isEnabled = true
            submitBtn.backgroundColor = UIColor(named: "Milky")
        } else {
            submitBtn.isEnabled = false
            submitBtn.backgroundColor = .darkGray
        }
    }

}
