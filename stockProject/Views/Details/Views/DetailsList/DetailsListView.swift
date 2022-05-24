//
//  DetailsListView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 24/05/22.
//

import SwiftUI

struct DetailsListView: View {
    let list: ListData
    
    init(list: ListData) {
        self.list = list
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack {
            ListTitle(list.name)
            
            List {
                HStack {
                    Text("Caixa de leite")
                    Spacer()
                    LabeledStepper(min: 0)
                }
                .listRowSeparator(.hidden)
                .buttonStyle(.plain)
            }
            .background(.white)
            
            Spacer()
        }
    }
}

struct DetailsListView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsListView(list: .init(name: "List example", type: .stock))
    }
}
