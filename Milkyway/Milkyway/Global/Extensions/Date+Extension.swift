//
//  Date+Extension.swift
//  Milkyway
//
//  Created by 이윤진 on 2020/12/28.
//

import Foundation

extension Date {
    
    func timeAgoSince(_ date: Date) -> String {
        
        let calendar = Calendar.current
        let now = Date() // 서버시간이 9시간 밀려서 뺌
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        
        if let year = components.year, year >= 1 {
            return "\(year)년 전"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month)달 전"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week)주 전"
        }
        
        // 남은 일수 계산
        if let day = components.day {
            let remain = day
            return "\(remain)"
        }
                
        return "지금"
        
    }
    
    func chatTimeAgoSince(_ date: Date) -> String {
        
        let calendar = Calendar.current
        let now = Date() // 서버시간이 9시간 밀려서 뺌
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags,
                                                             from: date,
                                                             to: now,
                                                             options: [])
        

        // 남은 일수 계산
        if let day = components.day, day >= 1 {
            let remain = day
            return "\(remain)일 전"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour)시간 전"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "한 시간 전"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute)분 전"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "1분 전"
        }
        
        if let second = components.second, second >= 1 {
            return "\(second)초 전"
        }

        return "지금"
        
    }
    
    func getElapsedInterval() -> String {
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute],
                                                       from: self,
                                                       to: Date())

        if (interval.day ?? 0) < 6 {
            return "\(7 - (interval.day ?? 0)) 일"
        } else {
            return "\(24-(interval.hour ?? 0)) 시간"
        }
    }
    
    func isCheckRoomOwner() -> String {
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute],
                                                       from: self,
                                                       to: Date())

        return "\(7 - (interval.day ?? 0))"
    }

}
