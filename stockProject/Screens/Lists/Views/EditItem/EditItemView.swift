//
//  EditItemView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 05/07/22.
//

import SwiftUI

struct EditItemView: View {
    private let navigationTitle: String
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: EditItemViewModel
    
    // MARK: - Lifecycle
    init(listId: String, item: ItemModel? = nil) {
        let itemModel = item ?? ItemModel(name: "", description: "", amount: 1)
        self._viewModel = StateObject(wrappedValue: EditItemViewModel(from: listId, with: itemModel))
        self.navigationTitle = item?.name ?? Strings.editItemNavigationTitle
    }
    
    //MARK: - View
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField(EditItemField.name.description, text: $viewModel.item.name)
                        .validation(viewModel.validations.valueOf(EditItemField.name.description))
                    
                    TextField(EditItemField.description.description, text: $viewModel.item.description)
                }
                
                Section {
                    Toggle(isOn: $viewModel.hasExpirationDate.animation()) {
                        Label(EditItemField.expireDate.description, systemImage: "calendar")
                            .foregroundColor(Color(.label))
                    }
                    .onTapGesture {
                        UIApplication.shared.dismissKeyboard()
                    }
                    
                    if viewModel.hasExpirationDate {
                        DatePicker("", selection: $viewModel.expirationDate, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                    }
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
                    Button(action: {
                        viewModel.saveItem {
                            dismiss()
                        }
                    }) {
                        Text(Strings.save).bold()
                    }
                }
            }
        }
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(listId: "")
            .preferredColorScheme(.light)
    }
}
