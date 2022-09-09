//
//  File.swift
//  
//
//  Created by zhtg on 2022/6/14.
//

import Fluent
import Vapor

/// App
final class Project: Model, Content {
    
    static var schema: String {
        "projects"
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
}

extension Project: Validatable {
    // 验证参数的合法性
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: .count(3...32) && .alphanumeric)
        validations.add("type", as: AppType.self)
        validations.add("git", as: String.self, is: .count(3...256) && .ascii)
        validations.add("desc", as: String.self, is: .count(0...1024), required: false)
    }
}

extension Project {
    
    struct Migration: AsyncMigration {
        var scheme = Project.schema
        
        func prepare(on database: Database) async throws {
            try await database.schema(scheme)
                .id()
                .field("name", .string, .required)
                .field("type", .string, .required)
                .field("git", .string, .required)
                .field("desc", .string, .required)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(scheme).delete()
        }
    }
}
