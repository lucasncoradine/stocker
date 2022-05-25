import SwiftUI

struct HomeTableView: View {
    let data: [ListModel]
    
    init(from data: [ListModel]) {
        self.data = data
    }
    
    var body: some View {        
        TableView {
            ForEach(data) { item in
                NavigationLink(destination: DetailsView(list: item)) {
                    HomeTableRow(label: item.name, isStock: item.isStock)
                }
            }
        }
    }
}

struct HomeTableView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTableView(from: [
            .init(name: "Sample List One", type: .simple),
            .init(name: "Sample List Two", type: .stock)
        ])
    }
}
