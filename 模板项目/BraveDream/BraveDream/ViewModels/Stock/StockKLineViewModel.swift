//
//  StockKLineViewModel.swift
//  BraveDream
//
//  Created by kang chao on 2017/8/16.
//  Copyright © 2017年 kang chao. All rights reserved.
//


import ObjectMapper
import Alamofire

struct StockKLineViewModel {
    
    // MARK: - 单例 -
    
    static var share = StockKLineViewModel()
    
    
    // MARK: - 变量 -
    
    // 分时数据
    public var timeLineData: JSUPriceModel?
    
    // 五档数据
    public var fiveDealData: JSUTradeModel?
    
    // 实时行情数据
    public var realTimeData: JSUStateModel?
    
    // 五日数据
    public var fiveDateData: JSUPriceModel?
    
    // 月K数据
    public var monthLineData: JSUKLineMessage?
    
    // 周K数据
    public var weekLineData: JSUKLineMessage?
    
    // 日K数据
    public var dailyLineData: JSUKLineMessage?

}

// MARK: - 网络请求 -

extension StockKLineViewModel {
    
    // 获取分时数据
    mutating func postTimeLineData(_ params: Parameters?, success: @escaping HttpSuccess, failure: @escaping HttpFailure) {
        let url = apiHost+path_stockTimeLine
        var vmSelf = StockKLineViewModel.share
        HttpClient.instance.post(path: url, parameters: params, success: { (response) in
            if let dic = response as? [String : Any] {
                if let message = dic["message"] as? [String : Any] {
                    vmSelf.timeLineData = Mapper<JSUPriceModel>().map(JSON: message)
                    success(vmSelf.timeLineData as AnyObject)
                }
            }
        }) { (error) in
            failure(error)
        }
    }
    
    // 获取五档数据
    mutating func postFiveDealData(_ params: Parameters?, success: @escaping HttpSuccess, failure: @escaping HttpFailure) {
        let url = apiHost+path_stockFiveDeal
        var vmSelf = StockKLineViewModel.share
        HttpClient.instance.post(path: url, parameters: params, success: { (response) in
            if let dic = response as? [String : Any] {
                if let message = dic["message"] as? [String : Any] {
                    vmSelf.fiveDealData = Mapper<JSUTradeModel>().map(JSON: message)
                    success(vmSelf.fiveDealData as AnyObject)
                }
            }
        }) { (error) in
            failure(error)
        }
    }
    
    // 获取实时行情
    mutating func postRealTimeData(_ params: Parameters?, success: @escaping HttpSuccess, failure: @escaping HttpFailure) {
        let url = apiHost+path_stockRealTime
        var vmSelf = StockKLineViewModel.share
        HttpClient.instance.post(path: url, parameters: params, success: { (response) in
            if let dic = response as? [String : Any] {
                if let message = dic["message"] as? [String : Any] {
                    vmSelf.realTimeData = Mapper<JSUStateModel>().map(JSON: message)
                    success(vmSelf.realTimeData as AnyObject)
                }
            }
        }) { (error) in
            failure(error)
        }
    }
    
    // 获取实时行情
    mutating func postFiveDateData(_ params: Parameters?, success: @escaping HttpSuccess, failure: @escaping HttpFailure) {
        let url = apiHost+path_fiveDate
        var vmSelf = StockKLineViewModel.share
        HttpClient.instance.post(path: url, parameters: params, success: { (response) in
            if let dic = response as? [String : Any] {
                if let message = dic["message"] as? [String : Any] {
                    vmSelf.fiveDateData = Mapper<JSUPriceModel>().map(JSON: message)
                    success(vmSelf.fiveDateData as AnyObject)
                }
            }
        }) { (error) in
            failure(error)
        }
    }
    
    // 获取月K行情
    mutating func postMonthLineData(_ params: Parameters?, success: @escaping HttpSuccess, failure: @escaping HttpFailure) {
        let url = apiHost+path_monthLine
        var vmSelf = StockKLineViewModel.share
        HttpClient.instance.post(path: url, parameters: params, success: { (response) in
            if let dic = response as? [String : Any] {
                vmSelf.monthLineData = Mapper<JSUKLineMessage>().map(JSON: dic)
                success(vmSelf.monthLineData as AnyObject)
            }
        }) { (error) in
            failure(error)
        }
    }
    
    // 获取周K行情
    mutating func postWeekLineData(_ params: Parameters?, success: @escaping HttpSuccess, failure: @escaping HttpFailure) {
        let url = apiHost+path_weekLine
        var vmSelf = StockKLineViewModel.share
        HttpClient.instance.post(path: url, parameters: params, success: { (response) in
            if let dic = response as? [String : Any] {
                vmSelf.weekLineData = Mapper<JSUKLineMessage>().map(JSON: dic)
                success(vmSelf.weekLineData as AnyObject)
            }
        }) { (error) in
            failure(error)
        }
    }
    
