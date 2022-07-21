//
//  ShareLink.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 21/07/22.
//

import SwiftUI

struct ShareLink<Content: View>: View {
    let url: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        Button {
            UIApplication.shared.openShareSheet(urlString: url)
        } label: {
            content()
        }
    }
}

struct ShareLink_Previews: PreviewProvider {
    static var previews: some View {
        ShareLink(url: "https://google.com") {
            Text("Open share sheet")
        }
    }
}
