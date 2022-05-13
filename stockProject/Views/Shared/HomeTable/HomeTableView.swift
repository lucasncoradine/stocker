import SwiftUI

struct HomeTableView: View {
    let data: [HomeTableData]
    
    init(from data: [HomeTableData]) {
        self.data = data
        
        UITableView.appearance().tableHeaderView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: 0,
            height: Double.leastNonzeroMagnitude
        ))
    }
    
    var body: some View {
        List {
            ForEach(data) { item in
                HomeTableRow(label: item.label, isStock: item.isStock)
            }
        }
        .listStyle(.insetGrouped)
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
