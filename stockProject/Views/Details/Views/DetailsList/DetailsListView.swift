//
//  DetailsListView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 24/05/22.
//

import SwiftUI

// MARK: - DetailsListRow
struct DetailsListRow: View {
    let label: String
    let amount: Int
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            LabeledStepper(startAt: amount, min: 0)
        }
        .listRowSeparator(.hidden)
        .buttonStyle(.plain)
    }
}

// MARK: - DetilsListView
struct DetailsListView: View {
    let list: ListModel
        
    // MARK: - Lifecycle
    init(list: ListModel) {
        self.list = list
        
        UITableView.appearance().backgroundColor = .clear
    }
    
    // MARK: - View
    var body: some View {
        VStack {
            if list.items != nil {
                List {
                    ForEach(list.items!) { item in
                        DetailsListRow(label: item.name,
                                       amount: item.amount)
                    }
                }
                .listStyle(.plain)
            }
            
            // TODO: Empty List View
        }
        .navigationTitle(list.name)
    }
}

// MARK: Preview
struct DetailsListView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsListView(list: .init(name: "Sample List",
                                    type: .stock,
                                    items: [
                                        .init(name: "Sample item", amount: 2)
                                    ]))
    }
}
