//
//  Commons.swift
//  BraveDream
//
//  Created by kang chao on 2017/8/18.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import Foundation

struct Commons {
    
    // MARK: 判断当前屏幕方向
    static func isLandscape() -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.isLandscape ?? false
    }
    
}
