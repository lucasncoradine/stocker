//
//  ListsView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import SwiftUI

struct ListsView: View {
    @StateObject var viewModel: ListsViewModel = .init()
    
    var body: some View {
        NavigationView {
            List(viewModel.lists) { list in
                NavigationLink(destination: ListItemsView(listId: list.id ?? "",
                                                          listName: list.name))
                {
                    ListRow(label: list.name)
                        .contextMenu {
                            Button(action: { viewModel.editList(list) }) {
                                Label("Editar", systemImage: "square.and.pencil")
                            }
                            
                            Button(role: .destructive, action: { viewModel.deleteList(id: list.id) }) {
                                Label("Remover", systemImage: "trash")
                            }
                        }
                }
                .swipeActions {
                    Button(role: .destructive, action: { viewModel.deleteList(id: list.id) } ) {
                        Label("Remover", systemImage: "trash")
                    }
                }
            }
            .showEmptyView(viewModel.lists.isEmpty, emptyText: "Sem listas")
            .showLoading(viewModel.isLoading)
            .errorAlert(visible: $viewModel.showError,
                        message: viewModel.errorMessage,
                        action: viewModel.reloadList)
            .navigationTitle("Listas")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: viewModel.createList) {
                        Image(systemName: "plus.circle.fill")
                        Text("Nova lista")
                    }
                    .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                }
            }
            .sheet(isPresented: $viewModel.showEditSheet, content: {
                EditListView(list: viewModel.selectedList)
            })
            .onAppear(perform: viewModel.fetchLists)    
        }
    }
}

struct ListsView_Previews: PreviewProvider {
    static var previews: some View {
        ListsView()
            .preferredColorScheme(.dark)
    }
}
