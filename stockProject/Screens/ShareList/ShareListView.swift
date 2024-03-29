//
//  ShareListView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 21/07/22.
//

import SwiftUI

struct ShareListView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ShareListViewModel
        
    init(listId: String, listName: String) {
        self._viewModel = StateObject(wrappedValue: ShareListViewModel(listId: listId, listName: listName))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Title
                HStack(spacing: 10) {
                    ListIcon(size: 40)
                    
                    Text(viewModel.listName)
                        .bold()
                        .font(.title)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 10)
                
                // QRCode
                VStack(spacing: 13) {
                    QRCode(value: viewModel.deeplink.urlString, radius: 13)
                        .frame(height: 250)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup {
                    Button(action: { dismiss() }) {
                        Text(Strings.close)
                    }
                }
            }
        }
    }
}

struct ShareListView_Previews: PreviewProvider {
    static var previews: some View {
        ShareListView(listId: "SF6jqiRauIkLSTurDy15", listName: "Estoque")
    }
}
