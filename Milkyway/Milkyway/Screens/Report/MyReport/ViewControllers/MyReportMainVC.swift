//
//  MyReportMainVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/02.
//

import UIKit
import XLPagerTabStrip

class MyReportMainVC: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet var myReportTableView: UITableView!
    var tabName: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        myReportTableView.dataSource = self
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - Function
extension MyReportMainVC {
    
    /// 상단 탭바 관련
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(tabName)")
    }
    
    func registerXib() {
        let topTVCellNib = UINib(nibName: "TopTVCell", bundle: nil)
        let underExamTVCellNib = UINib(nibName: "UnderExamTVCell", bundle: nil)
        let completedTVCellNib = UINib(nibName: "CompletedTVCell", bundle: nil)
        
        myReportTableView.register(topTVCellNib, forCellReuseIdentifier: "TopTVCell")
        myReportTableView.register(underExamTVCellNib, forCellReuseIdentifier: "UnderExamTVCell")
        myReportTableView.register(completedTVCellNib, forCellReuseIdentifier: "CompletedTVCell")
    }
}

extension MyReportMainVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2{
            return 1
        } else if section == 3{
            return 1
        } else {
            return 4 // 서버에서 받는대로
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TopTVCell.identifier) as? TopTVCell else {
                return UITableViewCell()
            }
            cell.setCell(nickName: "열매열매")
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UnderExamTVCell.identifier) as? UnderExamTVCell else {
                return UITableViewCell()
            }
            cell.setCell(state: "취소된 제보")
            return cell
        } else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UnderExamTVCell.identifier) as? UnderExamTVCell else {
                return UITableViewCell()
            }
            cell.setCell(state: "진행중인 제보")
            return cell
        } else if indexPath.section == 3 {
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil)
            cell.textLabel!.text = "완료된 제보"

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CompletedTVCell.identifier) as? CompletedTVCell else {
                return UITableViewCell()
            }
            cell.setCardView()
            cell.setLabel()
            
            return cell
        }
        
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 3 {
//            return "완료된 제보"
//        } else {
//            return ""
//        }
//    }
    
    
    
}
extension MyReportMainVC: UITableViewDelegate {
    
}
