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

class DeeplinkManager {
    static func getTarget(url: URL) -> DeeplinkTarget {
        guard url.scheme == Deeplink.scheme,
              url.host == Deeplink.host,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems
        else { return DeeplinkTarget(.home) }
        
        let query = queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
        
        guard let path = DeeplinkPath.init(rawValue: url.path.replacingOccurrences(of: "/", with: ""))
        else { return DeeplinkTarget(.home) }
        
        return DeeplinkTarget(path, params: query)
    }
    
    @ViewBuilder static func switchTarget(_ target: DeeplinkTarget) -> some View {
        switch target.path {
        default:
            HomeView()
        }
    }
}
