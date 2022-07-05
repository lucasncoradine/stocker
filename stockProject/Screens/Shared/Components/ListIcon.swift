//
//  ListIcon.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import SwiftUI

struct ListIcon: View {
    private let circleSize: CGFloat
    private let iconSize: CGFloat
    
    // MARK: - Lifecycle
    init(size: CGFloat = 76) {
        self.circleSize = size
        self.iconSize = size/2
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.green)
                .frame(width: circleSize)
            
            Image(systemName: "archivebox.fill")
                .foregroundColor(.white)
                .font(.system(size: iconSize, weight: .bold))
        }
    }
}

struct ListIcon_Previews: PreviewProvider {
    static var previews: some View {
        ListIcon()
            .previewLayout(.sizeThatFits)
    }
}
