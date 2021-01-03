//
//  SearchVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/02.
//

import UIKit
import SnapKit
import Then

class SearchVC: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchTableView()
        setBackButton()
    }
    
}

extension SearchVC {
    
    func setSearchTableView(){
        searchTableView.delegate = self
        searchTableView.dataSource = self
        let nibName = UINib(nibName: "SearchTVC", bundle: nil)
        searchTableView.register(nibName, forCellReuseIdentifier: "SearchTVC")
    }
    func setBackButton(){
        backButton.addTarget(self, action:#selector(backBtnClicked), for: .touchUpInside)
    }
    
    @objc func backBtnClicked(){
        
        navigationController?.popViewController(animated: true)
    }
}

extension SearchVC: UITableViewDelegate {

}

extension SearchVC: UITableViewDataSource {
    
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
