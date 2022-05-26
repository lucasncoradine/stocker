//
//  HomeView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 26/04/22.
//

import SwiftUI

struct HomeView: View {
    @State var searchText: String = ""
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // View Backgroud Color
                Color(uiColor: .systemGray6).ignoresSafeArea()
                
                //MARK: - TableView
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    HomeTableView(from: viewModel.lists.filter {list in
                        searchText.isEmpty == true || list.name.contains(searchText)
                    })
                }
            }
            .navigationTitle("Listas")
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
        .errorAlert(message: viewModel.errorMessage,
                    visible: $viewModel.showError,
                    action: viewModel.getLists)
        .onAppear { viewModel.getLists() }
        .searchable(text: $searchText)
        .refreshable { viewModel.getLists() }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
