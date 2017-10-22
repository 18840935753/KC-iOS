//
//  Util.swift
//  BraveDream
//
//  Created by kang chao on 2017/8/17.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import Foundation

struct Util {
    
    // MARK: 获取今天以前某天时间 yyyy-MM-dd
    static func date(before days:Int) -> String {
        var date:NSDate = NSDate()
        let zone:NSTimeZone = NSTimeZone.system as NSTimeZone
        let second:Int = zone.secondsFromGMT
        date = date.addingTimeInterval(TimeInterval(second-days*24*60*60))
        let index = "\(date)".index("\(date)".startIndex, offsetBy: 10)
        let dateStr = "\(date)".substring(to: index)
        return dateStr
    }

}
