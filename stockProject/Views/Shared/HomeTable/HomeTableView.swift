import SwiftUI

struct HomeTableView: View {
    let data: [HomeTableData]
    
    init(from data: [HomeTableData]) {
        self.data = data
    }
    
    var body: some View {        
        TableView {
            ForEach(data) { item in
                HomeTableRow(label: item.label, isStock: item.isStock)
            }
        }
    }
}

struct HomeTableView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTableView(from: [
            .init(id: 1, label: "Simple List One"),
            .init(id: 2, label: "Simple List Two"),
            .init(id: 3, label: "Stock List", isStock: true)
        ])
    }
}
