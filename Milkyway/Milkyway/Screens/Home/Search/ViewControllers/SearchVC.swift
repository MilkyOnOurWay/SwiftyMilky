//
//  SearchVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/02.
//

import UIKit

class SearchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func backBtnClicked(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
}
