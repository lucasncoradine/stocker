//
//  ListsSection.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 04/08/22.
//

import SwiftUI

struct ListsSection<Destination: View>: View {
    let lists: [ListModel]
    var tag: String?
    var selection: (Binding<String?>)?
    var deleteAction: ((_ listId: String?) -> Void)?
    var editAction: ((_ list: ListModel) -> Void)?
    var shareAction: ((_ list: ListModel) -> Void)?
    @ViewBuilder let destination: () -> Destination
    
    @State var localSelection: String? = nil
    
    var body: some View {
        ForEach(lists) { list in
            NavigationLink(tag: tag ?? list.name,
                           selection: selection ?? $localSelection,
                           destination: destination
            ) {
                ListRow(label: list.name)
                    .contextMenu {
                        if let editAction = editAction {
                            Button(action: { editAction(list) }) {
                                Label(Strings.edit, systemImage: "square.and.pencil")
                            }
                        }
                        
                        if let shareAction = shareAction {
                            Button(action: { shareAction(list) }) {
                                Label(Strings.share, systemImage: "person.crop.circle.badge.plus")
                            }
                        }
                        
                        if let deleteAction = deleteAction {
                            Button(role: .destructive, action: { deleteAction(list.id) }) {
                                Label(Strings.remove, systemImage: "trash")
                            }
                        }
                    }
            }
            .swipeActions {
                if let deleteAction = deleteAction {
                    Button(role: .destructive, action: { deleteAction(list.id) } ) {
                        Label(Strings.remove, systemImage: "trash")
                    }
                }
            }
        }
    }
}

struct ListsSection_Previews: PreviewProvider {
    static var previews: some View {
        ListsSection(lists: [.init(name: "Teste")]) {
            Text("Destination")
        }
    }
}
