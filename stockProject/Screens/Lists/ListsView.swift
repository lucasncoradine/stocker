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
            VStack {
                if viewModel.lists.isEmpty {
                    EmptyView(text: "No lists")
                } else {
                    List(viewModel.lists) { list in
                        NavigationLink(destination: ListItemsView(listId: list.id ?? "",
                                                                  listName: list.name))
                        {
                            ListRow(label: list.name)
                        }
                        .swipeActions {
                            Button(role: .destructive, action: { viewModel.deleteList(id: list.id) } ) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .showLoading(viewModel.isLoading)
            .errorAlert(visible: $viewModel.showError,
                        message: viewModel.errorMessage,
                        action: viewModel.reloadList)
            .navigationTitle("Listas")
            .onAppear(perform: viewModel.fetchLists)
        }
    }
}

struct ListsView_Previews: PreviewProvider {
    static var previews: some View {
        ListsView()
    }
}
