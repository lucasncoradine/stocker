//
//  HomeViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 15/07/22.
//

import SwiftUI

struct HomeView: View {
    @StateObject var authClient: AuthManager = .init()
    
    var body: some View {
        Group {
            if authClient.isUserAuthenticated {
                TabView {
                    ListsView().tabItem {
                        Label("Início", systemImage: "house")
                    }
                    
                    ProfileView(user: AuthManager.shared.user).tabItem {
                        Label("Ajustes", systemImage: "gear")
                    }
                }
            } else {
                LoginView()
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeOut, value: authClient.isUserAuthenticated)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
