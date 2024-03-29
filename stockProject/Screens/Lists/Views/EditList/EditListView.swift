//
//  EditListView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 05/07/22.
//

import SwiftUI

struct EditListView: View {
    private let navigationTitle: String
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: EditListViewModel
    
    // MARK: - Lifecycle
    init(list: ListModel? = nil) {
        self._viewModel = StateObject(wrappedValue: EditListViewModel(with: list ?? ListModel(name: "")))
        self.navigationTitle = list?.name ?? Strings.editListNavigationTitle
    }
    
    // MARK: - View
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .center) {
                        ListIcon(size: 64)
                            .padding(.bottom, 10)
                        
                        VStack {
                            TextField(EditListField.listName.description, text: $viewModel.list.name)
                                .customStyle(alignment: .center)
                                .validation(viewModel.validations.valueOf(EditListField.listName.description))
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text(Strings.cancel)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.saveList {
                            dismiss()
                        }
                    } label: {
                        Text(Strings.save).bold()
                    }
                }
            }
        }
    }
}

struct EditListView_Previews: PreviewProvider {
    static var previews: some View {
        EditListView()
            .preferredColorScheme(.dark)
    }
}
