//
//  ProfileView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 14/07/22.
//

import SwiftUI

struct ProfileView: View {
    private let auth: AuthManager = .init()
    let user: FirebaseUser?
    
    var body: some View {
        VStack {
            if let userName = user?.displayName {
                Text("Hi, \(userName)")
            }
            
            Button(action: { auth.signOut() }) {
                Text("Logout")
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: nil)
    }
}
