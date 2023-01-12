//
//  File.swift
//  
//
//  Created by zhtg on 2022/11/27.
//

import Vapor
//import CryptoKit
//import Crypto

struct SigntureMiddleware: AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: Vapor.AsyncResponder) async throws -> Vapor.Response {
        
//        let privateKey = Curve25519.Signing.PrivateKey()
//        let publicKey = privateKey.publicKey
//
//        let someData = "Some Data".data(using: .utf8)!
//
//        let signature = try privateKey.signature(for: someData)
//
//        guard let sign = request.headers.first(name: "sign") else {
//            throw Abort(.badRequest, reason: "not found sign")
//        }
//
//        let data = try Data(hexString: sign)
//
//        if !publicKey.isValidSignature(signature, for: data) {
//            throw Abort(.badRequest, reason: "signature invalid")
//        }
        
        return try await next.respond(to: request)
    }
}
