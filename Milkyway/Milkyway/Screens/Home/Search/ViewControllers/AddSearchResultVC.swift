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
    
    var buttonIsSelected: Bool = true
    var cafeResult: String?
    private var searchedCafe: [CafeResult]?
    
    // 전달하는 변수
    var cafeName: String?
    var cafeAddress: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchTableView()
        setTextField()
        setBackButton()
        setDeleteButton()
      
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
        
        //searchTextField.text = cafeResult ?? ""
        searchTextField.delegate = self
    }
    
    func setBackButton(){
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
    }
    
    // 텍스트필드 삭제하기 버튼 누르면 텍스트 삭제해버리기
    func setDeleteButton(){
        
        deleteButton.setImage(UIImage(named: "icSearch"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
    }
    
    @objc func backButtonClicked(){
        
        navigationController?.popViewController(animated: true)
    }
    
    // 처음에는 검색, 이후 아이콘 변경 후 텍스트필드 삭제하기 버튼 누르면 텍스트 삭제해버리기
    @objc func deleteButtonClicked(){
        
        cafeResult = searchTextField.text
        buttonIsSelected ? search(cafeResult ?? "") : delete()
        print(buttonIsSelected)
    
    }
    
    func search(_ cafe: String){
        
        searchCafe(cafe)
        deleteButton.setImage(UIImage(named: "btnClear"), for: .normal)
        buttonIsSelected = false
    }
    
    func delete(){
        
        deleteButton.setImage(UIImage(named: "icSearch"), for: .normal)
        buttonIsSelected = true
        searchTextField.text = ""
    }
    
    @objc func searchCafe(_ cafe: String){
        SearchCafeService.shared.searchReportCafe(cafe){
            responseData in
            switch responseData {
            
            case .success(let res):
                dump(res)
                self.searchedCafe = res as? [CafeResult]
                DispatchQueue.main.async {
                    self.searchTableView.reloadData()
                }
                self.searchTableView.reloadData()
             
            case .requestErr(_):
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
}

// MARK: - TableView Delegate
extension AddSearchResultVC: UITableViewDelegate {
    
    
}

extension AddSearchResultVC: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedCafe?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "AddSearchTVC",for: indexPath) as! AddSearchTVC

        cell.searchedCafe = searchedCafe?[indexPath.row]
        cell.cafeNameLabel.sizeToFit()
        cell.cafeAddressLabel.sizeToFit()
        cell.cafeStateImageView.isHidden = true // 이미 등록된 카페 처리
        cell.setCell()
        cafeName = cell.searchedCafe?.cafeName
        cafeAddress = cell.searchedCafe?.cafeAddress
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        cafeName = searchedCafe?[indexPath.row].cafeName
        cafeAddress = searchedCafe?[indexPath.row].cafeAddress
        // 카페제보뷰로 다시 돌아가기
        NotificationCenter.default.post(name: Notification.Name("addressPlus"), object: [cafeName,cafeAddress])
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    
}

extension AddSearchResultVC: UITextFieldDelegate {
    
 
}
