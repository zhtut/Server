//
//  File.swift
//  
//
//  Created by zhtg on 2022/8/29.
//

import Foundation
import FluentKit
import Vapor

enum RunStatus: String, Codable {
    case running // 运行中
    case termination // 终止
}

final class Status: Model, Content {
    
    static var schema: String = "status"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "status")
    var status: RunStatus
    
    init() {
        
    }
}
