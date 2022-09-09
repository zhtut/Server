//
//  File.swift
//  
//
//  Created by zhtg on 2022/6/15.
//

import Vapor
import Fluent

final class User: Model, Content, Authenticatable {
    
    static var schema: String {
        "users"
    }
    
    init() { }
    
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
    
    @Field(key: "name")
    var name: String
}
