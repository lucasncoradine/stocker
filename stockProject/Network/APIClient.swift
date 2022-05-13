import Foundation

class APIClient {
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = URLSession(configuration: .default)
    }
    
    private var authorizedSession: URLSession {
        let sessionConfiguration: URLSessionConfiguration = .default
        sessionConfiguration.httpAdditionalHeaders = [
            "Authorization": "Bearer \(Environment.apiKey)",
            "Content-Type": "application/json"
        ]
        
        return URLSession(configuration: sessionConfiguration)
    }
    
    func makeRequest<T: Codable>(request: Request<T>) {
        guard let url = request.url else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
                        
        let task = authorizedSession.dataTask(with: url) { data, _, error in
            guard let data = data else {
                request.failure?("No data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(Response<T>.self, from: data)
                                
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
