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
            try module.register(collection: ModuleController())
            try module.register(collection: ProductController())
//            try module.register(collection: ProjectController())
        }
    }
}
