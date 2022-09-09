//
//  File.swift
//  
//
//  Created by zhtg on 2022/6/14.
//

import Fluent
import Vapor
import CommonApi

class ProjectController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        routes.group("project") { module in
            module.post("add", use: create)
            module.post("update", use: update)
            module.post("delete", use: delete)
            module.post("info", use: query)
            module.post("search", use: search)
        }
    }
    
    func search(req: Request) async throws -> [Project] {
        let all = try await Project.query(on: req.db).all()
        var filter = [Project]()
        if let searchKey = try? req.content.get(String.self, at: "searchKey") {
            for module in all {
                if module.name.contains(searchKey) ||
                    module.git.contains(searchKey) ||
                    module.desc.contains(searchKey) {
                    filter.append(module)
                }
            }
        } else {
            filter += all
        }
        if let type = try? req.content.get(AppType.self, at: "type") {
            filter = filter.filter({$0.type == type})
        }
        return filter
    }
    
    func query(req: Request) async throws -> Project {
        if let id = try? req.content.get(UUID.self, at: "id") {
            if let find = try await Project.find(id, on: req.db) {
                return find
            }
        }
        if let name = try? req.content.get(String.self, at: "name") {
            if let info = try await Project.query(on: req.db)
                .filter(\.$name == name)
                .first() {
                return info
            }
        }
        throw AbortBadRequest("未找到项目")
    }
    
    func create(req: Request) async throws -> HTTPStatus {
        // 验证参数的合法性
        try Project.validate(content: req)
        if let old = try? await query(req: req) {
            if old.$id.exists {
                throw AbortBadRequest("\(old.name)项目已存在")
            }
        }
        // 转成对象
        let module = try req.content.decode(Project.self)
        // 保存到数据库
        try await module.save(on: req.db)
        // 返回注册结果
        return .ok
    }
    
    func update(req: Request) async throws -> HTTPStatus {
        let module = try await query(req: req)
        if let type = try? req.content.get(AppType.self, at: "type") {
            module.type = type
        }
        if let git = try? req.content.get(String.self, at: "git") {
            module.git = git
        }
        if let desc = try? req.content.get(String.self, at: "desc") {
            module.desc = desc
        }
        try await module.update(on: req.db)
        return .ok
    }

    func delete(req: Request) async throws -> HTTPStatus {
        let module = try await query(req: req)
        try await module.delete(on: req.db)
        return .ok
    }
}
