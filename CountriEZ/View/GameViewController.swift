//
//  GameViewController.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 11/03/25.
//

import UIKit
//import QuartzCore

class GameViewController: UIViewController {
    
    let gameViewModel = GameViewModel()

    var dataGameCountries: [DataCountries] = []
    var gameCountries: ([String], [String]) = ([], [])
    /*
    private var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: nil, action: nil)
        return button
    }()
    */
    private lazy var collectionGame: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        //Espacio entre filas
        layout.minimumLineSpacing = 16
        //
        layout.minimumInteritemSpacing = 16
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        /*
        rightButton.image = UIImage(systemName: "star")
        rightButton.target = self
        rightButton.action = #selector(didTapReset)
        navigationItem.rightBarButtonItem = rightButton
        */
        //Colecction
        collectionGame.delegate = self
        collectionGame.dataSource = self
        collectionGame.register(GameCollectionViewCell.self, forCellWithReuseIdentifier: gameViewModel.cellCollectionIdentifier)
        
        
        setupCollection()
        
        
        // Peticion URL
        gameViewModel.fetchCountries { data, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {return }
                self.dataGameCountries = data
                self.gameCountries = self.gameViewModel.randomCountries(data: self.dataGameCountries)
                self.collectionGame.reloadData()
            }
        }
        
    }

/*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
//        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
//        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
*/
    private func setupCollection () {
        view.addSubview(collectionGame)
        
        NSLayoutConstraint.activate([
            collectionGame.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionGame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionGame.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionGame.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    /*
    @objc
    private func didTapReset() {
        gameCountries = gameViewModel.randomCountries(data: dataGameCountries)
        gameViewModel.selectedIndexPaths.removeAll()
        collectionGame.reloadData()
    }
*/
}

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameCountries.0.count + gameCountries.1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gameViewModel.cellCollectionIdentifier, for: indexPath) as? GameCollectionViewCell else {
                return UICollectionViewCell()
            }

        // Mostrar nombres de países y capitales en diferetes columnas
        if indexPath.item%2 == 0 {
            cell.label.text = gameCountries.0[indexPath.item / 2]
        } else {
            cell.label.text = gameCountries.1[(indexPath.item / 2) - Int(0.5)]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 60) / 2
        return CGSize(width: width, height: 95)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        guard let cell = collectionView.cellForItem(at: indexPath) as? GameCollectionViewCell else { return }
        
        // Volver al color original si hay una celda previamente seleccionada
        if indexPath.item%2 == 0 {
            if let lastIndexPath = gameViewModel.lastSelectedIndexPathEven, !lastIndexPath.isEmpty, let lastCell = collectionView.cellForItem(at: lastIndexPath) as? GameCollectionViewCell {
                print("Ya hay un pais seleccionado cambia al nuevo")
                gameViewModel.resetCell(to: .systemGray5, cell: lastCell)
            }
        } else {
            if let lastIndexPath = gameViewModel.lastSelectedIndexPathOdd, !lastIndexPath.isEmpty, let lastCell = collectionView.cellForItem(at: lastIndexPath) as? GameCollectionViewCell{
                print("Ya hay una capital seleccionada cambia al nuevo")
                gameViewModel.resetCell(to: .systemGray5, cell: lastCell)
            }
        }
        
        //Verde al seleccionar
        print("Se selecciono \(String(describing: cell.label.text)) (color vede)")
        gameViewModel.resetCell(to: .systemGreen, cell: cell)

        //Informacion del item seleccionado
        guard let text = cell.label.text else {return}
        gameViewModel.informationOfItemSelected(at: indexPath.item, indexPath: indexPath, text: text)
        
        //Validar que hay un pais y una capital seleccionadas
        guard let countrySelect = gameViewModel.countryText, !countrySelect.isEmpty, let capitalSelect = gameViewModel.capitalText, !capitalSelect.isEmpty else {return}
        
        print("El país es: \(countrySelect), su capital: \(capitalSelect)")
        //Validar que la seleccion es correcta o no
        let result = gameViewModel.goodOrBadSelected()
        print(result ? "Correcto" : "Incorrecto")
        
        //Azul si es correcto
        if result {
            
            if let lastIndexPathEven = gameViewModel.lastSelectedIndexPathEven,
               let lastCellEven = collectionView.cellForItem(at: lastIndexPathEven) as? GameCollectionViewCell,
               let lastIndexPathObb = gameViewModel.lastSelectedIndexPathOdd,
               let lastCellObb = collectionView.cellForItem(at: lastIndexPathObb) as? GameCollectionViewCell {
                
                print("Pais color azul")
                gameViewModel.correctItemsSelected(to: .systemBlue, cell: lastCellEven, lastItem: lastIndexPathEven)
                
                print("Capital color azul")
                gameViewModel.correctItemsSelected(to: .systemBlue, cell: lastCellObb, lastItem: lastIndexPathObb)
                
                gameViewModel.resetInformacion()
                print(gameViewModel.lastSelectedIndexPathEven ?? "No hay nada en par")
                print(gameViewModel.lastSelectedIndexPathOdd ?? "No hay nada en impar")
            }
            
        }
        //Rojo a Por defecto si es incorrecto
        else {
            
            if let lastIndexPathEven = gameViewModel.lastSelectedIndexPathEven,
               let lastCellEven = collectionView.cellForItem(at: lastIndexPathEven) as? GameCollectionViewCell,
               let lastIndexPathObb = gameViewModel.lastSelectedIndexPathOdd,
               let lastCellObb = collectionView.cellForItem(at: lastIndexPathObb) as? GameCollectionViewCell{
                print("Pais color rojo-gris")
                gameViewModel.incorrectItemsSelected(to: .systemRed, to: .systemGray5, cell: lastCellEven)
                print("Capital color rojo-gris")
                
                gameViewModel.incorrectItemsSelected(to: .systemRed, to: .systemGray5, cell: lastCellObb)
                
                gameViewModel.resetInformacion()
                print(gameViewModel.lastSelectedIndexPathEven ?? "No hay nada en par")
                print(gameViewModel.lastSelectedIndexPathOdd ?? "No hay nada en impar")
                
            }
        }
    }
    
    //Deshabilita los items que ya se validaron correctos
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return !gameViewModel.selectedIndexPaths.contains(indexPath)
    }

}
