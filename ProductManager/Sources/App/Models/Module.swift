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
final class Module: ContentModel {
    
    static var schema: String {
        "module"
    }
    
    init() { }
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "type")
    var type: AppType
    
    @Field(key: "git")
    var git: String
    
    @Field(key: "desc")
    var desc: String
    
    static var idKeys: [String] {
        return ["name"]
    }
}

extension Module: Validatable {
    // 验证参数的合法性
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self)
        validations.add("type", as: AppType.self)
        validations.add("git", as: String.self)
        validations.add("desc", as: String.self, required: false)
    }
}
