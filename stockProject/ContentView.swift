//
//  ContentView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 26/04/22.
//

import SwiftUI

struct ContentView: View {    
    var body: some View {
        ListsView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
