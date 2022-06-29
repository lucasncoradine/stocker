import Foundation

protocol EnvironmentVariableProtocol {
    static var apiKey: String { get }
    static var accessToken: String { get }
    static var baseUrl: String { get }
}

public enum EnvironmentVariable: EnvironmentVariableProtocol {
    static var apiKey: String { getValue(of: "api_key") }
    static var accessToken: String { getValue(of: "access_token") }
    static var baseUrl: String { getValue(of: "base_url") }
    
    private static func getValue(of key: String) -> String {
        return ProcessInfo.processInfo.environment[key] ?? ""
    }
}