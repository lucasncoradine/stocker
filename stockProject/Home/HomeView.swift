//
//  HomeView.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 26/04/22.
//

import SwiftUI

struct HomeView: View {
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // View Backgroud Color
                Color(uiColor: .systemGray6).ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    //MARK: - Search Box
                    SearchBoxView().padding(.horizontal)
                    
                    //MARK: - New List Button
                    Button(action: {}) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus.circle.fill")
                            Text("Nova Lista").fontWeight(.bold)
                        }
                        .padding()
                    }
                    
                    //MARK: - TableView
                    TableView(with: [
                        TableData(label: "Stock List", isStock: true),
                        TableData(label: "Stock List Two", isStock: true),
                        TableData(label: "Stock List Three", isStock: true)
                    ])
                    
                    Spacer()
                }
            }
            .navigationTitle("Listas")
            .toolbar {
                ToolbarItem {
                    NavigationMenuView()
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
