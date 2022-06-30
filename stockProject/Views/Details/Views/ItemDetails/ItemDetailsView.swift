//
//  DetailsInfoView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 30/06/22.
//

import SwiftUI

struct ItemDetailsView: View {
    private let onSaveClosure: (_ item: ListItemModel) -> Void
    private var navigationTitle: String = "Add item"
    
    @State private var item: ListItemModel
    @State private var validationMessage: String = ""
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Lifecycle
    init(item: ListItemModel, onSave: @escaping (_ item: ListItemModel) -> Void) {
        self._item = State(wrappedValue: item)
        self.onSaveClosure = onSave
        
        if item.name.isEmpty == false {
            self.navigationTitle = item.name
        }
    }
    
    private func saveItem() {
        guard item.name.isEmpty == false
        else {
            validationMessage = "Name is required"
            return
        }
        
        validationMessage = ""
        onSaveClosure(item)
        dismiss()
    }
    
    // MARK: - View
    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack(alignment: .leading) {
                        TextField("Name (Required)", text: $item.name)
                        
                        if validationMessage.isEmpty == false {
                            Text(validationMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    TextField("Descrição", text: $item.description)
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button(action: { saveItem() }) {
                        Text("Done").bold()
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: { dismiss() })
                }
            }
            
            // TODO: Implement expiring date
            //            Section {
            //                HStack {
            //                    Image(systemName: "calendar")
            //                    Toggle("Vencimento", isOn: .constant(true))
            //                }
            //
            //                DatePicker("Vencimento", selection: .constant(.now), displayedComponents: [.date])
            //                    .datePickerStyle(.graphical)
            //            }
        }
    }
}

struct ItemDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailsView(item: .init(name: "Item", amount: 3), onSave: { _ in })
    }
}
