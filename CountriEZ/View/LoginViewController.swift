//
//  LoginViewController.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 11/03/25.
//

import UIKit
import FirebaseCore
import GoogleSignIn


class LoginViewController: UIViewController, LoginViewModelDelegate {
    
    private let viewModelLogin = LoginViewModel()
    
    private lazy var nameApp: UILabel = {
        let label = UILabel()
        label.text = "COUNTRIEZ"
        label.textAlignment = .center
        label.textColor = .systemMint
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.backgroundColor = .tertiarySystemGroupedBackground
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var textFieldEmail: UITextField = {
        let textField = UITextField()
        textField.placeholder = " E-mail"
        textField.backgroundColor = .white
        textField.font = .systemFont(ofSize: 15)
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.autocapitalizationType = .none //Empiece con minusculas
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var textFieldPassword: UITextField = {
        let textField = UITextField()
        textField.placeholder = " Password"
        textField.backgroundColor = .white
        textField.font = .systemFont(ofSize: 15)
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.autocapitalizationType = .none //Empiece con minusculas
        textField.isSecureTextEntry = true //Esconde la contraseña
        
        textField.textContentType = .oneTimeCode // Evita la sugerencia de contraseñas seguras
        textField.autocorrectionType = .no
        textField.smartInsertDeleteType = .no
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.title = "Sign Up"
        config.baseForegroundColor = .black
        
        button.configuration = config
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.title = "Log In"
        config.baseForegroundColor = .black
        
        button.configuration = config
        button.backgroundColor = .systemMint
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var gmailButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.title = " con Google"
        config.baseForegroundColor = .black
        
        if let originalImage = UIImage(named: "google") {
            let resizedImage = UIGraphicsImageRenderer(size: CGSize(width: 24, height: 24)).image { _ in
                originalImage.draw(in: CGRect(origin: .zero, size: CGSize(width: 24, height: 24)))
            }
            config.image = resizedImage
        }

        button.configuration = config
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapGmail), for: .touchUpInside)
        
        return button
    }()
    
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 40
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var textFieldsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
    
        return stack
    }()
    
    private lazy var buttonsLogSignStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tertiarySystemGroupedBackground
        viewModelLogin.delegate = self
        setUpView()

        let defaults = UserDefaults.standard
        if let email = defaults.value(forKey: "email") as? String,
           let proveedorString = defaults.value(forKey: "proveedor") as? String {
            let proveedor: ProviderUser = (proveedorString == "google") ? .google : .normal
            let tabBarVC = TabBarViewController(provedor: proveedor, email: email)
            navigationController?.pushViewController(tabBarVC, animated: true)
        }
        

    }

    
    func setUpView() {
        view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 130),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        let bottomConstraint = mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -260)
        bottomConstraint.priority = .defaultHigh
        bottomConstraint.isActive = true
        
        mainStack.addArrangedSubview(nameApp)
        
        mainStack.addArrangedSubview(setUptextFieldsStacks())
        mainStack.addArrangedSubview(setUpButtonsStack())
    }
    
    
    func setUptextFieldsStacks() -> UIStackView {
        textFieldsStack.addArrangedSubview(textFieldEmail)
        textFieldsStack.addArrangedSubview(textFieldPassword)
        
        NSLayoutConstraint.activate([
            textFieldEmail.heightAnchor.constraint(equalToConstant: 45),
            textFieldPassword.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        return textFieldsStack
    }
    
    func setUpButtonsStack () -> UIStackView {
        buttonsLogSignStack.addArrangedSubview(signInButton)
        NSLayoutConstraint.activate([
            signInButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        buttonsLogSignStack.addArrangedSubview(logInButton)
        buttonsStack.addArrangedSubview(buttonsLogSignStack)
        buttonsStack.addArrangedSubview(gmailButton)
        
        return buttonsStack
    }
    
    
    @objc
    private func didTapSignUp () {
        guard let emailUser = textFieldEmail.text, !emailUser.isEmpty, let passwordUser = textFieldPassword.text, !passwordUser.isEmpty else { return }
        
        viewModelLogin.signUpUser(email: emailUser, password: passwordUser){sucsses in
            DispatchQueue.main.async {
                if sucsses {
                    self.view.endEditing(true)
                    self.textFieldEmail.text = ""
                    self.textFieldPassword.text = ""
                }
            }
            
        }
        
    }
    
    @objc
    private func didTapLogin () {
        guard let emailUser = textFieldEmail.text, !emailUser.isEmpty, let passwordUser = textFieldPassword.text, !passwordUser.isEmpty else { return }
        
        viewModelLogin.logInUser(email: emailUser, password: passwordUser) { sucsses in
            DispatchQueue.main.async {
                if sucsses {
                    self.view.endEditing(true)
                    self.textFieldEmail.text = ""
                    self.textFieldPassword.text = ""

                    let tabBarVC = TabBarViewController(provedor: .normal, email: emailUser)
                    self.navigationController?.pushViewController(tabBarVC, animated: true)
                }
            }
        }
        
    }
    
    @objc
    private func didTapGmail () {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            guard let self = self else { return }
            
            self.viewModelLogin.logInUserGoogle(result: result, error: error) { success in
                if success {
                    let email = result?.user.profile?.email ?? ""
                    let tabBarVC = TabBarViewController(provedor: .google, email: email)
                    self.navigationController?.pushViewController(tabBarVC, animated: true)
                }
            }
        }
    }
    
    
    func didReceiveError(message: String) {
        alertMessageError(message: message)
    }
    
    private func alertMessageError (message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    

}

