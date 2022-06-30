//
//  LabeledStepper.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 30/06/22.
//

import SwiftUI
import LabeledStepper

struct Stepper: View {
    let title: String
    let description: String?
    let value: Binding<Int>
    
    // MARK: - Lifecycle
    init(title: String, description: String? = nil, value: Binding<Int>) {
        self.title = title
        self.description = description
        self.value = value
    }
    
    // MARK: - View
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(title)
                
                if description?.isEmpty == false {
                    Text(description!)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            LabeledStepper("", value: value)
        }
    }
}

struct Stepper_Previews: PreviewProvider {
    static var previews: some View {
        Stepper(title: "Item", description: "Description", value: .constant(0))
    }
}
