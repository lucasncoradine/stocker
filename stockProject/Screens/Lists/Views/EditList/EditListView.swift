//
//  EditListView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 05/07/22.
//

import SwiftUI

struct EditListView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: EditListViewModel
    
    // MARK: - Lifecycle
    init(list: ListModel? = nil) {
        self._viewModel = StateObject(wrappedValue: EditListViewModel(with: list ?? ListModel(name: "")))
    }
    
    // MARK: - View
    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack(alignment: .center) {
                        ListIcon()
                            .padding([.bottom, .top], 20)
                        
                        VStack {
                            TextField("Nome da lista", text: $viewModel.list.name)
                                .padding(.horizontal , 15)
                                .frame(height: 39.0)
                                .background(Color(.systemGray5))
                                .cornerRadius(13)
                                .multilineTextAlignment(.center)
                            
                            if viewModel.showNameFieldError {
                                Text("Nome da lista é obrigatório")
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            .navigationTitle(viewModel.list.name.isEmpty ? "Nova lista" : viewModel.list.name)
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
                        viewModel.saveList {
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

struct EditListView_Previews: PreviewProvider {
    static var previews: some View {
        EditListView()
    }
}
