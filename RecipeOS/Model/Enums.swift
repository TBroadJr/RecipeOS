//
//  Field.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/17/22.
//

import Foundation

enum Field: Hashable {
    case email
    case password
}

enum RegisterType {
    case signIn
    case signUp
    case reauthenticate
}

enum Tab: String {
    case discover
    case create
    case favorite
}

enum CompletionResult {
    case success
    case failure
}
