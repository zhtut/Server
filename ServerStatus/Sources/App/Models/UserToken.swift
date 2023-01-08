//
//  File.swift
//  
//
//  Created by zhtg on 2022/11/27.
//

import Vapor
import Fluent
import FluentKit

final class UserToken: Model, Content {
    
    static let schema: String = "user_tokens"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "value")
    var value: String
    
    @Field(key: "exfired")
    var exfired: Int
    
    @Parent(key: "user_id")
    var user: User
    
    init() {
        
    }
    
    init(id: UUID? = nil, value: String, exfired: Int, userID: User.IDValue) {
        self.id = id
        self.value = value
        self.exfired = exfired
        self.$user.id = userID
    }
}

// 添加一种认证，自动对该token进行认证，看是否还有效
extension UserToken: ModelTokenAuthenticatable {
    static var userKey: KeyPath<UserToken, Parent<User>> {
        \UserToken.$user
    }
    
    static var valueKey: KeyPath<UserToken, Field<String>> {
        \UserToken.$value
    }
    
    var isValid: Bool {
        let now = Int(Date().timeIntervalSince1970 * 1000)
        if now - self.exfired > 0 {
            return false
        } else {
            return true
        }
    }
}

extension UserToken {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(UserToken.schema)
                .id()
                .field("value", .string, .required)
                .field("user_id", .uuid, .required, .references(User.schema, "id"))
                .field("exfired", .int, .required)
                .create()
        }
        func revert(on database: Database) async throws {
            try await database.schema(UserToken.schema).delete()
        }
    }
}
