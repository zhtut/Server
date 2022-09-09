//
//  File.swift
//  
//
//  Created by zhtg on 2022/8/21.
//

import Fluent
import Vapor

class ApiController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        try routes.group("api") { module in
            try module.register(collection: V1Controller())
        }
    }
}
