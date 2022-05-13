import Foundation

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
}

class Request<T: Codable> {
    typealias SuccessClosure = (_ response: Response<T>) -> Void
    typealias FailureClosure = (_ error: String) -> Void
    
    let baseURL: String = Environment.baseUrl
    let client: APIClient
    var url: URL?
    var method: RequestMethod = .get
    var headers = [String:String]()
    var success: SuccessClosure?
    var failure: FailureClosure?
    
    init(client: APIClient, path: String) {
        self.client = client
        self.url = URL(string: "\(baseURL)/\(path)")        
        self.headers = ["Content-Type": "application/json"]
    }
    
    func addHeader(for key: String, value: String) -> Self {
        self.headers[key] = value
        return self
    }
    
    internal func query(name: String, value: String) -> Self {
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
    
    func setMethod(_ method: RequestMethod) -> Self {
        self.method = method
        return self
    }
    
    func success(_ closure: @escaping SuccessClosure) -> Self {
        self.success = closure
        return self
    }
    
    func failure(_ closure: @escaping FailureClosure) -> Self {
        self.failure = closure
        return self
    }
    
    func perform() {
        client.makeRequest(request: self)
    }
}

