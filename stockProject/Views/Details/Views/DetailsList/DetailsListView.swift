//
//  DetailsListView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 24/05/22.
//

import SwiftUI

// MARK: - DetailsListRow
struct DetailsListRow: View {
    let label: String
    let count: Int
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            LabeledStepper(startAt: count, min: 0)
        }
        .listRowSeparator(.hidden)
        .buttonStyle(.plain)
    }
}

// MARK: - DetilsListView
struct DetailsListView: View {
    let list: ListData
    
    @StateObject var viewModel = DetailsListViewModel()
    
    // MARK: - Lifecycle
    init(list: ListData) {
        self.list = list
        UITableView.appearance().backgroundColor = .clear
    }
    
    // MARK: - View
    var body: some View {
        VStack {
            if viewModel.isLoading { ProgressView() }
            else {
                List {
                    ForEach(viewModel.items) { item in
                        DetailsListRow(label: item.name,
                                       count: item.amount)
                    }
                }
                .listStyle(.plain)
                .background(.white)
            }
        }
        .navigationTitle(list.name)
        .onAppear { viewModel.getItems(of: list.id) }
        .errorAlert(message: viewModel.errorMessage,
                    visible: $viewModel.showError,
                    action: { viewModel.getItems(of: list.id) })
    }
}

// MARK: Preview
struct DetailsListView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsListView(list: .init(recordId: "recFYl08pRpZu5onK", label: "Sample list", type: .stock))
    }
}
