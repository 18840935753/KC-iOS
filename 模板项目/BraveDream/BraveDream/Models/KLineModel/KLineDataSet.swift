//
//  KLineDataSet.swift
//  StockChart
//
//  Created by 苏小超 on 16/2/24.
//  Copyright © 2016年 com.jason. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class KLineDataSet {
    var data : [KLineEntity]?
    var highlightLineWidth :CGFloat = 0.5
    
    var highlightLineColor = UIColor(hexString: "0x546679", alpha: 1)
    var candleRiseColor = UIColor(hexString: "0xCB1F03", alpha: 1)
    var candleFallColor = UIColor(hexString: "0x16B03E", alpha: 1)
    var avgMA5Color = UIColor(hexString: "0xe8de85", alpha: 1)
    var avgMA10Color = UIColor(hexString: "0x6fa8bb", alpha: 1)
    var avgMA20Color = UIColor(hexString: "0xdf8fc6", alpha: 1)
    var avgLineWidth : CGFloat = 1
    var candleTopBottmLineWidth : CGFloat = 1
    
    init(){
        
    }
}

class KTimeDataSet {
    var data = [TimeLineEntity]()
    var days = [String]()
    var highlightLineWidth:CGFloat = 0.5
    var highlightLineColor = UIColor(red: 60/255.0, green: 76/255.0, blue: 109/255.0, alpha: 1)
    var lineWidth:CGFloat = 1
    var priceLineCorlor = UIColor(red: 24/255.0, green: 96/255.0, blue: 254/255.0, alpha: 0.6)
    var avgLineCorlor = UIColor(red: 253/255.0, green: 179/255.0, blue: 8/255.0, alpha: 1)
    
    var volumeRiseColor = UIColor(red: 203/255.0, green: 31/255.0, blue: 3/255.0, alpha: 1)
    var volumeFallColor = UIColor(red: 22/255.0, green: 176/255.0, blue: 62/255.0, alpha: 1)
    var volumeTieColor = UIColor.gray
    
    var drawFilledEnabled = true
    var fillStartColor = UIColor(red: 24/255.0, green: 96/255.0, blue: 254/255.0, alpha: 0.4)
    var fillStopColor = UIColor(red: 24/255.0, green: 96/255.0, blue: 254/255.0, alpha: 0.3)
    var fillAlpha:CGFloat = 1
}
