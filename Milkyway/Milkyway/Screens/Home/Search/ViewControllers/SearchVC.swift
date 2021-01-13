//
//  SearchVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/02.
//

import UIKit
import Then


class SearchVC: UIViewController {

    @IBOutlet weak var noResultImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextField()
        setBackButton()
        setSearchButton()
    }
    
    
    
}

extension SearchVC {
    
  
    func setTextField(){
        searchTextField.delegate = self
       
    }
    func setBackButton(){
        backButton.addTarget(self, action:#selector(backBtnClicked), for: .touchUpInside)
    }
    
    func setSearchButton(){
        searchButton.addTarget(self, action: #selector(searchBtnClicked), for: .touchUpInside)
        
    }
    
    @objc func backBtnClicked(){
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func searchBtnClicked(){

    }
}


extension SearchVC: UITextFieldDelegate {
    
    
    
}
