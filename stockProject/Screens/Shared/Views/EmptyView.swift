//
//  EmptyView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import SwiftUI

struct EmptyView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.title2)
            .foregroundColor(.gray)
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView(text: "Empty view")
    }
}
