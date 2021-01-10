//
//  AddSearchResultVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/11.
//

import UIKit

class AddSearchResultVC: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
    
    var cafeResult: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchTableView()
        setTextField()
        setBackButton()
        setDeleteButton()
        // Do any additional setup after loading the view.
    }
    

   

}

extension AddSearchResultVC {
    
    func setSearchTableView(){
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        let nibName = UINib(nibName: "AddSearchTVC", bundle: nil)
        searchTableView.register(nibName, forCellReuseIdentifier: "AddSearchTVC")
       
    }
    
    func setTextField(){
        
        searchTextField.text = cafeResult ?? ""
        searchTextField.delegate = self
    }
    
    func setBackButton(){
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
    }
    
    // 텍스트필드 삭제하기 버튼 누르면 텍스트 삭제해버리기
    func setDeleteButton(){
        
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
    }
    
    @objc func backButtonClicked(){
        
        navigationController?.popViewController(animated: true)
    }
    
    // 텍스트필드 삭제하기 버튼 누르면 텍스트 삭제해버리기
    @objc func deleteButtonClicked(){
        
    
    }
}

extension AddSearchResultVC: UITableViewDelegate {
    
    
}

extension AddSearchResultVC: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "AddSearchTVC",for: indexPath) as! AddSearchTVC
        cell.cafeNameLabel.text = "카페이름"
        cell.cafeAddressLabel.text = "카페주소"
        cell.cafeNameLabel.sizeToFit()
        cell.cafeAddressLabel.sizeToFit()
        cell.cafeStateImageView.isHidden = false
        return cell
    }
    
    
    
}

extension AddSearchResultVC: UITextFieldDelegate {
    
 
}
