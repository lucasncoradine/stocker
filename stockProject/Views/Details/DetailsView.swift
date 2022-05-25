//
//  DetailsView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 23/05/22.
//

import SwiftUI

struct DetailsView: View {
    let recordId: String
    @StateObject var viewModel = DetailsViewModel()
    
    // MARK: - Lifecycle
    init(for recordId: String) {
        self.recordId = recordId
    }
    
    private func getDetails() {
        viewModel.getDetails(of: recordId)
    }
    
    // MARK: - View
    var body: some View {
        VStack {
            if viewModel.isLoading { ProgressView() }
            else {
                TabView {
                    // Details List
                    DetailsListView(list: viewModel.list)
                        .tabItem {
                            Image(systemName: "shippingbox")
                            Text("Estoque")
                        }
                    
                    // Details Shopping List
                    Text("Shopping List View") //TODO: ShoppingListView
                        .tabItem {
                            Image(systemName: "cart")
                            Text("Lista de Compras")
                        }
                }
            }
        }
        // Error Alert
        .errorAlert(message: viewModel.errorMessage,
                    visible: $viewModel.showError,
                    action: getDetails)
        // Get Details
        .onAppear { getDetails() }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(for: "recFYl08pRpZu5onK")
    }
}
