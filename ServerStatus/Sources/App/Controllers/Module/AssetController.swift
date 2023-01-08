//
//  File.swift
//  
//
//  Created by zhtg on 2022/11/27.
//

import Fluent
import Vapor

class AssetController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let assets = routes.grouped("assets")
        let image = assets.grouped("images")
        image.post("upload", use: upload)
    }
    
    func upload(req: Request) async throws -> String {
        guard let buffer = req.body.data else {
            throw Abort(.badRequest)
        }
        let fileName = "\(req.fileio)"
        try await req.fileio.writeFile(buffer, at: fileName)
        return fileName
    }
}
