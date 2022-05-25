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
struct DetailsView: View {
    let list: ListModel
        
    // MARK: - Lifecycle
    init(list: ListModel) {
        self.list = list
    }
    
    // MARK: - View
    var body: some View {
        VStack {
            if list.items != nil {
                List {
                    Section {
                        NavigationLink(destination: DetailsShoppingListView()) {
                            Text("Compras")
                            Spacer()
                            Text("0 itens").foregroundColor(.gray)
                        }
                    }
                    
                    Section(header: Text("Itens")) {
                        ForEach(list.items!) { item in
                            DetailsListRow(label: item.name, amount: item.amount)
                                // Right Swap - Delete item
                                .swipeActions(edge: .trailing) {
                                    Button("Remover") { } // TODO: Delete item function
                                        .tint(.red)
                                }
                                // Left Swap - Add to Shopping List
                                .swipeActions(edge: .leading) {
                                    Button("Comprar") { } // TODO: Add to Shopping List function
                                        .tint(.blue)
                                }
                        }
                    }
                }
            }
            
            // TODO: Empty List View
        }
        .navigationTitle(list.name)
        .toolbar {
            Button(action: {}) { // TODO: Add item action
                Image(systemName: "plus")
            }
            .padding(.bottom)
        }
    }
}

// MARK: Preview
struct DetailsListView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(list: .init(name: "Sample List",
                                    type: .stock,
                                    items: [
                                        .init(name: "Sample item", amount: 2)
                                    ]))
    }
}
