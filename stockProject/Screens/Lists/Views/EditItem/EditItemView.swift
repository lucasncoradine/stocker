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
        self.navigationTitle = item?.name ?? "Novo item"
    }
    
    //MARK: - View
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Nome", text: $viewModel.item.name)
                        .fieldError(viewModel.showFieldRequired, message: "Nome do item é obrigatório")
                    
                    TextField("Descrição", text: $viewModel.item.description)
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancelar")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.saveItem {
                            dismiss()
                        }
                    }) {
                        Text("Salvar").bold()
                    }
                }
            }
        }
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(listId: "")
    }
}
