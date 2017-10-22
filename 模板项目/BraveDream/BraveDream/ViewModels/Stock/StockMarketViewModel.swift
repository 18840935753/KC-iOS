//
//  StockMarketViewModel.swift
//  BraveDream
//
//  Created by kang chao on 2017/8/11.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import ObjectMapper
import Alamofire

struct StockMarketViewModel {
    
    // MARK: - 单例 -
    
    static var share = StockMarketViewModel()
    
    
    // MARK: - 变量 -
    
    public var adspaces:[JDtos]?
    
}

// MARK: - 网络请求 -

extension StockMarketViewModel {
    
    // 获取广告信息
    mutating func postAdspace(_ params: Parameters?, success: @escaping HttpSuccess, failure: @escaping HttpFailure) {
        let url = apiHost+path_adspace
        var vmSelf = StockMarketViewModel.share
        HttpClient.instance.post(path: url, parameters: params, success: { (response) in
            vmSelf.adspaces = Mapper<Advertise>().map(JSONObject: response)?.jDtos
            success(vmSelf.adspaces as AnyObject)
        }) { (error) in
            failure(error)
        }
    }
}

// MARK: - 界面跳转 -

extension StockMarketViewModel {

    // 打开股票横屏
    func presentStockLandscapeChart(from: UIViewController) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.isLandscape = true
        
        let kLineVC = StockKLineViewController()
        kLineVC.modalTransitionStyle = .crossDissolve
        from.present(kLineVC, animated: true, completion: nil)
    }
    
    // 关闭股票横屏
    func dismissStockLandscapeChart(from: UIViewController) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.isLandscape = false
        
        from.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - 自定义 Function -

extension StockMarketViewModel {
    
}
