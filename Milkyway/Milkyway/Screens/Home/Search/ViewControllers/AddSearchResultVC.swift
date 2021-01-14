//
//  AddSearchResultVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/11.
//

import UIKit
import Lottie

class AddSearchResultVC: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var noResultImageView: UIImageView!
    
    var buttonIsSelected: Bool = true
    var cafeResult: String?
    private var searchedCafe: [CafeResult]?
    
    // 전달하는 변수
    var cafeName: String?
    var cafeAddress: String?
    var longitude: String?
    var latitude: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchTableView()
        setTextField()
        setBackButton()
        setDeleteButton()
      
    }
    
    
    // MARK: - 데이터 로딩 중 Lottie 화면
    
    let loadingView = AnimationView(name: "loadingLottie")
    
    private func showLoadingLottie() {
        print("start")
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        loadingView.center = self.view.center
        loadingView.contentMode = .scaleAspectFill
        loadingView.loopMode = .loop
        self.view.addSubview(loadingView)
        
        loadingView.play()
    }
    
    private func stopLottieAnimation() {
        print("end")
        loadingView.stop()
        loadingView.removeFromSuperview()
    }


    

   

}

extension AddSearchResultVC {
    
    func setSearchTableView(){
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.separatorInset.left = 0
        let nibName = UINib(nibName: "AddSearchTVC", bundle: nil)
        searchTableView.register(nibName, forCellReuseIdentifier: "AddSearchTVC")
        noResultImageView.isHidden = true
        searchTableView.separatorStyle = .none
       
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
        showLoadingLottie()
        SearchCafeService.shared.searchReportCafe(cafe){
            responseData in
            switch responseData {
            
            case .success(let res):
                dump(res)
                self.searchedCafe = res as? [CafeResult]
                if (self.searchedCafe?.count == 0) {
                    self.searchTableView.reloadData()
                    self.noResultImageView.isHidden = false
                }
                self.searchTableView.separatorStyle = .singleLine
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
            self.stopLottieAnimation()
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        cafeName = searchedCafe?[indexPath.row].cafeName
        cafeAddress = searchedCafe?[indexPath.row].cafeAddress
        longitude = searchedCafe?[indexPath.row].longitude
        latitude = searchedCafe?[indexPath.row].latitude
        
        // 카페제보뷰로 다시 돌아가기
        NotificationCenter.default.post(name: Notification.Name("addressPlus"), object: [cafeName,cafeAddress,longitude,latitude])
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    
}

extension AddSearchResultVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var str = textField.text
        if str?.count != 0 {
            
            searchTextField.resignFirstResponder()
            search(str ?? "")
        }
        return true
    }
 
}
