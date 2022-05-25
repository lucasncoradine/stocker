//
//  LabeledStepper.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 24/05/22.
//

import SwiftUI

// MARK: - StepperStyle
enum StepperStyle {
    case transparent
    case rectangle
    
    var activeColor: UIColor {
        switch self {
        case .transparent: return .systemBlue
        case .rectangle: return .black
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .transparent: return .clear
        case .rectangle: return .systemGray6
        }
    }
}

// MARK: - StepperButton
struct StepperButton: View {
    let icon: String
    let action: () -> Void
    let style: StepperStyle
    var disabled: Binding<Bool>
    
    init(_ icon: String,
         action: @escaping () -> Void,
         style: StepperStyle = .transparent,
         disabled: Binding<Bool>
    ) {
        self.icon = icon
        self.action = action
        self.style = style
        self.disabled = disabled
    }
    
    var body: some View {
        Button(action: disabled.wrappedValue ? {} : action) {
            Image(systemName: icon)
        }
        .foregroundColor(disabled.wrappedValue ? Color(uiColor: .lightGray) : Color(uiColor: style.activeColor))
        .frame(width: 48, height: 34)
        .contentShape(Rectangle())
    }
}

// MARK: - LabeledStepper
struct LabeledStepper: View {
    private let startAt: Int
    private let style: StepperStyle
    private let max: Int
    private let min: Int
    
    @State var isMinusDisabled: Bool = false
    @State var isPlusDisabled: Bool = false
    @State var count: Int = 0
    
    // MARK: - Lifecycle
    init(startAt: Int = 0,
         max: Int = 99,
         min: Int = 0,
         style: StepperStyle = .transparent
    ) {
        self.startAt = startAt
        self.max = max
        self.min = min
        self.style = style
    }
    
    // MARK: - Private methods
    private func increase() {
        count += 1
        validateButtons()
    }
    
    private func decrease() {
        count -= 1
        validateButtons()
    }
    
    private func validateButtons() {
        isPlusDisabled = validadeMax()
        isMinusDisabled = validateMin()
    }
    
    private func validadeMax() -> Bool {
        return count >= max
    }
    
    private func validateMin() -> Bool {
        return count <= min
    }
    
    // MARK: - View
    var body: some View {
        HStack {
            // Minus Button
            StepperButton("minus",
                          action: decrease,
                          style: style,
                          disabled: $isMinusDisabled)
            
            if style == .rectangle {
                Divider()
                    .padding([.top, .bottom], 8)
            }
            
            // Counter
            Text("\(count)")
                .frame(width: 28, height: 34)
            
            if style == .rectangle {
                Divider()
                    .padding([.top, .bottom], 8)
            }
            
            // Plus Button
            StepperButton("plus",
                          action: increase,
                          style: style,
                          disabled: $isPlusDisabled)
        }
        .onAppear {
            count = startAt
            validateButtons()
        }
        .background(Color(uiColor: style.backgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .frame(height: 34)
    }
}

struct LabeledStepper_Previews: PreviewProvider {
    static var previews: some View {
        LabeledStepper(startAt: 1, max: 5, min: 1)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
