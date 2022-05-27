//
//  ListInfoView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 27/05/22.
//

import SwiftUI

typealias OnSaveClosure = (_ data: ListModel) -> Void

struct ListInfoView: View {
    private let list: ListModel?
    private let onSave: OnSaveClosure?
        
    @SwiftUI.Environment(\.dismiss) var dismiss
    @State var selectedListType: ListType = .simple
    @State var newListName: String = ""
    
    // MARK: - Lifecycle
    init(onSave: OnSaveClosure? = nil, list: ListModel? = nil) {
        self.list = list
        self.onSave = onSave
        
        guard let list = list else { return }
        self._selectedListType = State(initialValue: list.type)
        self._newListName = State(initialValue: list.name)
    }
    
    var title: String {
        guard let list = list else { return "Nova lista" }
        return list.name
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Spacer()
                        
                        VStack {
                            Image(selectedListType.icon)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 76, height: 76)
                                .clipped()
                                .padding(.bottom)
                            
                            TextField("Nome da lista", text: $newListName)
                                .clipShape(Rectangle())
                                .frame(height: 36)
                                .background(Color(uiColor: .systemFill))
                                .cornerRadius(13)
                                .multilineTextAlignment(.center)
                        }
                        .padding([.bottom, .top])
                        
                        Spacer()
                    }
                }
                
                Section {
                    Picker("Tipo de lista", selection: $selectedListType) {
                        ForEach(ListType.allCases) { listType in
                            Text(listType.label.capitalized)
                        }
                    }
                }
            }
            .navigationBarTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar", action: { dismiss() })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salvar", action: {
                        onSave?(.init(name: newListName, type: selectedListType))
                        dismiss()
                    })
                    .disabled(newListName.isEmpty)
                }
            }
        }
    }
}

struct ListInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ListInfoView()
            .previewLayout(.sizeThatFits).preferredColorScheme(.light)
    }
}
