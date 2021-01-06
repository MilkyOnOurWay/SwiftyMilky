//
//  ToastView.swift
//  Milkyway
//
//  Created by soyounglee on 2021/01/07.
//

import UIKit

class ToastView: UIView {

  @IBOutlet weak var textLabel: UILabel!
  private static var sharedView: ToastView!

  static func loadFromNib() -> ToastView {
    let nibName = "\(self)".split{$0 == "."}.map(String.init).last!
    let nib = UINib(nibName: nibName, bundle: nil)
    return nib.instantiate(withOwner: self, options: nil).first as! ToastView
  }

  static func showIn(viewController: UIViewController, message: String) {

    var displayVC = viewController
    if let tabController = viewController as? UITabBarController {
      displayVC = tabController.selectedViewController ?? viewController
    }

    if sharedView == nil {
      sharedView = loadFromNib()
      sharedView.layer.masksToBounds = false
    }

    sharedView.textLabel.text = message
    let messageHeight = message.contains("\n") ? 50 : 38
    
    

    if sharedView?.superview == nil {
      let bounds: CGRect = UIScreen.main.bounds
      let y = displayVC.view.frame.height - sharedView.frame.size.height - 50
        sharedView.frame = CGRect(x: bounds.width/4, y: y, width: displayVC.view.frame.size.width - bounds.width/2, height: CGFloat(messageHeight))
      sharedView.alpha = 0.0

      displayVC.view.addSubview(sharedView)
      sharedView.fadeIn()
      sharedView.perform(#selector(fadeOut), with: nil, afterDelay: 1.2)
    }
  }


  func fadeIn() {
    UIView.animate(withDuration: 0.4, animations: {
      self.alpha = 1.0
    })
  }

  @objc func fadeOut() {

    // [1] Counter balance previous perfom:with:afterDelay
    NSObject.cancelPreviousPerformRequests(withTarget: self)

    UIView.animate(withDuration: 0.4, animations: {
      self.alpha = 0.0
    }, completion: { _ in
      self.removeFromSuperview()
    })
  }
}
