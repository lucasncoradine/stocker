//
//  Messages.swift
//  stockProject
//
//  Created by Lucas Negreiros Coradine on 18/07/22.
//

import Foundation

typealias Strings = LocalizedStrings

final class LocalizedStrings {
    // MARK: - Buttons
    static let close = "Fechar"
    static let cancel = "Cancelar"
    static let save = "Salvar"
    
    // MARK: - Fields
    static let name = "Nome"
    static let email = "Email"
    static let password = "Senha"
    static let description = "Descrição"
    static let expireDate = "Vencimento"
    static let confirmPassword = "Confirmar senha"
 
    // TODO: Create a separate file for errors
    // MARK: - Errors
    static let invalidEmail = "Email inválido"
    static let passwordsDontMatch = "As senhas não são iguais"
    static let requiredField = "Campo obrigatório"
    
    // MARK: - LoginView
    static let forgotPassword = "Esqueci minha senha"
    static let loginButton = "Entrar"
    
    // MARK: - SignupView
    static let signupButton = "Criar conta"
    static let signupMessage = "Ainda não possui uma conta?"
    static let signupMessageCreate = "Crie uma aqui!"
    static let signupNavigationTitle = "Nova conta"
    
    // MARK: - EditListView
    static let editListNavigationTitle = "Nova lista"
    static let editListFieldName = "Nome da lista"
    
    // MARK: - EditItemView
    static let editItemNavigationTitle = "Novo item"
}
