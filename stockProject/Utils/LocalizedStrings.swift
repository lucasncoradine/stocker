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
    static let back = "Voltar"
    static let share = "Compartilhar"
    static let new = "Novo"
    static let rename = "Renomear"
    
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
    
    // MARK: - ListsView
    static let listsEmpty = "Sem listas"
    static let listsTitle = "Listas"
    static let listsNew = "Nova lista"
    static let listsSharedSection = "Compartilhadas comigo"
    static let listMenuScanQrCode = "Acessar lista"
    static let listsMyLists = "Minhas listas"
    
    // MARK: - LoginView
    static let forgotPassword = "Esqueci minha senha"
    static let loginButton = "Entrar"
    
    // MARK: - SignupView
    static let signupButton = "Criar conta"
    static let signupNextButton = "Próximo"
    static let signupMessage = "Ainda não possui uma conta?"
    static let signupMessageCreate = "Crie uma aqui!"
    static let signupWelcome = "Bem vindo!"
    static let signupStartTitle = "Vamos começar"
    static let signupPasswordTitle = "Criar senha"
    static let signupSuccessMessage = "Sua conta foi criada com sucesso!"
    static let signupAccessButton = "Acessar o App"
    
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
    static let listItemsNew = "Novo item"
    
    // MARK: - ShoppingListView
    static let shoppingListEmpty = "Lista de compras vazia"
    static let shoppingListTitle = "Compras"
    static let shoppingListClear = "Apagar lista"
    static let shoppingListComplete = "Concluir lista"
    static let shoppingListConfirmClearMessage = "Tem certeza que deseja apagar a lista de compras?"
    static let shoppingListConfirmClearButton = "Limpar"
    
    // MARK: - PasswordRecoverView
    static let passwordRecoverLabel = "Informe o email cadastrado"
    static let passwordRecoverButtonRecover = "Recuperar senha"
    static let passwordRecoverEmailSent = "Email enviado!"
    static let passwordRecoverMessage = "Siga as instruções enviadas para o seu email para prosseguir com a recuperação de senha."
    static let passwordRecoverButtonBack = "Voltar para o login"
    
    // MARK: - Scanner
    static let scannerText = "Escaneie o QR Code"
    static let scannerInvalidQrCode = "QR Code inválido"
    static let scannerPermissionDeniedMessage = "O aplicativo não possui permissão para acessar a câmera!"
    static let scannerOpenSettingsButton = "Permitir acesso"
}
