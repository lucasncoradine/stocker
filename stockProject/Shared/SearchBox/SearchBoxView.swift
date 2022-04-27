//
//  SearchBoxView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 26/04/22.
//

import SwiftUI

struct SearchBoxView: View {
    @State private var searchText: String = ""
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.init(uiColor: .systemGray5))
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.init(uiColor: .systemGray))
                
                TextField("Buscar", text: $searchText)
            }
            .padding(.leading, 8)
            
        }
        .frame(height: 36)
        .cornerRadius(10)
    }
}

struct SearchBoxView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBoxView()
            .previewLayout(.sizeThatFits).padding()
    }
}
