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
                        ForEach(viewModel.lists) { item in
                            NavigationLink(destination: DetailsView(list: item)) {
                                HomeTableRow(label: item.name, isStock: item.isStock)
                            }
                        }
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
                // ToolbarItem { NavigationMenuView() }
                
                //MARK: - New List Button
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {}) {
                        Image(systemName: "plus.circle.fill")
                        Text("Nova lista").fontWeight(.medium)
                    }
                    .padding(.bottom)
                    
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
