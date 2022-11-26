//
//  File.swift
//  
//
//  Created by zhtg on 2022/11/26.
//

import Fluent
import Vapor
import CommonApi
import SSCommon

class UserController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        // 用户所有的api都从user开始
        let userRoute = routes.grouped("user")
        
        // 注册接口
        userRoute.post("register", use: register)
        
        // 登录接口, /user/login 使用User的ModelAuthenticator来认证，使用Basic的token来认证，即用户名和密码
        let passwordProtected = userRoute.grouped(User.authenticator())
        passwordProtected.post("login", use: login)
        
        // token的接口 /user/me  使用UserToken的ModelTokenAuthenticator来认证，使用Bearer的token来认证，由上面的登录接口返回的
        let tokenProtected = userRoute.grouped(UserToken.authenticator()).grouped(User.guardMiddleware())
        tokenProtected.get("me", use: query)
    }
    
    func query(req: Request) async throws -> User.Out {
        let user = try req.auth.require(User.self)
        return user.out
    }
    
    func register(req: Request) async throws -> User.Out {
        try User.validate(content: req)
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        try await user.save(on: req.db)
        return user.out
    }
    
    func login(req: Request) async throws -> UserToken {
        let user = try req.auth.require(User.self)
        if let uuid = user.id {
            let lastTokens = try await UserToken.query(on: req.db).filter(\.$user.$id == uuid).all()
            for token in lastTokens {
                // 删除上次的token，不允许多设备登录
                try? await token.delete(on: req.db)
            }
        }
        let token = try user.generateToken()
        try await token.save(on: req.db)
        return token
    }
}
