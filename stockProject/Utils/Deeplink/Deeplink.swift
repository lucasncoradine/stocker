//
//  Deeplink.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 21/07/22.
//

import Foundation

enum DeeplinkPath: String {
    case invite = "invite"
}

struct Deeplink {
    private var query: String = ""
    let path: DeeplinkPath
    
    // MARK: - Lifecycle
    init(path: DeeplinkPath, params: [String:String] = [:]) {
        self.path = path
        
        if !params.isEmpty {
            self.query = splitParams(params)
        }
    }
    
    var urlString: String {
        return "\(Deeplink.scheme)://\(Deeplink.host)/\(path.rawValue)?\(query)"
    }
    
    var url: URL? {
        return URL(string: self.urlString)
    }
    
    // MARK: - Private functions
    private func splitParams(_ parameters: [String:String]) -> String {
        var result: String = ""
        
        parameters.forEach { key, value in
            result.append("\(key)=\(value)&")
        }
        
        return result
    }
    
    // MARK: Public methods
    mutating func addParams(_ parameters: [String:String]) {
        let newParams = splitParams(parameters)
        self.query.append(newParams)
    }
    
    mutating func addParam(key: String, value: String) {
        self.query.append("\(key)=\(value)&")
    }
}

extension Deeplink {
    static let scheme: String = "stocker"
    static let host: String = "host"
}

