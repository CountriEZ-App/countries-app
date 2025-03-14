//
//  LoginViewController.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 11/03/25.
//

import UIKit

class LoginViewController: UIViewController, LoginViewModelDelegate {
    
    private let viewModelLogin = LoginViewModel()
    
    private lazy var nameApp: UILabel = {
        let label = UILabel()
        label.text = "COUNTRIEZ"
        label.textAlignment = .center
        label.textColor = .systemMint
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.backgroundColor = .tertiarySystemGroupedBackground
        
        return label
    }()
    
    private lazy var textFieldEmail: UITextField = {
        let textField = UITextField()
        textField.placeholder = " E-mail"
        textField.backgroundColor = .white
        textField.font = .systemFont(ofSize: 15)
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.autocapitalizationType = .none
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
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
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
        config.title = " Gmail"
        config.baseForegroundColor = .black
        
        button.configuration = config
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private lazy var appleButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.title = " Apple"
        config.image = UIImage(systemName: "apple.logo")
        config.baseForegroundColor = .white
        
        button.configuration = config
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 60

        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var textFieldsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 15
        
        return stack
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8
    
        return stack
    }()
    
    private lazy var buttonsLogSignStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 20
    
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
    }

    
    func setUpView () {
        view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 130),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -205),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        mainStack.addArrangedSubview(nameApp)
        mainStack.addArrangedSubview(setUptextFieldsStacks())
        mainStack.addArrangedSubview(setUpButtonsStack())
        
    }
    
    func setUptextFieldsStacks () -> UIStackView {
        textFieldsStack.addArrangedSubview(textFieldEmail)
        NSLayoutConstraint.activate([
            textFieldEmail.leadingAnchor.constraint(equalTo: textFieldsStack.leadingAnchor, constant: 12),
            textFieldEmail.trailingAnchor.constraint(equalTo: textFieldsStack.trailingAnchor, constant: -12)
        ])
        
        
        textFieldsStack.addArrangedSubview(textFieldPassword)
        NSLayoutConstraint.activate([
            textFieldPassword.leadingAnchor.constraint(equalTo: textFieldsStack.leadingAnchor, constant: 12),
            textFieldsStack.trailingAnchor.constraint(equalTo: textFieldsStack.trailingAnchor, constant: -12)
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
        buttonsStack.addArrangedSubview(appleButton)
        
        return buttonsStack
    }
    
    @objc
    func didTapSignUp () {
        guard let emailUser = textFieldEmail.text, !emailUser.isEmpty, let passwordUser = textFieldPassword.text, !passwordUser.isEmpty else { return }
        
        viewModelLogin.singUpUser(email: emailUser, password: passwordUser)
        view.endEditing(true)
        textFieldEmail.text = ""
        textFieldPassword.text = ""
    }
    
    @objc
    func didTapLogin () {
        guard let emailUser = textFieldEmail.text, !emailUser.isEmpty, let passwordUser = textFieldPassword.text, !passwordUser.isEmpty else { return }
        
        viewModelLogin.logInUser(email: emailUser, password: passwordUser) { sucsses in
            DispatchQueue.main.async {
                if sucsses {
                    self.view.endEditing(true)
                    self.textFieldEmail.text = ""
                    self.textFieldPassword.text = ""
                    
                    let tabBarVC = TabBarViewController()
                    self.navigationController?.pushViewController(tabBarVC, animated: true)
                }
            }
        }
        
    }
    
    @objc
    func didTapGmail () {
        
    }
    
    @objc
    func didTapApple () {
        
    }
    
    func didReceiveError(message: String) {
        alertMessageError(message: message)
    }
    
    func alertMessageError (message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    

}

