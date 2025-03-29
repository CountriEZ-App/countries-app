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
        label.textColor = Theme.textColor
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelDetail: UILabel = {
        let label = UILabel()
        label.text = "Selecciona una opcion de busqueda"
        label.textColor = Theme.textColor
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var buttonSearchName: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.bordered()
        configuration.title = "Name"
        configuration.baseForegroundColor = Theme.textColor
        configuration.background.backgroundColor = Theme.buttonsColor
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
        configuration.baseForegroundColor = Theme.textColor
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
        configuration.baseForegroundColor = Theme.textColor
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
        configuration.baseForegroundColor = Theme.textColor
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchRegion), for: .touchUpInside)
        button.configuration = configuration

        button.tag = 3

        return button
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.backgroundColor = Theme.backgroundColor
        searchBar.layer.cornerRadius = 12
        searchBar.layer.masksToBounds = true
        searchBar.barTintColor = Theme.buttonsColor
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
        
        view.backgroundColor = Theme.backgroundColor
        tableView.backgroundColor = Theme.backgroundColor

        
        navigationController?.setNavigationBarHidden(true, animated: true)
        //Search Bar
        searchBar.delegate = self
        
        // Table View
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CellSearchViewController.self, forCellReuseIdentifier: "cell")
        
        
        // Peticion URL
        APIService.shared.fetchCountries { data, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {return }
                self.dataCountries = data
                self.tableView.reloadData()
            }
        }
        
        navigationItem.backButtonTitle = "Buscador"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.rightBarButtonItem?.isHidden = false
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
        
        let buttonStackH = UIStackView(arrangedSubviews: [buttonSearchName, buttonSearchLanguage])
        buttonStackH.axis = .horizontal
        buttonStackH.spacing = 10
        buttonStackH.distribution = .fillProportionally
        
        let buttonStackH2 = UIStackView(arrangedSubviews: [buttonSearchCapital, buttonSearchRegion])
        buttonStackH2.axis = .horizontal
        buttonStackH2.spacing = 10
        buttonStackH2.distribution = .fillProportionally
        
        let buttonStackView = UIStackView(arrangedSubviews: [buttonStackH, buttonStackH2])
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 10
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([

            buttonStackView.topAnchor.constraint(equalTo: labelDetail.bottomAnchor, constant: 20),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)

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
            config?.baseForegroundColor = Theme.textColor
            $0.configuration = config
        }
    }
    
    
    
    // MARK: - Botones de búsqueda

    @objc func searchName() {
        configButtonSelected(button: buttonSearchName)
    }
    
    @objc func searchLanguage() {
        configButtonSelected(button: buttonSearchLanguage)
    }
    
    @objc func searchCapital() {
        configButtonSelected(button: buttonSearchCapital)
    }
    
    @objc func searchRegion() {
        configButtonSelected(button: buttonSearchRegion)
    }
    
    func configButtonSelected(button: UIButton) {
        resetButtonColors()
        var config = button.configuration
        config?.background.backgroundColor = Theme.buttonsColor
        config?.baseForegroundColor = .black
        button.configuration = config
        tagFilter = button.tag
        
        // Actualización de resultados al cambiar de botón
        if let searchText = searchBar.text, !searchText.isEmpty {
            isSearch = true
            searchDataCountry = searchViewModel.filterData(data: dataCountries, tag: tagFilter, text: searchText)
            tableView.reloadData()
        }
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
        cell.backgroundColor = Theme.backgroundColor
        
        let country = isSearch ? searchDataCountry[indexPath.row] : dataCountries[indexPath.row]
        cell.labelCountry.text = country.name.nameCountry
        
        let imageURLString = country.flags.nameImagePNG
        
        // Si la imagen ya está en caché, la usamos
        if let cachedImage = imageCache.object(forKey: imageURLString as NSString) {
            cell.imageCountry.image = cachedImage
        } else {
            cell.imageCountry.image = nil // Evita imágenes incorrectas en celdas recicladas
            
            APIService.shared.fetchImageFlag(urlImage: imageURLString) { [weak self] image, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    if let updatedCell = tableView.cellForRow(at: indexPath) as? CellSearchViewController {
                        if let image = image {
                            self.imageCache.setObject(image, forKey: imageURLString as NSString)
                            updatedCell.imageCountry.image = image
                        } else {
                            // Imagen por defecto si falla la descarga
                            updatedCell.imageCountry.image = UIImage(systemName: "flag.slash")
                        }
                    }
                }
            }
            
        }
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let country = searchDataCountry[indexPath.row]
        let detailCountryVC = DetailCountryViewController(country: country)
        navigationController?.pushViewController(detailCountryVC, animated: true)
    }
    

}

