//
//  SearchResultVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/07.
//

import UIKit

class SearchResultVC: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var noResultImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchTableView()
        setTextField()
        setBackButton()
    }
}


extension SearchResultVC {
    
    func setSearchTableView(){
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        let nibName = UINib(nibName: "SearchTVC", bundle: nil)
        searchTableView.register(nibName, forCellReuseIdentifier: "SearchTVC")
        noResultImageView.isHidden = true
        
    }
    
    func setTextField(){
        searchTextField.delegate = self
        
    }
    func setBackButton(){
        backButton.addTarget(self, action: #selector(backBtnClicked), for: .touchUpInside)
        
    }
    func setDeleteButton(){
        
       
    }
    
    @objc func backBtnClicked(){
        
        navigationController?.popViewController(animated: true)
    }
    // MARK: - 입력한 값 삭제버튼
    @objc func deleteBtnClicked(){
        
    }
}

extension SearchResultVC: UITableViewDelegate {
    
}

extension SearchResultVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "SearchTVC",for: indexPath) as! SearchTVC
        cell.cafeNameLabel.text = "카페이름"
        cell.cafeAddressLabel.text = "카페주소"
        cell.cafeNameLabel.sizeToFit()
        cell.cafeAddressLabel.sizeToFit()
        return cell
    }
    
    
    
}

extension SearchResultVC: UITextFieldDelegate {
    
    
}

