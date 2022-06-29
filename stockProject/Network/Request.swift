import Foundation

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
}

class Request<T: Codable> {
    typealias SuccessClosure = (_ response: T) -> Void
    typealias FailureClosure = (_ error: String) -> Void
    
    let baseURL: String = EnvironmentVariable.baseUrl
    let client: APIClient
    var url: URL?
    var method: RequestMethod = .get
    var headers = [String:String]()
    var success: SuccessClosure?
    var failure: FailureClosure?
    
    // MARK: - Lifecycle
    init(client: APIClient, path: String) {
        self.client = client
        self.url = URL(string: "\(baseURL)/\(path)")        
        self.headers = ["Content-Type": "application/json"]
    }
    
    // MARK: - Methods
    /// Adds a header to the Request URL.
    /// - parameter key: The header key.
    /// - parameter value: The header value.
    func addHeader(for key: String, value: String) -> Self {
        self.headers[key] = value
        return self
    }
    
    /// Appends a path to the Request URL.
    /// - parameter path: The path to add.
    func appendPath(_ path: String) -> Self {
        self.url?.appendPathComponent("/\(path)")
        return self
    }
    
    func cleanQuery() -> Self {
        guard
            let url = self.url,
            var urlComponents = URLComponents(string: url.absoluteString)
        else { return self }
        
        urlComponents.queryItems?.removeAll()
        
        self.url = urlComponents.url
        return self
    }
    
    /// Appends a query parameter to the Request URL.
    /// - parameter name: The name of the query parameter.
    /// - parameter value: The value of the query parameter.
    func query(name: String, value: String) -> Self {
        guard
            let url = self.url,
            var urlComponents = URLComponents(string: url.absoluteString)
        else { return self }
        
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: name, value: value)
        
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        
        self.url = urlComponents.url
        return self
    }
    
    /// Sets the Request Method.
    /// - parameter method: The method to set.
    func setMethod(_ method: RequestMethod) -> Self {
        self.method = method
        return self
    }
   
    
    /// Defines a method to execute if the request succeeded.
    /// - parameter closure: The method to execute.
    func success(_ closure: @escaping SuccessClosure) -> Self {
        self.success = closure
        return self
    }
    
    /// Defines a method to execute if the request fails.
    /// - parameter closure: The method to execute.
    func failure(_ closure: @escaping FailureClosure) -> Self {
        self.failure = closure
        return self
    }
    
    /// Execute the request.
    func perform() {
        client.makeRequest(request: self)
    }
}

