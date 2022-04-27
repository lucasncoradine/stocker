//
//  NavigationMenuView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 27/04/22.
//

import SwiftUI

struct NavigationMenuView: View {
    @State var sort: Int = 0
    @State var showTypes: Int = 0
    
    var body: some View {
        Menu {
            Section {
                Button(action: {}) {
                    Label("Selecionar listas", systemImage: "checkmark.circle")
                }
                
                Menu {
                    Picker("", selection: $sort) {
                        Text("Nome").tag(0)
                        Text("Tipo").tag(1)
                    }
                } label: {
                    Label("Ordenar por", systemImage: "arrow.up.arrow.down")
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
}

struct NavigationMenuView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NavigationMenuView()
            Spacer()
        }
    }
}
