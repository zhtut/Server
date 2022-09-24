//
//  File.swift
//  
//
//  Created by zhtg on 2022/9/14.
//

import Vapor
import Fluent
import CommonApi

class Base: ContentModel {
    static func validations(_ validations: inout Validations) {
        
    }
    
    static var schema: String {
        return ""
    }
    
    @ID(custom: .id)
    var id: Int?
    
    // When this Planet was created.
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    // When this Planet was last updated.
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    // When this Planet was deleted.
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?
}
