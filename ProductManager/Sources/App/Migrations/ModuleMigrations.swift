//
//  File.swift
//  
//
//  Created by zhtg on 2022/8/21.
//

import Fluent

extension Module {
    
    /// 创建模块的数据库语法，更新模块的写到下面
    struct Create: AsyncMigration {
        var scheme = Module.schema
        
        func prepare(on database: Database) async throws {
            try await database.schema(scheme)
                .id()
                .field("name", .string, .required)
                .field("type", .int, .required)
                .field("git", .string, .required)
                .field("desc", .string, .required)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(scheme).delete()
        }
    }
}
