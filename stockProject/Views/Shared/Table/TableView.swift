//
//  TableView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 23/05/22.
//

import SwiftUI

struct TableView<Content> : View where Content : View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
                
        UITableView.appearance().tableHeaderView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: 0,
            height: Double.leastNonzeroMagnitude
        ))
    }
    
    var body: some View {
        List { content }
            .listStyle(.insetGrouped)
    }
}

struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        TableView {
            Text("First line")
            Text("Second line")
        }
    }
}
