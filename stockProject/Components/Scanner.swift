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
        path.addRoundedRect(in: CGRect(origin: origin, size: size), cornerSize: .init(width: 26, height: 26))

        return path
    }
}

struct Scanner: View {
    private let completion: (_ result: ScanResult) -> Void
    private let failureClosure: FailureClosure
    private let dismissAfterResult: Bool
    
    @Environment(\.dismiss) var dismiss
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    
    init(completion: @escaping (_ result: ScanResult) -> Void,
         failure: @escaping FailureClosure,
         dismissAfterResult: Bool = false
    ) {
        self.completion = completion
        self.failureClosure = failure
        self.dismissAfterResult = dismissAfterResult
    }
    
    var body: some View {
        ZStack {
            ZStack {
                CodeScannerView(codeTypes: [.qr],
                                scanMode: .oncePerCode,
                                showViewfinder: true) { result in
                    switch result {
                    case .success(let result):
                        completion(result)
                        
                        if dismissAfterResult {
                            dismiss()
                        }
                    case .failure(let error):
                        failureClosure(error.localizedDescription)
                    }
                }
                
                Rectangle()
                    .foregroundColor(Color.black.opacity(0.65))
                    .mask {
                        QRCodeFrame().fill(style: FillStyle(eoFill: true))
                    }
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Text(Strings.scannerText)
                    .foregroundColor(.white)
                    .bold()
                    .padding(.bottom, 60)
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
        .onAppear { UITabBar.hideTabBar(animated: false) }
        .onDisappear { UITabBar.showTabBar() }
    }
}

struct Scanner_Previews: PreviewProvider {
    static var previews: some View {
        Scanner() { _ in } failure: { _ in }
    }
}
