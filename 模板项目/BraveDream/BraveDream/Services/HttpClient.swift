//
//  HttpClient.swift
//  Templete
//
//  Created by kang chao on 2017/4/5.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

// 网络请求成功和失败闭包
typealias HttpSuccess = (_ response: AnyObject) -> ()
typealias HttpFailure = (_ error: NSError) -> ()

class HttpClient: NSObject {
    static let instance = HttpClient()
    private override init() {}
}

extension HttpClient {
    
    /**
     * POST 请求
     * parameter urlString:  请求URL
     * parameter parameters: 请求参数
     * parameter success: 请求成功回调
     * parameter failure: 请求失败回调
     */
    
    func post(path: String,
              parameters: Parameters?,
              success: @escaping HttpSuccess,
              failure: @escaping HttpFailure) {
        
            Alamofire.request(path,
                          method: .post,
                          parameters: parameters,
                          headers: nil)
            .responseJSON { (response) in
                            
            print("\(path): \(response)")
            guard let resultValue = response.result.value else {
                failure(response.result.error as! NSError)
                return
            }
            guard let model = Mapper<HttpModel>().map(JSONObject: resultValue) else {
                print("Transform to HttpModel is nil !")
                return
            }
            if model.responCode == "000" || model.responCode == "200" {
                success(resultValue as AnyObject)
            }
        }
    }
    
    /**
     * GET 请求
     * parameter urlString:  请求URL
     * parameter parameters: 请求参数
     * parameter success: 请求成功回调
     * parameter failure: 请求失败回调
     */
    
    func get(path: String,
             parameters: Parameters?,
             success: @escaping HttpSuccess,
             failure: @escaping HttpFailure) {
        
            Alamofire.request(path,
                          method: .get,
                          parameters: parameters,
                          headers: nil)
            .responseJSON { (response) in
                            
            print("\(path): \(response)")
            guard let resultValue = response.result.value else {
                failure(response.result.error as! NSError)
                return
            }
            guard let model = Mapper<HttpModel>().map(JSONObject: resultValue) else {
                print("Transform to HttpModel is nil !")
                return
            }
            if model.responCode == "000" || model.responCode == "200" {
                success(resultValue as AnyObject)
            }
        }
    }
    
    /**
     * 配置headers, 可以自定义
     */
    
    func configHeaders() -> [String : String]? {
        let headers = [
            "content": "application/x-www-form-urlencoded; charset=utf-8",
            "Accept": "application/json",
            "token": "AOS51ADKH7881391"
        ]
        return headers
    }
}
