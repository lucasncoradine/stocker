import SwiftUI

struct HomeTableView: View {
    let data: [HomeTableData]
    
    init(from data: [HomeTableData]) {
        self.data = data
    }
    
    var body: some View {        
        TableView {
            ForEach(data) { item in
                NavigationLink(destination: DetailsView(for: item.id)) {
                    HomeTableRow(label: item.label, isStock: item.isStock)
                }
            }
        }
    }
}

struct HomeTableView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTableView(from: [
            .init(label: "Simple List One"),
            .init(label: "Simple List Two"),
            .init(label: "Stock List", isStock: true)
        ])
    }
}
