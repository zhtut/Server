//
//  File.swift
//  
//
//  Created by shutut on 2023/1/12.
//

import Vapor

struct SafetyMiddleware: AsyncMiddleware {
    
    func respond(to request: Vapor.Request, chainingTo next: Vapor.AsyncResponder) async throws -> Vapor.Response {
        return try await next.respond(to: request)
    }
}
