//
//  SearchViewController.swift
//  PruebaCountiEZ
//
//  Created by Zelene Yosseline Isayana Montes Cantero on 11/03/25.
//

import UIKit
import Lottie

class SearchViewController: UIViewController {
    // ALL https://restcountries.com/v3.1/all
    // NAME https://restcountries.com/v3.1/name/deutschland
    // language  https://restcountries.com/v3.1/lang/spanish
    // capital https://restcountries.com/v3.1/capital/tallin
    // region https://restcountries.com/v3.1/region/europe
    
    var animationLottie: LottieAnimationView!
    
    var searchDataCountry: [DataCountries] = []
    var dataCountries: [DataCountries] = []
    var arrayDataCountry: [DataCountries] = []
    var isSearch: Bool = false
    var selectedURL: String = ""
    var typeSearch: String = ""
    
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Search Country"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelDetail: UILabel = {
        let label = UILabel()
        label.text = "Selecciona una opcion de busqueda"
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buttonSearchAll: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.bordered()
        configuration.title = "All Countries"
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchAllCountry), for: .touchUpInside)
        button.configuration = configuration
        return button
    }()
    
    private lazy var buttonSearchName: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.bordered()
        configuration.title = "Name"
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchName), for: .touchUpInside)
        button.configuration = configuration
        return button
    }()
    
    private lazy var buttonSearchLanguage: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.bordered()
        configuration.title = "Language"
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchLanguage), for: .touchUpInside)
        button.configuration = configuration
        return button
    }()
    
    private lazy var buttonSearchCapital: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.bordered()
        configuration.title = "Capital"
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchCapital), for: .touchUpInside)
        button.configuration = configuration
        return button
    }()
    
    private lazy var buttonSearchRegion: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.bordered()
        configuration.title = "Region"
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchRegion), for: .touchUpInside)
        button.configuration = configuration
        return button
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constraints()
        
        //Search Bar
        searchBar.delegate = self
        
        // Table View
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CellSearchViewController.self, forCellReuseIdentifier: "cell")
        
        // Peticion URL
        petticionURL()
        
        view.backgroundColor = .systemBackground
    }
    
//    MARK: - Constraints
    func constraintLabel(){
        [label, labelDetail].forEach(view.addSubview)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            labelDetail.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
            labelDetail.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            labelDetail.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func constraintButton(){
        [buttonSearchAll, buttonSearchName, buttonSearchLanguage, buttonSearchCapital, buttonSearchRegion].forEach(view.addSubview)
        
        NSLayoutConstraint.activate([
            buttonSearchAll.topAnchor.constraint(equalTo: labelDetail.bottomAnchor, constant: 20),
            buttonSearchAll.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            
            
            buttonSearchName.topAnchor.constraint(equalTo: labelDetail.bottomAnchor, constant: 20),
            buttonSearchName.leadingAnchor.constraint(equalTo: buttonSearchAll.trailingAnchor, constant: 10),
            
            
            buttonSearchLanguage.topAnchor.constraint(equalTo: labelDetail.bottomAnchor, constant: 20),
            buttonSearchLanguage.leadingAnchor.constraint(equalTo: buttonSearchName.trailingAnchor, constant: 10),
            
            
            buttonSearchCapital.topAnchor.constraint(equalTo: buttonSearchAll.bottomAnchor, constant: 10),
            buttonSearchCapital.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
            
            
            buttonSearchRegion.topAnchor.constraint(equalTo: buttonSearchAll.bottomAnchor, constant: 10),
            buttonSearchRegion.leadingAnchor.constraint(equalTo: buttonSearchCapital.trailingAnchor, constant: 10),
            
        ])
    }
    
    func constraintSearchBar(){
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: buttonSearchRegion.bottomAnchor, constant: 30),
            searchBar.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
        
        searchBar.isHidden = true
    }
    
    func constraintAnimationLottie(){
        animationLottie = LottieAnimationView(name: "AnimationWorld")
        animationLottie.contentMode = .scaleAspectFit
        animationLottie.loopMode = .loop
        animationLottie.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationLottie)
        animationLottie.play()
        
        NSLayoutConstraint.activate([
            animationLottie.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationLottie.topAnchor.constraint(equalTo: view.topAnchor, constant: 450),
            
            animationLottie.widthAnchor.constraint(equalToConstant: 200),
            animationLottie.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        animationLottie.isHidden = false
    }
    
    func constraintTableView(){
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
        ])
        
        tableView.isHidden = true
    }
    
    func constraints(){
        constraintLabel()
        constraintButton()
        constraintSearchBar()
        constraintAnimationLottie()
        constraintTableView()
    }
    
    func resetButtonColors() {
            [buttonSearchAll, buttonSearchName, buttonSearchLanguage, buttonSearchCapital, buttonSearchRegion].forEach {
                $0.backgroundColor = .systemBackground
            }
        }
