//
//  File.swift
//  
//
//  Created by zhtg on 2022/8/21.
//

import Fluent
import Vapor

class V1Controller: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        try routes.group("v1") { module in
            try module.register(collection: StatusController())
            try module.register(collection: UserController())
            try module.register(collection: AssetController())
        }
    }
}
