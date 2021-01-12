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
        searchCafe(cafeResult ?? "")
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
    
    func searchCafe(_ cafe: String){
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

extension AddSearchResultVC: UITableViewDelegate {
    
    
}

extension AddSearchResultVC: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedCafe?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "AddSearchTVC",for: indexPath) as! AddSearchTVC
//        cell.cafeNameLabel.text = "카페이름"
//        cell.cafeAddressLabel.text = "카페주소"
        cell.searchedCafe = searchedCafe?[indexPath.row]
        cell.cafeNameLabel.sizeToFit()
        cell.cafeAddressLabel.sizeToFit()
        cell.cafeStateImageView.isHidden = true
        cell.setCell()
        cafeName = cell.searchedCafe?.cafeName
        cafeAddress = cell.searchedCafe?.cafeAddress
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 셀 눌렀을 때 처음으로 이동
        
        guard let nvc = UIStoryboard(name: "ReportTabBar", bundle: nil).instantiateViewController(identifier: "ReportTabBarViewController") as? ReportTabBarViewController else { return }
        self.navigationController?.pushViewController(nvc, animated: true)
        
        guard let vc = UIStoryboard(name: "CafeReportMain",bundle: nil).instantiateViewController(identifier: "CafeReportMainVC") as? CafeReportMainVC else {return}
   
        vc.resultCafeName = cafeName
        vc.resultCafeAddress = cafeAddress
       
    }
    
    
}

extension AddSearchResultVC: UITextFieldDelegate {
    
 
}
