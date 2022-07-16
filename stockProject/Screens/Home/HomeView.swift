//
//  HomeViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 15/07/22.
//

import SwiftUI

class ApplicationEnvironment: ObservableObject {
    @Published var hideTabView: Bool = false
}

struct HomeView: View {
    @StateObject var authClient: AuthManager = .init()
    @StateObject var environment: ApplicationEnvironment = .init()
    
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
