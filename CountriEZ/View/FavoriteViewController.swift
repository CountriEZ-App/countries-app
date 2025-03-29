//
//  FavoriteViewController.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 11/03/25.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    let favoriteViewModel = FavoriteViewModel()

    private var tableFavorite: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.backgroundColor
        tableFavorite.backgroundColor = Theme.backgroundColor
        
        navigationItem.title = "Favorites Countries"
        //TableView
        tableFavorite.delegate = self
        tableFavorite.dataSource = self
        tableFavorite.register(UITableViewCell.self, forCellReuseIdentifier: favoriteViewModel.favoriteCell)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name("FavoritesUpdated"), object: nil)
          
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func setupView () {
        view.addSubview(tableFavorite)
        
        NSLayoutConstraint.activate([
            tableFavorite.topAnchor.constraint(equalTo: view.topAnchor),
            tableFavorite.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableFavorite.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tableFavorite.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
   
    @objc
    func reloadData(){
        favoriteViewModel.countriesFavorites = favoriteViewModel.loadCountriesToTable()
        tableFavorite.reloadData()
    }

}


//MARK: - TableView
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteViewModel.numCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: favoriteViewModel.favoriteCell, for: indexPath)
        cell.backgroundColor = Theme.backgroundColor
        var content = cell.defaultContentConfiguration()
        content.textProperties.color = Theme.textColor
        content.text = favoriteViewModel.countriesFavorites[indexPath.row].name
        
        favoriteViewModel.fetchImageFavorite(index: indexPath.row, completion: { image, error in
            DispatchQueue.main.async {
                if let image = image {
                    content.image = image
                } else {
                    content.image = UIImage(systemName: "photo") // Imagen por defecto
                }
                cell.contentConfiguration = content
            }
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let countryName = favoriteViewModel.countriesFavorites[indexPath.row].name
        let swipeAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
            if let name = countryName {
                self.favoriteViewModel.deleteCountry(name: name)
                completion(true)
            }
        }
        
        swipeAction.backgroundColor = .red
        swipeAction.image = UIImage(systemName: "eraser")
        
        return UISwipeActionsConfiguration(actions: [swipeAction])
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let countryName = favoriteViewModel.countriesFavorites[indexPath.row].name
        
        guard let name = countryName else {return}
        favoriteViewModel.fetchDataCountryFavorite(name: name) { data, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error al obtener datos del país: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("Datos no disponibles.")
                    return
                }
                
                let detailCountryVC = DetailCountryViewController(country: data)
                self.navigationController?.pushViewController(detailCountryVC, animated: true)
                
            }
            
        }
    }

}
