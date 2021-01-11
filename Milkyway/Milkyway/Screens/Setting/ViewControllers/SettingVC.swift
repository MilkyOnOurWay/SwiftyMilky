//
//  SettingVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2020/12/30.
//

import UIKit

class SettingVC: UIViewController {
    
    @IBOutlet weak var SettingTableView: UITableView!
    
    let menu1 = ["닉네임 변경", "문의하기", "평점 매기기"]
    let menu2 = ["로그아웃","서비스 탈퇴"]
    let headerHeight: CGFloat = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setNavi()
        
        
    }
    
    
}

extension SettingVC {
    
    
    func setTableView(){
       
        SettingTableView.delegate = self
        SettingTableView.dataSource = self
        
        
        
    }
    
    func setNavi(){
        self.navigationController?.navigationBar.topItem?.title = "설정"
        
    }
}
extension SettingVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nvc = self.storyboard?.instantiateViewController(identifier: "NicknameChangeVC") as? NicknameChangeVC else { return }
        nvc.modalPresentationStyle = .fullScreen
        self.present(nvc, animated: true, completion: nil)
        //        guard let nvc = self.storyboard?.instantiateViewController(identifier:
        //                "SearchEntryMoimVC") as? SearchEntryMoimVC else { return }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

 
    
}

extension SettingVC: UITableViewDataSource {
    
    func tableview(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
     
        return headerHeight
    }
    
   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }


func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if section == 0 {
        
        return menu1.count
    } else if section == 1 {
        
        return menu2.count
    } else {
        return 0
    }
    
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTVCell", for: indexPath) as! SettingTVCell
    
    if indexPath.section == 0 {
        cell.settingLabel.text = "\(menu1[indexPath.row])"
        
    } else if indexPath.section == 1 {
        cell.settingLabel.text = "\(menu2[indexPath.row])"
    }else{
        
        return UITableViewCell()
    }
    return cell
}


}


