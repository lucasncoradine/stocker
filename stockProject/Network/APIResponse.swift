enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
}

class APIResponse<T> {
    let headers: [String:String]
    let method: RequestMethod
    
    init(of method: RequestMethod, with headers: [String:String]) {
        self.headers = headers
        self.method = method
    }
}
