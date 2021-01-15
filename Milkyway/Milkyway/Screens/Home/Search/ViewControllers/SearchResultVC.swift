//
//  SearchResultVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/07.
//

import UIKit
import Lottie
class SearchResultVC: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var noResultImageView: UIImageView!

    var latitude: Double?
    var longitude: Double?
    var buttonIsSelected: Bool = true
    var cafeResult: String?
    private var searchedCafe: [CafeHomeResult]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchTableView()
        setTextField()
        setBackButton()
        setDeleteButton()

        //searchCafe(cafeResult ?? "")
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
        searchTableView.separatorStyle = .none

    }

    private func stopLottieAnimation() {
        print("end")
        loadingView.stop()
        loadingView.removeFromSuperview()
    }
}


extension SearchResultVC {

    func setSearchTableView(){
        searchTableView.delegate = self
        searchTableView.dataSource = self
        noResultImageView.isHidden = true

        searchTableView.separatorInset.left = 0


        // 테이블뷰 라인 없애기
        searchTableView.separatorStyle = .none

        let nibName = UINib(nibName: "SearchTVC", bundle: nil)
        searchTableView.register(nibName, forCellReuseIdentifier: "SearchTVC")

        guard let nvc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier:"HomeVC") as? HomeVC else {
            return
        }

        print("마커모음\(nvc.markers)")
        //noResultImageView.isHidden = false



    }

    func setTextField(){
        searchTextField.delegate = self

    }
    func setBackButton(){
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)

    }
    func setDeleteButton(){ // 처음에는 검색, 다시한번 누르면 텍스트 지우기
        deleteButton.setImage(UIImage(named: "icSearch"), for: .normal)
        deleteButton.addTarget(self,action: #selector(deleteButtonClicked), for: .touchUpInside)

    }

    @objc func backButtonClicked(){

        navigationController?.popViewController(animated: true)
    }
    // MARK: - 입력한 값 삭제버튼
    @objc func deleteButtonClicked(){
        cafeResult = searchTextField.text
        buttonIsSelected ? search(cafeResult ?? "") : delete()
        print(buttonIsSelected)
    }

    func search(_ cafe: String){

        searchTableView.separatorStyle = .none
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
        self.noResultImageView.isHidden = true
       
        SearchCafeService.shared.homeSearchCafe(cafe) { [self]

            responseData in
            switch responseData {

            case .success(let res):
                dump(res)

                self.searchedCafe = res as? [CafeHomeResult]
                print("현황\(self.searchedCafe)")
                print("몇개일까\(self.searchedCafe?.count)")
                if (self.searchedCafe?.count == 0)  {
                    self.searchTableView.reloadData()
                    self.noResultImageView.isHidden = false
                    print("이게 맞나?")
                }
                // 테이블뷰 라인 살리기
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
            stopLottieAnimation()
        }

    }
}

extension SearchResultVC: UITableViewDelegate {

}

extension SearchResultVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedCafe?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "SearchTVC",for: indexPath) as! SearchTVC
        cell.selectionStyle = .none
        cell.searchedCafe = searchedCafe?[indexPath.row]
        cell.cafeNameLabel.sizeToFit()
        cell.cafeAddressLabel.sizeToFit()
        cell.setCell()

        latitude = cell.latitude
        longitude = cell.longitude
        // MARK: - 값 없으면 데이터 없음 이미지 띄우기
        // 아무값도 못 받으면 이미지 띄우기
        // 이거 수정해야해
       // print("졸리다\(cell.searchedCafe)")

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let resultMapVC = self.storyboard?.instantiateViewController(identifier: "ResultMapVC") as? ResultMapVC else { return }
        resultMapVC.hidesBottomBarWhenPushed = false
        resultMapVC.latitude = searchedCafe?[indexPath.row].latitude
        resultMapVC.longitude = searchedCafe?[indexPath.row].longitude
        resultMapVC.cafeName = searchedCafe?[indexPath.row].cafeName
        resultMapVC.cafeAddress = searchedCafe?[indexPath.row].cafeAddress
        resultMapVC.businessHours = searchedCafe?[indexPath.row].businessHours
        // 영업시간 받아오기

        self.navigationController?.pushViewController(resultMapVC, animated: true)


    }


}

extension SearchResultVC: UITextFieldDelegate {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var str = textField.text
        if str?.count != 0{
            searchTextField.resignFirstResponder()
            search(str ?? "")
        }
        
        return true
    }

}
