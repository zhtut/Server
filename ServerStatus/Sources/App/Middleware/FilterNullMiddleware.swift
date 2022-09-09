//
//  SuccessResponse.swift
//  
//
//  Created by zhtg on 2022/6/13.
//

import Vapor
import Fluent
import SSCommon

struct FilterNullMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        // 这里是一个异步的过程，传到下一个节点去处理，处理完之后返回
        let response = try await next.respond(to: request)
        
        // 处理最后的response的body
        var responseJson: Any?
        if let data = response.body.data,
           let json = try? JSONSerialization.jsonObject(with: data) {
            responseJson = json
        }
        
        // 过滤空值
        if let dic = responseJson as? [String: Any] {
            responseJson = dic.filteredNull
        } else if let arr = responseJson as? [Any] {
            responseJson = arr.filteredNull
        }
        
        // 重新组装成data，放进body
        if let responseJson = responseJson,
            let newData = try? JSONSerialization.data(withJSONObject: responseJson) {
            let body = Response.Body(data: newData)
            response.body = body
        }
        
        return response
    }
}

extension Dictionary where Key == String {
    var filteredNull: [String: Any] {
        var newDic = [String: Any]()
        for (key,value) in self {
            if let str = value as? String, str == "<null>" {
                continue
            } else if let _ = value as? NSNull {
                continue
            } else if let dic = value as? [String: Any] {
                newDic[key] = dic.filteredNull
                continue
            } else if let arr = value as? [Any] {
                newDic[key] = arr.filteredNull
                continue
            }
            newDic[key] = value
        }
        return newDic
    }
}

extension Array {
    var filteredNull: [Any] {
        var newArr = [Any]()
        for value in self {
            if let str = value as? String, str == "<null>" {
                continue
            } else if let _ = value as? NSNull {
                continue
            } else if let dic = value as? [String: Any] {
                newArr.append(dic.filteredNull)
                continue
            } else if let arr = value as? [Any] {
                newArr.append(arr.filteredNull)
                continue
            }
            newArr.append(value)
        }
        return newArr
    }
}
