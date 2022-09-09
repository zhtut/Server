//
//  File.swift
//  
//
//  Created by zhtg on 2022/8/21.
//

import Fluent

extension Product {
    struct Create: AsyncMigration {
        var schema = Product.schema
        
        func prepare(on database: Database) async throws {
            try await database.schema(schema)
                .id()
                .field("version", .string, .required)
                .field("format", .string, .required)
                .field("product", .string, .required)
                .field("desc", .string, .required)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(schema).delete()
        }
    }
}
