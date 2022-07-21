//
//  UIApplicationExtension.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 17/07/22.
//

import UIKit
import LinkPresentation
import CoreImage.CIFilterBuiltins
import CoreImage.CIImage

extension UIApplication {
    func getKeyWindow() -> UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
    func dismissKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        self.sendAction(resign, to: nil, from: nil, for: nil)
    }
    
    func openShareSheet(with items: [Any]) {
        guard let keyWindow = getKeyWindow() else { return }
        
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        keyWindow.rootViewController?.present(activityViewController, animated: true)
    }
    
    func generateQRCode(from string: String) -> UIImage {
        let filter = CIFilter.qrCodeGenerator()
        let maskToAlpha = CIFilter.maskToAlpha()
        let context = CIContext()
        
        filter.message = Data(string.utf8)
        maskToAlpha.inputImage = filter.outputImage
        
        if let outputImage = maskToAlpha.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}
