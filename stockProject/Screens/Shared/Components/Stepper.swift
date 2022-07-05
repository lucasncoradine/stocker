//
//  Stepper.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 01/07/22.
//

import SwiftUI

struct Stepper: View {
    let label: String
    let description: String
    let amount: Int
    let maxValue: Int
    let minValue: Int
    let onIncreaseClosure: () -> Void
    let onDecreaseClosure: () -> Void
    
    @State var counter: Int
    @State var decreaseDisabled: Bool = false
    @State var increaseDisabled: Bool = false
    @FocusState private var counterFieldFocused: Bool
    
    // MARK: - Lifecycle
    init(label: String,
         amount: Int,
         description: String = "",
         minValue: Int = 0,
         maxValue: Int = 99,
         onDecrease: @escaping () -> Void = {},
         onIncrease: @escaping () -> Void = {}
    ) {
        self.label = label
        self.amount = amount
        self.description = description
        self._counter = State(initialValue: amount)
        self.minValue = minValue
        self.maxValue = maxValue
        self.onDecreaseClosure = onDecrease
        self.onIncreaseClosure = onIncrease
    }
    
    private var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimum = .init(integerLiteral: minValue  )
        formatter.maximum = .init(integerLiteral: maxValue)
        
        return formatter
    }
    
    // MARK: - Private Methods
    private func increase() {
        if counter < maxValue {
            counter += 1
            onIncreaseClosure()
        }
    }
    
    private func decrease() {
        if counter > minValue {
            counter -= 1
            onDecreaseClosure()
        }
    }
    
    private func onCounterChange() {
        decreaseDisabled = counter <= minValue
        increaseDisabled = counter >= maxValue
    }
    
    // MARK: - View
    var body: some View {
        HStack(alignment: .center) {
            // Label
            VStack(alignment: .leading) {
                Text(label)
                
                if description.isEmpty == false {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Stepper
            HStack {
                // Decrease button
                Button(action: decrease) {
                    Image(systemName: "chevron.down")
                        .foregroundColor( decreaseDisabled ? .gray : .blue)
                        .padding(.leading, 8)
                }
                .disabled(decreaseDisabled)
                                
                Divider().fixedSize()
                
                // Count
                TextField("", value: $counter, formatter: self.formatter)
                    .frame(width: 30)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .focused($counterFieldFocused)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            
                            Button("Done") {
                                counterFieldFocused = false
                            }
                            .foregroundColor(.blue)
                        }
                    }
                                
                Divider().fixedSize()
                
                // Increase button
                Button(action: increase) {
                    Image(systemName: "chevron.up")
                        .foregroundColor( increaseDisabled ? .gray : .blue)
                        .padding(.trailing, 8)
                }
                .disabled(increaseDisabled)
            }
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 7))
            .onChange(of: counter) { _ in
                onCounterChange()
            }
        }
        .onAppear(perform: onCounterChange)
    }
}

struct Stepper_Previews: PreviewProvider {
    static var previews: some View {
        Stepper(label: "Exemplo de item", amount: 99, description: "Descrição")
    }
}
