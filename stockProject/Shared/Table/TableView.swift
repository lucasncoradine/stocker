import SwiftUI

struct TableView: View {
    let data: [TableData]
    
    init(with data: [TableData]) {
        self.data = data
        
        UITableView.appearance().tableHeaderView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: 0,
            height: Double.leastNonzeroMagnitude
        ))
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(data) { item in
                    TableRow(label: item.label, isStock: item.isStock)
                        .listRowInsets(EdgeInsets())
                }
            }
            .listStyle(.automatic)
        }
    }
}

struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        TableView(with: [
            TableData(label: "Simple List One"),
            TableData(label: "Simple List Two"),
            TableData(label: "Stock List", isStock: true)
        ])
    }
}
