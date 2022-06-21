//
//  HomeView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 26/04/22.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                //MARK: - TableView
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List {
                        ForEach(viewModel.lists, id: \.id) { item in
                            NavigationLink(destination: DetailsView(list: item)) {
                                HomeTableRow(label: item.name, type: item.type)
                            }
                            .transition(.scale)
                            .contextMenu {
                                Button {
                                    viewModel.openEdit(id: item.id)
                                } label: {
                                    Label("Edit", systemImage: "square.and.pencil")
                                }
                                
                                Button(role: .destructive) {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        withAnimation(.easeOut) {
                                            viewModel.deleteList(item)
                                        }
                                    }
                                } label: {
                                    Label("Delte", systemImage: "trash")
                                }
                            }
                        }
                        .onDelete { indexSet in viewModel.deleteLists(at: indexSet) }
                    }
                    .transition(.slide)
                    .refreshable { viewModel.getLists() }
                }
            }
            .background(Color(uiColor: .systemGray6))
            .navigationTitle("Listas")
            .errorAlert(message: viewModel.errorMessage,
                        visible: $viewModel.showError,
                        action: viewModel.getLists)
            .toolbar {
                //MARK: - Menu "more options"
                //TODO: Menu logic (select, filter, ...)
                ToolbarItem { NavigationMenuView() }
                
                //MARK: - New List Button
                ToolbarItemGroup(placement: .bottomBar) {
                    // New list button
                    Button(action: { viewModel.openEdit() }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 18, weight: .medium))
                        
                        Text("Nova lista").fontWeight(.medium)
                    }
                    .padding(.bottom)
                    .sheet(isPresented: $viewModel.showEdit) {
                        ListInfoView(onSave: viewModel.saveList,
                                     list: viewModel.listOpenForEdit)
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear { viewModel.getLists() }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
