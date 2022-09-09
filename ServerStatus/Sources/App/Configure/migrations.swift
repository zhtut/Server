//
//  File.swift
//  
//
//  Created by zhtg on 2022/6/13.
//

import Vapor
import Fluent

func migrations(_ app: Application) throws {
    
    app.migrations.add(SessionRecord.migration)
    
    // 添加migration
//    app.migrations.add(Module.Create())
//    app.migrations.add(Product.Create())
//    app.migrations.add(Project.Migration())
    
//    try app.autoRevert().wait()
    
    // 自动注册migration
    try app.autoMigrate().wait()
}
