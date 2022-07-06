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
    let onChangeClosure: (_ value: Int) -> Void
    
    @State private var counter: Int
    @State private var decreaseDisabled: Bool = false
    @State private var increaseDisabled: Bool = false
    @FocusState private var counterFieldFocused: Bool
    
    // MARK: - Lifecycle
    init(label: String,
         amount: Int,
         description: String = "",
         minValue: Int = 0,
         maxValue: Int = 99,
         counterFocused: FocusState<Bool> = .init(),
         onChange: @escaping (_ value: Int) -> Void = { _ in }         
    ) {
        self.label = label
        self.amount = amount
        self.description = description
        self._counter = State(initialValue: amount)
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
        if counter < maxValue {
            counter += 1
        }
    }
    
    private func decrease() {
        if counter > minValue {
            counter -= 1
        }
    }
    
    private func validateCounter() {
        decreaseDisabled = counter <= minValue
        increaseDisabled = counter >= maxValue
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
                    .focused($counterFieldFocused)
                    .keyboardType(.numberPad)
                    .submitLabel(.done)
                
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
            .onChange(of: counter) { value in
                onCounterChange(value)
            }
        }
        .onAppear(perform: validateCounter)
    }
}

struct Stepper_Previews: PreviewProvider {
    static var previews: some View {
        Stepper(label: "Exemplo de item", amount: 99, description: "Descrição")
    }
}
