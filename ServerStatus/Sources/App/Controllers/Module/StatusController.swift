//
//  File.swift
//  
//
//  Created by zhtg on 2022/6/14.
//

import Fluent
import Vapor
import CommonApi
import SSCommon

class StatusController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        routes.group("status") { module in
            module.get(use: query)
        }
    }
    
    func query(req: Request) async throws -> Status {
        let status = Status()
        let (_, string) = try await runCommand("/bin/ps -u ubuntu")
        if string.count > 0,
           string.contains("DatabaseTrader") {
            print("程序运行正常")
            status.status = .running
        } else {
            status.status = .termination
        }
        return status
    }
}
