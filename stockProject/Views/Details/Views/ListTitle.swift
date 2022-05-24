//
//  ListTitleView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 24/05/22.
//

import SwiftUI

struct ListTitle: View {
    let title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title)
                .bold()
                .padding()
            
            Spacer()
        }
    }
}

struct ListTitle_Previews: PreviewProvider {
    static var previews: some View {
        ListTitle("List title")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
