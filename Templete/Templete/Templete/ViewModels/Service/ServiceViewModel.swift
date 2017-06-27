//
//  ServiceViewModel.swift
//  Templete
//
//  Created by kang chao on 2017/4/5.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

import ObjectMapper
import Alamofire

class ServiceViewModel: NSObject {
    
    static let instance = ServiceViewModel()
    private override init() {}
    
    var adspaces:[JDtos]?
}

extension ServiceViewModel {
    // MARK: 获取广告信息
    func postAdspace(_ params:Parameters?, success: @escaping HttpSuccess, failure: @escaping HttpFailure) {
        let url = apiHost+path_adspace
        HttpClient.instance.post(path: url, parameters: params, success: { (response) in
            self.adspaces = Mapper<Advertise>().map(JSONObject: response)?.jDtos
            success(self.adspaces as AnyObject)
        }) { (error) in
            failure(error)
        }
    }
}
