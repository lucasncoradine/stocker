import SwiftUI

struct HomeTableView: View {
    let data: [ListModel]
    
    init(from data: [ListModel]) {
        self.data = data
    }
    
    var body: some View {        
        List {
            ForEach(data) { item in
                NavigationLink(destination: DetailsView(list: item)) {
                    HomeTableRow(label: item.name, type: item.type)
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
