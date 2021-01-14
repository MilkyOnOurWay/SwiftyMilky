//
//  String+Extensions.swift
//  Milkyway
//
//  Created by 이윤진 on 2021/01/12.
//

import Foundation

extension String {
    
    public func stringByAddingPercentEncodingForFormData(plusForSpace: Bool=false) -> String? {
        let unreserved = "*-._"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        
        if plusForSpace {
            allowed.addCharacters(in: " ")
        }
        
        var encoded = addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
        if plusForSpace {
            encoded = encoded?.replacingOccurrences(of: " ", with: "+")
        }
        
        return encoded
    }
    
    public func getDateFormat(time: String) -> String? {
        
        let timeSplit = time.components(separatedBy: ["T", "."])
        let timeFormatted = timeSplit[0]
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYY.MM.dd"
        let timeDateFormat = dateFormat.date(from: timeFormatted)
        let stringDate = dateFormat.string(from: timeDateFormat!)
        return stringDate
    }
    
    
}
