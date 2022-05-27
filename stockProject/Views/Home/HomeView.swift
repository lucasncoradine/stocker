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
                                HomeTableRow(label: item.name, isStock: item.isStock)
                            }
                            // Swipe Right - Delete
//                            .swipeActions(edge: .trailing) {
//                                Button(action: { viewModel.deleteList(id: item.id) }) {
//                                    Image(systemName: "trash")
//                                }
//                                .tint(.red)
//                            }
                        }
                        .onDelete(perform: viewModel.deleteLists )
                    }
                    .refreshable { viewModel.getLists() }
                }
            }
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
                    Button(action: { viewModel.showEdit.toggle() }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 18, weight: .medium))
                        
                        Text("Nova lista").fontWeight(.medium)
                    }
                    .padding(.bottom)
                    .sheet(isPresented: $viewModel.showEdit) {
                        ListInfoView(onSave: viewModel.createList)
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
