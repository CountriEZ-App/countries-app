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
    case userAlreadyExist
    case invalidCredential
    case networkError
    case weakPassword
    case unknown(Error)
    
    var errorMessage: String {
        switch self {
            
        case .invalidEmail:
            return "Correo electronico invalido"
        case .userAlreadyExist:
            return "Usuario ya registrado"
        case .invalidCredential:
            return "Usuario o contraseña incorrectas"
        case .networkError:
            return "Error de conexión. Revisa tu internet"
        case .weakPassword:
            return "La contraseña es demasiado débil (más de 6 caracteres)"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
    
    static func codeError (_ error: Error) -> CostumEmailsErrors {
        let nsError = error as NSError
//        print(AuthErrorCode.wrongPassword.rawValue) //17009
//        print(AuthErrorCode.userNotFound.rawValue) //17011
        
        switch nsError.code {
        case AuthErrorCode.invalidEmail.rawValue:
            return .invalidEmail
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return .userAlreadyExist
        case AuthErrorCode.invalidCredential.rawValue: // Nuevo caso
            return .invalidCredential
        case AuthErrorCode.networkError.rawValue:
            return .networkError
        case AuthErrorCode.weakPassword.rawValue:
            return .weakPassword
        default:
            return .unknown(error)
        }
    }
    
}