//        MARK: - Alerta
    func alertTextField(type: String, completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: "Introduce el/la \(type) del país", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Ingresa aquí el/la \(type) del país"
        }
        
        let aceptarAction = UIAlertAction(title: "Aceptar", style: .default) { _ in
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                completion(text)
            }
        }
        
        alert.addAction(aceptarAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        present(alert, animated: true)
    }
        
    // MARK: - Botones de búsqueda
        @objc func searchAllCountry() {
            resetButtonColors()
            buttonSearchAll.backgroundColor = .systemMint
            selectedURL = "https://restcountries.com/v3.1/all"
            petticionURL()
            searchBar.isHidden = false

        }

        @objc func searchName() {
            resetButtonColors()
            buttonSearchName.backgroundColor = .systemMint
            
            alertTextField(type: "nombre") { userInput in
                self.selectedURL = "https://restcountries.com/v3.1/name/\(userInput)"
                self.petticionURL()
            }
        }

    @objc func searchLanguage() {
        resetButtonColors()
        buttonSearchLanguage.backgroundColor = .systemMint
        
        alertTextField(type: "idioma") { userInput in
            self.selectedURL = "https://restcountries.com/v3.1/lang/\(userInput.lowercased())"
            self.petticionURL()
        }
        searchBar.isHidden = true
        animationLottie.isHidden = true
        tableView.isHidden = false
    }

    @objc func searchCapital() {
        resetButtonColors()
        buttonSearchCapital.backgroundColor = .systemMint
        
        alertTextField(type: "capital") { userInput in
            self.selectedURL = "https://restcountries.com/v3.1/capital/\(userInput)"
            self.petticionURL()
        }
        
        searchBar.isHidden = true
        animationLottie.isHidden = true
        tableView.isHidden = false
    }

        @objc func searchRegion() {
            resetButtonColors()
            buttonSearchRegion.backgroundColor = .systemMint
            
            alertTextField(type: "región") { userInput in
                self.selectedURL = "https://restcountries.com/v3.1/region/\(userInput.lowercased())"
                self.petticionURL()
            }
            
            searchBar.isHidden = true
            animationLottie.isHidden = true
            tableView.isHidden = false
        }

    // MARK: - Petición a la API
        func petticionURL() {
            guard let url = URL(string: selectedURL) else { return }

            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else { return }
                
                do {
                    let dataCountry = try JSONDecoder().decode([DataCountries].self, from: data)
                    DispatchQueue.main.async {
                        self.dataCountries = dataCountry
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error al decodificar:", error)
                }
            }.resume()
        }
    }


// MARK: - Search Bar
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            isSearch = false
            tableView.isHidden = true
            animationLottie.isHidden = false
            
            
        }else{
            isSearch = true
            print("Usuario Buscando")
            tableView.isHidden = false
            animationLottie.isHidden = true
            
            searchDataCountry = dataCountries.filter { country in
                return country.name.nameCountry.lowercased().hasPrefix(searchText.lowercased())
            }
            tableView.reloadData()
        }
    }
}


// MARK: - Table View

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isSearch ? searchDataCountry.count : dataCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellSearchViewController
        
        if isSearch == true{
            cell.labelCountry.text = searchDataCountry[indexPath.row].name.nameCountry
            
            if let imageUrl = URL(string: searchDataCountry[indexPath.row].flags.nameImagePNG) {
                URLSession.shared.dataTask(with: imageUrl) { data, _ , error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.imageCountry.image = image
                        }
                    }
                }.resume()
            }
            
        }else{
            cell.labelCountry.text = dataCountries[indexPath.row].name.nameCountry
            
            if let imageUrl = URL(string: dataCountries[indexPath.row].flags.nameImagePNG) {
                URLSession.shared.dataTask(with: imageUrl) { data, _ , error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.imageCountry.image = image
                        }
                    }
                }.resume()
            }
            
        }
        return cell
        
    }
}

