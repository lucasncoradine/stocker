import Foundation

protocol EnvironmentVariable {
    static var apiKey: String { get }
    static var listsTable: String { get }
    static var baseUrl: String { get }
}

extension EnvironmentVariable {
    static var apiKey: String { getValue(of: "api_key") }
    static var listsTable: String { getValue(of: "lists_table") }
    static var baseUrl: String { getValue(of: "base_url") }
    
    private static func getValue(of key: String) -> String {
        return ProcessInfo.processInfo.environment[key] ?? ""
    }
}

public enum Environment: EnvironmentVariable {
    
}
