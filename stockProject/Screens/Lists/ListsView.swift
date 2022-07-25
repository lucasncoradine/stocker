//
//  ListsView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import SwiftUI
import CodeScanner

struct ListsView: View {
    @StateObject var viewModel: ListsViewModel = .init()
    
    var body: some View {
        NavigationView {
            List() {
                // MARK: - Owned Lists
                Section {
                    ForEach(viewModel.lists.owned) { list in
                        NavigationLink(
                            destination: ListItemsView(listId: list.id ?? "", listName: list.name)
                        ) {
                            ListRow(label: list.name)
                                .contextMenu {
                                    Button(action: { viewModel.editList(list) }) {
                                        Label(Strings.edit, systemImage: "square.and.pencil")
                                    }
                                    
                                    Button(action: { viewModel.shareList(list) }) {
                                        Label(Strings.share, systemImage: "person.crop.circle.badge.plus")
                                    }
                                    
                                    Button(role: .destructive, action: { viewModel.deleteList(id: list.id) }) {
                                        Label(Strings.remove, systemImage: "trash")
                                    }
                                }
                        }
                        .swipeActions {
                            Button(role: .destructive, action: { viewModel.deleteList(id: list.id) } ) {
                                Label(Strings.remove, systemImage: "trash")
                            }
                        }
                    }
                } header: {
                    Text(Strings.listsMyLists)
                }
                
                // MARK: - Shared Lists
                if !viewModel.lists.shared.isEmpty {
                    Section {
                        ForEach(viewModel.lists.shared) { list in
                            if let listId = list.id {
                                NavigationLink(
                                    destination: ListItemsView(listId: listId, listName: list.name),
                                    tag: listId,
                                    selection: $viewModel.selectedSharedList
                                ) {
                                    ListRow(label: list.name)
                                        .contextMenu {
                                            // TODO: Quit from shared list
                                        }
                                }
                                .swipeActions {
                                    // TODO: Quit from shared list
                                }
                            }
                        }
                    } header: {
                        Text(Strings.listsSharedSection)
                    }
                }
            }
            .showEmptyView(viewModel.listsAreEmpty, emptyText: Strings.listsEmpty)
            .showLoading(viewModel.isLoading)
            .errorAlert(visible: $viewModel.showError,
                        message: viewModel.errorMessage,
                        action: viewModel.reloadList)
            .navigationTitle(Strings.listsTitle)
            .toolbar {
                ToolbarItemGroup {
                    HStack {
                        Button(action: viewModel.createList) {
                            Label(Strings.listsNew, systemImage: "plus")
                        }
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    NavigationLink(destination: Scanner(completion: viewModel.handleQrCodeScan,
                                                        failure: viewModel.requestFailed)) {
                        Label(Strings.listMenuScanQrCode, systemImage: "qrcode.viewfinder")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showEditSheet) {
                EditListView(list: viewModel.selectedList)
            }
            .sheet(isPresented: $viewModel.showShareSheet) {
                if let selected = viewModel.selectedList, let id = selected.id {
                    ShareListView(listId: id, listName: selected.name)
                }
            }
            .onAppear(perform: viewModel.fetchLists)
        }
    }
}

struct ListsView_Previews: PreviewProvider {
    static var previews: some View {
        ListsView()
            .preferredColorScheme(.light)
    }
}
