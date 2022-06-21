//
//  ListIcon.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 31/05/22.
//

import SwiftUI

enum ListIconAppearance {
    case flat
    case pretty
}

struct ListImage: View {
    private let type: ListType
    private let appearance: ListIconAppearance
    private let size: CGFloat
    
    init(listType: ListType,
         size: CGFloat,
         appearance: ListIconAppearance = .flat
    ) {
        self.type = listType
        self.appearance = appearance
        self.size = size
    }
    
    var colors: [Color] {
        appearance == .flat ?
        [type.color] :
        [type.color.opacity(0.4), type.color]
    }
    
    var CircleView: some View {
        let shadowColor = appearance == .flat ? .clear : type.color.opacity(0.35)
        let view = Circle()
            .fill(
                LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
            )
            .frame(width: size, height: size)
            .shadow(color: shadowColor, radius: 5)
        
        return view
    }
    
    // MARK: - View
    var body: some View {
        ZStack {
            CircleView
            Image(systemName: type.icon)
                .font(.system(size: size/2,
                              weight: .bold))
                .foregroundColor(.white)
        }
    }
}

struct ListImage_Previews: PreviewProvider {
    static var previews: some View {
        ListImage(listType: .stock, size: 64, appearance: .pretty)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
