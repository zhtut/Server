//
//  Module.swift
//  
//
//  Created by zhtg on 2022/6/13.
//

import Fluent
import Vapor
import CommonApi

/// 组件
final class Product: ContentModel {
    
    static var schema: String {
        "product"
    }
    
    init() { }
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "version")
    var version: String
    
    @Field(key: "format")
    var format: String
    
    @Field(key: "product")
    var product: String
    
    @Field(key: "desc")
    var desc: String
    
    static var idKeys: [String] {
        return ["version"]
    }
}

extension Product: Validatable {
    // 验证参数的合法性
    static func validations(_ validations: inout Validations) {
        validations.add("version", as: String.self)
        validations.add("format", as: String.self)
        validations.add("product", as: String.self)
        validations.add("desc", as: String.self, required: false)
    }
}
