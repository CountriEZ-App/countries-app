//
//  LoginViewModel.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 12/03/25.
//
import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore


protocol LoginViewModelDelegate: AnyObject {
    func didReceiveError(message: String)
}

class LoginViewModel {
    
    weak var delegate: LoginViewModelDelegate?
    
    func signUpUser (email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if result != nil, error == nil{
                completion(true)
            } else {
                completion(false)
                if let error = error {
                    let errorMessage = CostumEmailsErrors.codeError(error)
                    self?.delegate?.didReceiveError(message: errorMessage.errorMessage)
                }
            }
        }
    }
    
    func logInUser (email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result , error in
            if result != nil , error == nil {
                completion(true)
            } else {
                completion(false)
                if let error = error {
                    let errorMessage = CostumEmailsErrors.codeError(error)
                    self?.delegate?.didReceiveError(message: errorMessage.errorMessage)
                }
                
            }
        }
    }
    
    
    func logInUserGoogle (result: GIDSignInResult?, error: Error?, completion: @escaping (Bool) -> Void) {
        
        if let error = error {
            print("Error en Google Sign-In: \(error.localizedDescription)")
            completion(false)
            return
        }
        
        guard let user = result?.user, let idToken = user.idToken?.tokenString else {
            completion(false)
            print("No se pudo obtener el ID Token de Google")
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
        
        Auth.auth().signIn(with: credential) { [weak self] result, error in
            if result != nil , error == nil {
                completion(true)
            } else {
                completion(false)
                if let error = error {
                    let errorMessage = CostumEmailsErrors.codeError(error)
                    self?.delegate?.didReceiveError(message: errorMessage.errorMessage)
                }
            }
        }
        
    }
}
