//
//  Scanner.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 22/07/22.
//

import SwiftUI
import CodeScanner

struct QRCodeFrame: Shape {
    let size: CGSize = .init(width: 200, height: 200)
    
    func path(in rect: CGRect) -> Path {
        var path = Rectangle().path(in: rect)
        
        let origin = CGPoint(x: rect.midX - size.width / 2, y: rect.midY - size.height / 2)
        path.addRoundedRect(in: CGRect(origin: origin, size: size), cornerSize: .init(width: 13, height: 13))

        return path
    }
}

struct Scanner: View {
    private let completion: (_ result: ScanResult) -> Void
    
    @Environment(\.dismiss) var dismiss
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    
    init(completion: @escaping (_ result: ScanResult) -> Void) {
        self.completion = completion
    }
    
    var body: some View {
        ZStack {
            CodeScannerView(codeTypes: [.qr]) { result in
                switch result {
                case .success(let result):
                    completion(result)
                    dismiss()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            }
            
            Rectangle()
                .foregroundColor(Color.black.opacity(0.65))
                .mask{
                    QRCodeFrame()
                        .fill(style: FillStyle(eoFill: true))
                }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear { UITabBar.hideTabBar(animated: false) }
        .onDisappear { UITabBar.showTabBar() }
    }
}

struct Scanner_Previews: PreviewProvider {
    static var previews: some View {
        Scanner() { _ in }
    }
}
