//
//  File.swift
//
//
//  Created by zhtg on 2022/8/29.
//

import Foundation
import FluentKit
import Vapor
import Fluent

final class User: Model, Content {
    
    static var schema: String = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "email")
    var email: String
    
    init() {
        
    }
    
    init(username: String, password: String, email: String) {
        self.username = username
        self.password = password
        self.email = email
    }
}

// out
extension User {
    struct Out: Content {
        var id: UUID?
        var userName: String
        var email: String
    }
    var out: Out {
        .init(id: id, userName: username, email: email)
    }
}

extension User: Validatable {
    static func validations(_ validations: inout Vapor.Validations) {
        // 名称只能是字母和数字
        validations.add("username", as: String.self, is: .count(4...) && .alphanumeric, required: true)
        validations.add("password", as: String.self, is: .count(6...) && .ascii, required: true)
        validations.add("email", as: String.self, is: .email, required: true)
    }
}

extension User {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(User.schema)
                .id()
                .field("username", .string)
                .field("password", .string)
                .field("email", .string)
                .create()
        }
        func revert(on database: Database) async throws {
            try await database.schema(User.schema).delete()
        }
    }
}

// 添加一种验证，用于登录接口，Model认证，会自动对该实例用户密码进行验证
extension User: ModelAuthenticatable {
    static var usernameKey: KeyPath<User, Field<String>> {
        \User.$username
    }
    
    static var passwordHashKey: KeyPath<User, Field<String>> {
        \User.$password
    }
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}

extension User {
    // 生成一个UserToken
    func generateToken() throws -> UserToken {
        // 有效期一周
        let duration = __tokenDuration
        let exfired = Int(Date().timeIntervalSince1970) * 1000 + duration
        return try UserToken(
            value: UUID().uuidString.base64String(),
            exfired: exfired,
            userID: self.requireID())
    }
}
