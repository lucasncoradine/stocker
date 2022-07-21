//
//  QRCode.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 21/07/22.
//

import SwiftUI

struct QRCode: View {
    var value: String
    var radius: CGFloat = 0
    
    var qrCodeImage: UIImage {
        UIApplication.shared.generateQRCode(from: value)
    }
    
    var body: some View {
        Image(uiImage: qrCodeImage)
            .interpolation(.none)
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: radius / 2))
            .padding(30)
            .background(LinearGradient.primaryGradientVertical,
                        in: RoundedRectangle(cornerRadius: radius))
    }
}

struct QRCode_Previews: PreviewProvider {
    static var previews: some View {
        QRCode(value: "Teste")
            .padding()
    }
}
