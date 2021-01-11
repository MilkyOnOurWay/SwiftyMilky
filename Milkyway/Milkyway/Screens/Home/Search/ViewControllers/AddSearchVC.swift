//
//  AddSearchVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/11.
//

import UIKit

class AddSearchVC: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextField()
        setBackButton()
        setSearchButton()
        // Do any additional setup after loading the view.
    }
    
}

extension AddSearchVC {
    
    func setTextField(){
        
        searchTextField.delegate = self
    }
    
    func setBackButton(){
        
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
    }
    
    func setSearchButton(){
        
        searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        
    }
    
    @objc func backButtonClicked(){
        
        navigationController?.popViewController(animated: true)
        
    }
    @objc func searchButtonClicked(){
        
        guard let nvc = UIStoryboard(name: "AddSearch", bundle: nil).instantiateViewController(identifier: "AddSearchResultVC") as? AddSearchResultVC else {
            return
        }
        let text = searchTextField.text ?? ""
        nvc.cafeResult = text
        self.navigationController?.pushViewController(nvc, animated: true)
        
    }
//    func searchCafe(_ cafe: String){
//
//        SearchCafeService.shared.searchReportCafe(cafe) {
//
//            responseData in
//            switch responseData {
//
//            case.success(let res):
//                dump(res)
//                let cafeList = res as! [CafeResult]
//
//            }
//        }
//
//    }
    
}

extension AddSearchVC: UITextFieldDelegate {
    
    
}