    // 获取周K行情
    mutating func postDailyLineData(_ params: Parameters?, success: @escaping HttpSuccess, failure: @escaping HttpFailure) {
        let url = apiHost+path_dailyLine
        var vmSelf = StockKLineViewModel.share
        HttpClient.instance.post(path: url, parameters: params, success: { (response) in
            if let dic = response as? [String : Any] {
                vmSelf.dailyLineData = Mapper<JSUKLineMessage>().map(JSON: dic)
                success(vmSelf.dailyLineData as AnyObject)
            }
        }) { (error) in
            failure(error)
        }
    }

}

// MARK: - 数据整理 -

extension StockKLineViewModel {
    
    // 分时数据整理
    func timeLineDataSet(from model: JSUPriceModel) -> KTimeDataSet {
        
        var timeArray = [TimeLineEntity]()
        var lastVolume = CGFloat(0)
        if let shares = model.shares {
            var lastAvg = CGFloat(0)
            for dic in shares{
                let entity = TimeLineEntity()
                entity.currtTime = Date(fromString: dic.dt ?? "",
                                        format: "HH:mm:ss")?.toString(format: "HH:mm")
                if let c = model.close{
                    entity.preClosePx = CGFloat(c)
                }
                if let p = dic.price{
                    entity.lastPirce = CGFloat(p)
                }
                if let v = dic.volume {
                    entity.volume = CGFloat(v) - lastVolume
                    lastVolume = CGFloat(v)
                    if let a = dic.amount{
                        //均线
                        entity.avgPirce = CGFloat(a/v)
                    }
                }
                if entity.avgPirce.isNaN {
                    entity.avgPirce = lastAvg
                }else{
                    lastAvg = entity.avgPirce
                }
                //涨跌幅
                if let r = dic.ratio{
                    entity.rate = CGFloat(r)
                }
                timeArray.append(entity)
            }
        }
        
        let set = KTimeDataSet()
        set.data = timeArray
        
        return set
    }
    
    // 五日数据整理
    func fiveDateDataSet(from model: JSUPriceModel) -> KTimeDataSet {
        
        var timeArray = [TimeLineEntity]()
        var lastVolume = CGFloat(0)
        let preClose = model.close
        var days = [String]()
        if let d = model.days {
            for day in d {
                let date = Date(fromString: day, format: "yyyy-MM-dd")?.toString(format: "MM-dd")
                days.append(date ?? "--")
            }
        }
        var allprice = CGFloat(0)
        var number = CGFloat(1)
        if let shares = model.shares {
            var lastAvg = CGFloat(0)
            for (index,dic) in shares.enumerated() {
                let entity = TimeLineEntity()
                entity.currtTime = Date(fromString: dic.dt ?? "",
                                        format: "yyyy-MM-dd HH:mm:ss")?.toString(format: "MM-dd HH:mm")
                if let c = model.close {
                    entity.preClosePx = CGFloat(c)
                }
                
                if let p = dic.price {
                    entity.lastPirce = CGFloat(p)
                    if index == 0{
                        lastAvg = entity.lastPirce
                    }
                    allprice = allprice + CGFloat(p)
                    //涨跌幅
                    if let c = preClose {
                        entity.rate = (CGFloat(p/c)-1)*100
                    }
                }
                
                if let v = dic.volume {
                    entity.volume = CGFloat(v)-lastVolume
                    if entity.currtTime?.contains("09:30") == true {
                        entity.volume = CGFloat(v)
                    }
                    lastVolume = CGFloat(v)
                    if let a = dic.amount {
                        //均线
                        entity.avgPirce = CGFloat(a/v)
                    }
                    entity.avgPirce = allprice/(number)
                    number = number + 1
                }
                if entity.avgPirce.isNaN {
                    entity.avgPirce = lastAvg
                } else {
                    lastAvg = entity.avgPirce
                }
                
                timeArray.append(entity)
            }
        }
        
        var daysArr = [String]()
        if let days = model.days {
            daysArr = days
        }
        
        let set = KTimeDataSet()
        set.data = timeArray
        set.days = daysArr
        
        return set
    }
    
    // K线数据整理
    func kLineDataSet(from model: JSUKLineMessage) -> KLineDataSet {
        
        if let data = model.message {
            var array = [KLineEntity]()
            for dic in data {
                let entity = KLineEntity()
                if let b = dic.boll {
                    if let mid = b["MID"] as? CGFloat {
                        entity.mid = mid
                    }
                }
                if let h = dic.high{
                    entity.high = CGFloat(h)
                }
                if let o = dic.open{
                    entity.open = CGFloat(o)
                }
                if let r = dic.inc{
                    entity.rate = CGFloat(r)
                }
                if let l = dic.low{
                    entity.low = CGFloat(l)
                }
                if let c = dic.close{
                    entity.close = CGFloat(c)
                }
                if let d = dic.dt{
                    entity.date = d
                }
                if let ma5 = dic.ma?.MA5{
                    entity.ma5 = CGFloat(ma5)
                }
                if let ma10 = dic.ma?.MA10{
                    entity.ma10 = CGFloat(ma10)
                }
                if let ma20 = dic.ma?.MA20{
                    entity.ma20 = CGFloat(ma20)
                }
                if let v = dic.vol{
                    entity.volume = CGFloat(v)
                }
                array.append(entity)
            }
            
            let set = KLineDataSet()
            set.data = array
            
            return set
        }
        return KLineDataSet()
    }

}
