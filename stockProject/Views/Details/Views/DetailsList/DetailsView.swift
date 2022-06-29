//
//  DetailsListView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 24/05/22.
//

import SwiftUI

// MARK: - DetailsListRow
struct DetailsListRow: View {
    @State var stepperValue: Int
    
    let label: String
    let amount: Int
    let onChange: (_ newValue: Int) -> Void
        
    init(label: String, amount: Int, onChange: @escaping (_ newValue: Int) -> Void) {
        self.label = label
        self.amount = amount
        self.onChange = onChange
        self._stepperValue = State(initialValue: amount)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            LabeledStepper(label, value: $stepperValue)
        }
        .buttonStyle(.plain)
        .onChange(of: stepperValue) { newValue in
            self.onChange(newValue)
        }
    }
}

// MARK: - DetilsListView
struct DetailsView: View {
    @State var showEditSheet: Bool = false
    @StateObject var viewModel: DetailsViewModel
    
    // MARK: - Lifecycle
    init(list: ListModel,
         onChange: @escaping (_ newData: ListModel) -> Void = { _ in }
    ) {
        _viewModel = StateObject(wrappedValue: DetailsViewModel(list: list,
                                                                onChange: onChange))
    }
        
    // MARK: - View
    var body: some View {
        VStack {
            if viewModel.list.items.isEmpty == true {
                // TODO: Empty View
                Text("Empty List")
            } else {
                List {
                    Section {
                        NavigationLink(destination: DetailsShoppingListView()) {
                            // TODO: Shopping List Params
                            Text("Compras")
                            Spacer()
                            Text("0 itens").foregroundColor(.gray)
                        }
                    }
                    
                    Section(header: Text("Itens")) {
                        ForEach(viewModel.list.items) { item in
                            DetailsListRow(label: item.name, amount: item.amount) { newValue in
                                viewModel.updateItemAmount(id: item.id, with: newValue)
                            }
                            
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
        }
        .navigationTitle(viewModel.list.name)
        .toolbar {
            Button(action: { showEditSheet.toggle() }) { // TODO: Add item action
                Image(systemName: "plus")
            }
            .sheet(isPresented: $showEditSheet) {
                Text("Editing")
            }
        }
        .onDisappear { viewModel.saveList() }
    }
}

// MARK: Preview
struct DetailsListView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(list: .init(name: "", type: .simple, items: [.init(id: 1, name: "Item", amount: 1)]))
    }
}
