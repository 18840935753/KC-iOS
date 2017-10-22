//
//  HttpModel.swift
//  Templete
//
//  Created by kang chao on 2017/4/5.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import ObjectMapper

class HttpModel: Mappable {
    
    /*
     *  请求状态
     */
    var success : Bool?
    
    /*
     *  错误码
     */
    var responCode : String?
    
    /*
     *  错误消息
     */
    var msg : String?
    
    /*
     *  响应内容
     */
    var data : AnyObject?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        success <- map["success"]
        responCode <- map["responCode"]
        msg <- map["msg"]
        data <- map["data"]
    }

}
