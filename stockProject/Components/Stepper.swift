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
    let maxValue: Int
    let minValue: Int
    let onChangeClosure: (_ value: Int) -> Void
    let counter: Binding<Int>
    
//    @State private var counter: Int
    @State private var decreaseDisabled: Bool = false
    @State private var increaseDisabled: Bool = false
    @FocusState private var counterFieldFocused: Bool
    
    // MARK: - Lifecycle
    init(label: String,
         amount: Binding<Int>,
         description: String = "",
         minValue: Int = 0,
         maxValue: Int = 99,
         counterFocused: FocusState<Bool> = .init(),
         onChange: @escaping (_ value: Int) -> Void = { _ in }         
    ) {
        self.label = label
        self.description = description
//        self._counter = State(initialValue: amount)
        self.counter = amount
        self.minValue = minValue
        self.maxValue = maxValue
        self._counterFieldFocused = counterFocused
        self.onChangeClosure = onChange
    }
    
    private var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimum = .init(integerLiteral: minValue  )
        formatter.maximum = .init(integerLiteral: maxValue)
        
        return formatter
    }
    
    // MARK: - Private Methods
    private func increase() {
        if counter.wrappedValue < maxValue {
            counter.wrappedValue += 1
        }
    }
    
    private func decrease() {
        if counter.wrappedValue > minValue {
            counter.wrappedValue -= 1
        }
    }
    
    private func validateCounter() {
        decreaseDisabled = counter.wrappedValue <= minValue
        increaseDisabled = counter.wrappedValue >= maxValue
    }
    
    private func onCounterChange(_ value: Int) {
        onChangeClosure(value)
        validateCounter()
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
                    Image(systemName: "minus.circle")
                        .foregroundColor( decreaseDisabled ? .gray : .blue)
                        .padding(.leading, 8)
                }
                .disabled(decreaseDisabled)
                
                Divider().fixedSize()
                
                // Count
                TextField("", value: counter, formatter: self.formatter)
                    .frame(width: 30)
                    .multilineTextAlignment(.center)
                    .focused($counterFieldFocused)
                    .keyboardType(.numberPad)
                    .submitLabel(.done)
                
                Divider().fixedSize()
                
                // Increase button
                Button(action: increase) {
                    Image(systemName: "plus.circle")
                        .foregroundColor( increaseDisabled ? .gray : .blue)
                        .padding(.trailing, 8)
                }
                .disabled(increaseDisabled)
            }
            .clipShape(RoundedRectangle(cornerRadius: 7))
        }
        .onChange(of: counter.wrappedValue) { value in
            onCounterChange(value)
        }
        .onAppear(perform: validateCounter)
    }
}

struct Stepper_Previews: PreviewProvider {
    static var previews: some View {
        Stepper(label: "Exemplo de item", amount: .constant(99), description: "Descrição")
    }
}
