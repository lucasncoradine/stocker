//
//  stockProjectApp.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 26/04/22.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

class AppParameters: ObservableObject {    
    @Published var url: URL? = nil
}

@main
struct stockProjectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var parameters = AppParameters()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(parameters)
                .onOpenURL { url in
                    self.parameters.url = url
                }
        }
    }
}
