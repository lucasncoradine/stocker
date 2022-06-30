//
//  DetailsListView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 24/05/22.
//

import SwiftUI

// MARK: - DetilsListView
struct DetailsView: View {
    @StateObject var viewModel: DetailsViewModel
    
    // MARK: - Lifecycle
    init(list: ListModel,
         onChange: @escaping (_ newData: ListModel) -> Void = { _ in })
    {
        _viewModel = StateObject(wrappedValue: DetailsViewModel(list: list,
                                                                onChange: onChange))
    }
    
    // MARK: - View
    var body: some View {
        VStack {
            if viewModel.list.items.isEmpty == true {
                Text("No items")
                    .font(.title2)
                    .foregroundColor(.gray)
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
                            let index: Int = viewModel.list.items.firstIndex(of: item)!
                            
                            Stepper(title: item.name,
                                    description: item.description,
                                    value: $viewModel.list.items[index].amount)
                                .buttonStyle(.plain)
                                .contextMenu {
                                    Button(action: { viewModel.openEdit(of: viewModel.list.items[index]) }) {
                                        Label("Edit", systemImage: "square.and.pencil")
                                    }
                                    
                                    Button(action: {}) {
                                        Label("Add to shopping list", systemImage: "cart.badge.plus")
                                    }
                                }
                        }
                        .onDelete(perform: viewModel.deleteItems)
                    }
                }
            }
        }
        .navigationTitle(viewModel.list.name)
        .toolbar {
            Button(action: { viewModel.openEdit() }) {
                Image(systemName: "plus")
            }
            .sheet(isPresented: $viewModel.showItemDetails) {
                ItemDetailsView(item: viewModel.selectedItem, onSave: viewModel.saveItem)
            }
        }
        .onChange(of: viewModel.list.items, perform: { _ in viewModel.listHasChanged = true })
        .onDisappear { viewModel.saveList() }
    }
}

// MARK: Preview
struct DetailsListView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(list: .init(name: "", type: .simple, items: []))
    }
}
