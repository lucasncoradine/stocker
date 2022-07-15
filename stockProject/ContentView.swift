//
//  ContentView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 26/04/22.
//

import SwiftUI

struct ContentView: View {
    private let client: AuthManager = .init()
        
    var body: some View {
        HomeView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
