//
//  SearchViewController.swift
//  PruebaCountiEZ
//
//  Created by Zelene Yosseline Isayana Montes Cantero on 11/03/25.
//

import UIKit
import Lottie

class SearchViewController: UIViewController {

    
    private let searchViewModel = SearchViewModel()

    
    var animationLottie: LottieAnimationView!
    
    var searchDataCountry: [DataCountries] = []
    var dataCountries: [DataCountries] = []
    var isSearch: Bool = false
    var selectedURL: String = ""
    var typeSearch: String = ""
    var tagFilter: Int = 0

    //Cuidar memoria por imagenes
    var imageCache = NSCache<NSString, UIImage>()

    
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
    
    
    private lazy var buttonSearchName: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.bordered()
        configuration.title = "Name"

        configuration.background.backgroundColor = .systemMint
        configuration.baseForegroundColor = .black

        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchName), for: .touchUpInside)
        button.configuration = configuration

        button.tag = 0

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

        button.tag = 1

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

        button.tag = 2

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

        button.tag = 3

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
    
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constraints()
        view.backgroundColor = .systemBackground

        //Search Bar
        searchBar.delegate = self
        
        // Table View
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CellSearchViewController.self, forCellReuseIdentifier: "cell")
        
        buttonSearchName.isSelected = true
        
        // Peticion URL
        searchViewModel.fetchCountries { data, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {return }
                self.dataCountries = data
                self.tableView.reloadData()
            }
        }
    }
    
    //    MARK: - Constraints
    func setupLabels(){

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
    

    func setupButtons(){
        [buttonSearchName, buttonSearchLanguage, buttonSearchCapital, buttonSearchRegion].forEach(view.addSubview)
        
        NSLayoutConstraint.activate([

            buttonSearchName.topAnchor.constraint(equalTo: labelDetail.bottomAnchor, constant: 20),
            buttonSearchName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 110),

            buttonSearchLanguage.topAnchor.constraint(equalTo: labelDetail.bottomAnchor, constant: 20),
            buttonSearchLanguage.leadingAnchor.constraint(equalTo: buttonSearchName.trailingAnchor, constant: 10),
            
            buttonSearchCapital.topAnchor.constraint(equalTo: buttonSearchName.bottomAnchor, constant: 10),
            buttonSearchCapital.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
            
            buttonSearchRegion.topAnchor.constraint(equalTo: buttonSearchName.bottomAnchor, constant: 10),

            buttonSearchRegion.leadingAnchor.constraint(equalTo: buttonSearchCapital.trailingAnchor, constant: 10),
            
        ])
    }
    

    func setupSearchBar(){

        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: buttonSearchRegion.bottomAnchor, constant: 30),
            searchBar.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])

    }
    
    func setupAnimationLottie(){

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
        
    }
    
    func setupTableView(){

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

        setupLabels()
        setupButtons()
        setupSearchBar()
        setupAnimationLottie()
        setupTableView()
    }
    
    func resetButtonColors() {
        [buttonSearchName, buttonSearchLanguage, buttonSearchCapital, buttonSearchRegion].forEach {
            var config = $0.configuration
            config?.background.backgroundColor = .secondarySystemFill
            config?.baseForegroundColor = .link
            $0.configuration = config
        }
    }
    
    
    // MARK: - Botones de búsqueda

    @objc func searchName() {
        resetButtonColors()
        var config = buttonSearchName.configuration
        config?.background.backgroundColor = .systemMint
        config?.baseForegroundColor = .black
        buttonSearchName.configuration = config
        tagFilter = buttonSearchName.tag
    }
    
    @objc func searchLanguage() {
        resetButtonColors()
        var config = buttonSearchLanguage.configuration
        config?.background.backgroundColor = .systemMint
        config?.baseForegroundColor = .black
        buttonSearchLanguage.configuration = config
        tagFilter = buttonSearchLanguage.tag
    }
    
    @objc func searchCapital() {
        resetButtonColors()
        var config = buttonSearchCapital.configuration
        config?.background.backgroundColor = .systemMint
        config?.baseForegroundColor = .black
        buttonSearchCapital.configuration = config
        tagFilter = buttonSearchCapital.tag
    }
    
    @objc func searchRegion() {
        resetButtonColors()
        var config = buttonSearchRegion.configuration
        config?.background.backgroundColor = .systemMint
        config?.baseForegroundColor = .black
        buttonSearchRegion.configuration = config
        tagFilter = buttonSearchRegion.tag
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

            print("\nUsuario Buscando")
            tableView.isHidden = false
            animationLottie.isHidden = true
            
            searchDataCountry = searchViewModel.filterData(data: dataCountries, tag: tagFilter, text: searchText)
 

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

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CellSearchViewController else {
            return UITableViewCell()
        }
        
        let country = isSearch ? searchDataCountry[indexPath.row] : dataCountries[indexPath.row]
        cell.labelCountry.text = country.name.nameCountry
        
        let imageURLString = country.flags.nameImagePNG
        
        // Si la imagen ya está en caché, la usamos
        if let cachedImage = imageCache.object(forKey: imageURLString as NSString) {
            cell.imageCountry.image = cachedImage
        } else {
            cell.imageCountry.image = nil // Evita imágenes incorrectas en celdas recicladas
            
            if let imageUrl = URL(string: imageURLString) {
                URLSession.shared.dataTask(with: imageUrl) { [weak self] data, _, _ in
                    guard let self = self, let data = data, let image = UIImage(data: data) else { return }
                    
                    self.imageCache.setObject(image, forKey: imageURLString as NSString)
                    
                    DispatchQueue.main.async {
                        // Verifica que la celda sigue siendo la misma antes de actualizar la imagen
                        if let updatedCell = tableView.cellForRow(at: indexPath) as? CellSearchViewController {
                            updatedCell.imageCountry.image = image

                        }
                    }
                }.resume()
            }

        }
        
        return cell
    }
    

}

