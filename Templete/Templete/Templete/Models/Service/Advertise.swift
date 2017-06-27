//
//  Advertise.swift
//  Templete
//
//  Created by kang chao on 2017/4/1.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import ObjectMapper

// 广告

class Advertise: Mappable {
    
    var jDtos: [JDtos]?
    
    required init?(map: Map){
    
    }
    
    func mapping(map: Map) {
        jDtos <- map["jDtos"]
    }
}

class JDtos: Mappable {
    
    var adName: String?
    var adWeight: Int?
    var adspaceId: Int?
    
    required init?(map: Map){
    
    }
    
    func mapping(map: Map) {
        adName <- map["adName"]
        adWeight <- map["adWeight"]
        adspaceId <- map["adspaceId"]
    }
}
