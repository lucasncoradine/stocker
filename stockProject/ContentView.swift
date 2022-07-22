//
//  ContentView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 26/04/22.
//

import SwiftUI

struct ContentView: View {
    @State var deeplinkTarget: DeeplinkTarget = .init(.home)
    private let client: AuthManager = .init()
        
    var body: some View {
        Group {
            DeeplinkManager.switchTarget(deeplinkTarget)
        }
        .onOpenURL { url in
            self.deeplinkTarget = DeeplinkManager.getTarget(url: url)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
