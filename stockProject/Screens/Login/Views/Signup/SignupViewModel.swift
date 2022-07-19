//
//  SignupViewModel.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 12/07/22.
//

import Foundation
import SwiftUI

enum SignupField: FormViewModelField {
    case name
    case email
    case password
    case confirmPassword
    
    var description: String {
        switch self {
        case .name: return Strings.name
        case .email: return Strings.email
        case .password: return Strings.password
        case .confirmPassword: return Strings.confirmPassword
        }
    }
}

struct SignupStep {
    let tag: Int
    let title: String
}

class SignupViewModel: FormViewModelProtocol {
    private let auth: AuthManager = AuthManager.shared
    
    let steps: [SignupStep] = [
        SignupStep(tag: 0, title: Strings.signupStartTitle),
        SignupStep(tag: 1, title: Strings.signupPasswordTitle)
    ]
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var validations: Validations = [:]
    @Published var currentStep: Int = 0
    @Published var navigationTitle: String = Strings.signupStartTitle
    @Published var buttonTitle: String = Strings.signupNextButton
    
    // MARK: - Lifecycle
    init() {
        self.auth.isSigninUp = true
    }
    
    deinit {
        auth.isSigninUp = false
    }
    
    func validateFields() -> Bool {
        validations.removeAll()
        
        if currentStep == 0 {
            validations.requiredField(key: SignupField.name.description, value: self.name)
            validations.add(key: SignupField.email.description, value: Validate.email(self.email))
        }
        
        if currentStep == 1 {
            validations.requiredField(key: SignupField.password.description, value: self.password)
            validations.add(key: SignupField.confirmPassword.description,
                            value: Validate.confirmPassword(password: self.password,
                                                            confirmPassword: self.confirmPassword))
        }
        
        return validations.noErrors()
    }
    
    // MARK: - Public Methods
    func createAccout() {
        isLoading = true
        
        auth.signUp(email: self.email, password: self.password, name: self.name, failure: self.requestFailed) { _ in
            self.isLoading = false
            self.currentStep += 1
        }
    }
   
    func changeTitle(_ step: Int) {
        let isLastStep: Bool = step == steps.last?.tag
        
        navigationTitle = steps.first(where: { $0.tag == step })?.title ?? ""
        buttonTitle = isLastStep ? Strings.signupButton : Strings.signupNextButton
    }
    
    func completeSignup() {
        auth.isSigninUp = false
    }
    
    func nextStep() {
        guard validateFields() else { return }
        
        let isLastStep: Bool = currentStep == steps.last?.tag
        
        if !isLastStep {
            currentStep += 1
        } else {
            createAccout()
        }
    }
    
    func previousStep() {
        if self.currentStep > 0 {
            self.currentStep -= 1
        }
    }
}
