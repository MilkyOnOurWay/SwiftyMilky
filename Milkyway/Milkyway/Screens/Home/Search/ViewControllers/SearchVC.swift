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
        //searchTableView.isHidden = false
        guard let nvc = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(identifier: "SearchResultVC") as? SearchResultVC else {
            return
        }
        self.navigationController?.pushViewController(nvc, animated: true)
    }
}


extension SearchVC: UITextFieldDelegate {
    
    
    
}
