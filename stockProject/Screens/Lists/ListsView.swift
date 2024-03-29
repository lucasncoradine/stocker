//
//  ListsView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import SwiftUI
import CodeScanner

struct ListsView: View {
    @EnvironmentObject var appParameters: AppParameters
    @StateObject var viewModel: ListsViewModel = .init()
    
    var body: some View {
        NavigationView {
            List {
                // MARK: - Owned Lists
                if !viewModel.lists.owned.isEmpty {
                    Section {
                        ForEach(viewModel.lists.owned) { list in
                            NavigationLink(
                                destination: ListItemsView(list: list)
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
                }
                
                // MARK: - Shared Lists
                if !viewModel.lists.shared.isEmpty {
                    Section {
                        ForEach(viewModel.lists.shared) { list in
                            if let listId = list.id {
                                NavigationLink(
                                    destination: ListItemsView(list: list),
                                    tag: listId,
                                    selection: $viewModel.selectedSharedList
                                ) {
                                    ListRow(label: list.name)
                                        .contextMenu {
                                            Button(action: { viewModel.editList(list) }) {
                                                Label(Strings.edit, systemImage: "square.and.pencil")
                                            }
                                            
                                            Button(role: .destructive,
                                                   action: { viewModel.showQuitConfirmation.toggle() }
                                            ) {
                                                Label(Strings.listsQuitShared,
                                                      systemImage: "person.crop.circle.badge.minus")
                                            }
                                        }
                                }
                                .swipeActions {
                                    Button(role: .destructive, action: { viewModel.showQuitConfirmation.toggle() }) {
                                        Label(Strings.listsQuitShared,
                                              systemImage: "person.crop.circle.badge.minus")
                                    }
                                }
                            }
                        }
                    } header: {
                        Text(Strings.listsSharedSection)
                    }
                }
            }
            .animation(.linear, value: viewModel.lists)
            .showEmptyView(viewModel.listsAreEmpty, emptyText: Strings.listsEmpty)
            .showLoading(viewModel.isLoading)
            .errorAlert(visible: $viewModel.showError,
                        message: viewModel.errorMessage,
                        action: viewModel.reloadList)
            .alert(Strings.listsConfirmQuitTitle, isPresented: $viewModel.showQuitConfirmation) {
                Button(role: .cancel, action: { viewModel.showQuitConfirmation = false }) {
                    Text(Strings.cancel)
                }
                
                Button(role: .destructive, action: viewModel.quitSharedList) {
                    Text(Strings.listsConfirmQuitButton)
                }
            } message: {
                Text(Strings.listsConfirmQuitMessage)
            }
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
            .onChange(of: appParameters.url, perform: { url in
                viewModel.handleUrl(url)
            })
            .onAppear { viewModel.fetchLists() }
        }
    }
}

struct ListsView_Previews: PreviewProvider {
    static var previews: some View {
        ListsView()
            .preferredColorScheme(.light)
    }
}
