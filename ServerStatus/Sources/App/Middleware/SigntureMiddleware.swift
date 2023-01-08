//
//  File.swift
//  
//
//  Created by zhtg on 2022/11/27.
//

import Vapor

struct SigntureMiddleware: AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: Vapor.AsyncResponder) async throws -> Vapor.Response {
        
//        let params = request.parameters.getCatchall()
//        let content = request.content.all
        
        return try await next.respond(to: request)
    }
}
