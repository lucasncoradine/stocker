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
    static let remove = "Remover"
    static let edit = "Editar"
    static let select = "Selecionar"
    static let selectAll = "Selecionar tudo"
    static let addToShopping = "Comprar"
    static let ok = "OK"
    static let done = "Feito"
    
    // MARK: - Fields
    static let name = "Nome"
    static let email = "Email"
    static let password = "Senha"
    static let description = "Descrição"
    static let expireDate = "Vencimento"
    static let confirmPassword = "Confirmar senha"
    static let shoppingList = "Lista de compras"
 
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
    static let signupNextButton = "Próximo"
    static let signupMessage = "Ainda não possui uma conta?"
    static let signupMessageCreate = "Crie uma aqui!"
    static let signupNavigationTitle = "Vamos começar!"
    
    // MARK: - EditListView
    static let editListNavigationTitle = "Nova lista"
    static let editListFieldName = "Nome da lista"
    
    // MARK: - EditItemView
    static let editItemNavigationTitle = "Novo item"
    
    // MARK: - ListItemsView
    static let selectedItemsText = "Selecionado"
    static let selectedItemsTextPlural = "Selecionados"
    static let listItemsRemoveSelectedMessage = "Tem certeza que deseja remover os itens selecionados"
    static let listItemsEmpty = "Sem itens"
    static let listItemsAddedToast = "Adicionado à lista de compras"
}
