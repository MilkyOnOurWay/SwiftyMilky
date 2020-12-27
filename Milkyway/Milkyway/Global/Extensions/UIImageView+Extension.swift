//
//  UIImageView+Extension.swift
//  Milkyway
//
//  Created by 이윤진 on 2020/12/28.
//

import UIKit.UIImageView

import Kingfisher

extension UIImageView {
    
    func setImage(from url: String, _ defaultImage: UIImage){
        self.kf.indicatorType = .activity
        self.kf.setImage(with: URL(string: url)!,
                         placeholder: UIImage(),
                         options: [.transition(.fade(1))],
                         progressBlock: nil)
        
    }
    
    public func imageFromUrl(_ urlString: String?, defaultImgPath : String?) {
        
        let tmpUrl : String?
        
        if urlString == nil {
            tmpUrl = ""
        } else  {
            tmpUrl = urlString
        }
        if let url = tmpUrl, let defaultURL : String = defaultImgPath {
            if url.isEmpty {
                self.kf.setImage(with: URL(string: defaultURL),
                                 options: [.transition(ImageTransition.fade(0.5))])
            } else {
                self.kf.setImage(with: URL(string: url),
                                 options: [.transition(ImageTransition.fade(0.5))])
            }
        }
        
    }
    
}
