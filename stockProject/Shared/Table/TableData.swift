import Foundation

struct TableData: Identifiable {
    var id: UUID
    let label: String
    let isStock: Bool
    
    init(label: String, isStock: Bool = false) {
        self.id = UUID() //TODO: Associar id real
        self.label = label
        self.isStock = isStock
    }
}
