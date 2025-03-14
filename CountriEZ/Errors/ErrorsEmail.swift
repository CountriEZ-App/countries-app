//
//  ErrorsEmail.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 13/03/25.
//

import UIKit
import FirebaseAuth

enum CostumEmailsErrors: Error {
    case invalidEmail
//    case emailNotFaound
//    case invalidPassword
    case userAlreadyExist
    case unknown(Error)
    
    var errorMessage: String {
        switch self {
            
        case .invalidEmail:
            return "Correo electronico invalido"
//        case .emailNotFaound:
//            return "Usuario no encontrado"
//        case .invalidPassword:
//            return "Contraseña incorrecta"
        case .userAlreadyExist:
            return "Usuario ya registrado"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
    
    static func codeError (_ error: Error) -> CostumEmailsErrors {
        let nsError = error as NSError
        switch nsError.code {
        case AuthErrorCode.invalidEmail.rawValue:
            return .invalidEmail
//        case AuthErrorCode.userNotFound.rawValue:
//            return .emailNotFaound
//        case AuthErrorCode.wrongPassword.rawValue:
//            return .invalidPassword
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return .userAlreadyExist
        default:
            return .unknown(error)
        }
    }
    
}
