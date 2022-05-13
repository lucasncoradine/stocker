struct Response<T: Codable>: Codable {
    let records: [Record<T>]
    
    enum CodingKeys: String, CodingKey {
        case records
    }
}

struct Record<T: Codable>: Codable {
    let id: String
    let createdTime: String
    let fields: T
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdTime
        case fields
    }
}
