//
//  File.swift
//  
//
//  Created by zhtg on 2022/11/27.
//

import Foundation

extension Date {
    static var nowInterval: Int {
        return Int(Date().timeIntervalSince1970 * 1000.0)
    }
}
