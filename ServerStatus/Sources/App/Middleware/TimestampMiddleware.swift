//
//  File.swift
//  
//
//  Created by zhtg on 2022/11/27.
//

import Vapor
import Fluent
import SSCommon

struct TimestampMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let timestampStr = request.headers.first(name: "timestamp"),
           let timestamp = timestampStr.intValue else {
            throw Abort(.badRequest, reason: "not found timestamp in request headers")
        }
        
        if Date.timestamp - timestamp > HTTPServer.Configuration.timestampDuration {
            throw Abort(.badRequest, reason: "timestamp exfired")
        }
        
        // 这里是一个异步的过程，传到下一个节点去处理，处理完之后返回
        return try await next.respond(to: request)
    }
}
