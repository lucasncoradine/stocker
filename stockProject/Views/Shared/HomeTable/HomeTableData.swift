import Foundation

struct HomeTableData: Identifiable {
    var id: String
    let label: String
    let isStock: Bool
    
    init(recordId: String = "", label: String, isStock: Bool = false) {
        self.id = recordId
        self.label = label
        self.isStock = isStock
    }
}
