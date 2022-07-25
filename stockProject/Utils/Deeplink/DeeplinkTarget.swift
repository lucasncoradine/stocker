//
//  DeeplinkExtension.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 21/07/22.
//

import SwiftUI

struct DeeplinkTarget {
    let path: DeeplinkPath
    let params: [String:String]
    
    init(_ path: DeeplinkPath, params: [String:String] = [:]){
        self.path = path
        self.params = params
    }
}

extension DeeplinkTarget {
    static func getFromUrl(_ url: URL) -> DeeplinkTarget? {
        guard url.scheme == Deeplink.scheme,
              url.host == Deeplink.host,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems
        else { return nil }
        
        let query = queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
        
        guard let path = DeeplinkPath.init(rawValue: url.path.replacingOccurrences(of: "/", with: ""))
        else { return nil }
        
        return DeeplinkTarget(path, params: query)
    }
}
