//
//  UniverseBottomVC.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/10.
//

import UIKit

class UniverseBottomVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var handleBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setHandler()

        tableView.delegate = self
        tableView.dataSource = self
        let BottomCellNib = UINib(nibName: "BottomTVC", bundle: nil)
        self.tableView.register(BottomCellNib, forCellReuseIdentifier: "BottomTVC")
    }

}


extension UniverseBottomVC {
    
    func setView() {
        rootView.layer.cornerRadius = 12
        
        rootView.layer.shadowColor = UIColor.black.cgColor
        rootView.layer.shadowOpacity = 0.1
        rootView.layer.shadowOffset = CGSize(width: 0.0, height: -4.0)
        rootView.layer.shadowRadius = 12
        rootView.layer.masksToBounds = false
    }
    func setHandler() {
        handleBar.layer.cornerRadius = handleBar.frame.height / 2
    
       
    }
}

extension UniverseBottomVC: UITableViewDelegate {
    
}

extension UniverseBottomVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: BottomTVC = tableView.dequeueReusableCell(withIdentifier: "BottomTVC" , for: indexPath) as? BottomTVC else{
            return UITableViewCell()
            
        }
        
        return cell
    }
    
    
}
