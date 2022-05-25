import Foundation

class APIClient {
    // MARK: - Session
    private var session: URLSession {
        let sessionConfiguration: URLSessionConfiguration = .default
        sessionConfiguration.httpAdditionalHeaders = [
            "Content-Type": "application/json"
        ]
        
        return URLSession(configuration: sessionConfiguration)
    }
    
    private func authorize<T: Codable>(request: Request<T>) -> Request<T> {
        return request.query(name: "auth", value: Environment.accessToken)
    }
    
    // MARK: - Methods
    /// Executes the desired request.
    /// - parameter request: The request which will be executed.
    func makeRequest<T: Codable>(request: Request<T>) {
        let authenticatedRequest = request.authenticate(token: Environment.accessToken)
        
        guard let url = authenticatedRequest.url else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
                        
        let task = session.dataTask(with: url) { data, _, error in
            guard let data = data else {
                request.failure?("No data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                                
                request.success?(result)
            } catch let decodingError as DecodingError {
                decodingError.debug()
                request.failure?("Could't load your data.")
            } catch let error {
                print("error: ", error)
                request.failure?("Could't load your data.")
            }
        }
        
        task.resume()
    }
}

extension Request {
    /// Authorizes the request with the informed token
    /// - parameter token: The authentication token
    func authenticate(token: String) -> Self {
        return self.query(name: "auth", value: token)
    }
}
