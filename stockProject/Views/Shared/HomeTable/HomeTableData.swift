import Foundation

struct HomeTableData: Identifiable {
    var id: Int
    let label: String
    let isStock: Bool
    
    init(id: Int, label: String, isStock: Bool = false) {
        self.id = id
        self.label = label
        self.isStock = isStock
    }
}
