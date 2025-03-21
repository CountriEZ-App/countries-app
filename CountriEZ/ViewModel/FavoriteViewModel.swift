//
//  FavoriteViewModel.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 20/03/25.
//

import UIKit
import CoreData

class FavoriteViewModel {
    // NAME https://restcountries.com/v3.1/name/deutschland
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let favoriteCell = "cell-favorite"
    
    var countriesFavorites: [CountryFavorite] = []
    
    var numCell: Int {
        countriesFavorites.count
    }
    
    
    init () {
        self.countriesFavorites = loadCountriesToTable()
    }
    

//MARK: - CoreData
    func deleteCountry (name: String) {
        let fetchRequestDelete: NSFetchRequest<CountryFavorite> = CountryFavorite.fetchRequest()
        fetchRequestDelete.predicate = NSPredicate(format: "name CONTAINS[c] %@", name)
        fetchRequestDelete.fetchLimit = 1
        do {
            if let countryDelete = try context.fetch(fetchRequestDelete).first{
                context.delete(countryDelete)
                try context.save()
            } else {
                print("No se borro el pais de favoritos")
            }
        } catch {
            print(error.localizedDescription)
        }
        
        countriesFavorites = loadCountriesToTable()
        NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
    }
    
    
    func loadCountriesToTable () -> [CountryFavorite] {
        let fetchRequest: NSFetchRequest<CountryFavorite> = CountryFavorite.fetchRequest()
        
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print(error.localizedDescription)
            return []
        }
        
    }
    
    

//MARK: - Peticion API
    func fetchImageFavorite (index: Int, completion: @escaping (UIImage?, Error?) -> Void) {
        guard let urlImage = countriesFavorites[index].imageURL, let url = URL(string: urlImage) else {
            completion(nil, nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data ,let image = UIImage(data: data), error == nil else { return }
            completion(image, nil)
            
        }
        
        task.resume()
    }
    
    func fetchDataCountryFavorite (name: String, completion: @escaping (DataCountries?, Error?) -> Void) {
        guard let url = URL(string: "https://restcountries.com/v3.1/name/\(name)") else {
            completion(nil, nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else { return }
            
            do {
                let dataCountry = try JSONDecoder().decode([DataCountries].self, from: data)
                completion(dataCountry.first, nil)
            } catch {
                print("Error al decodificar el pais favorito:", error)
            }
        }
        task.resume()
        
    }
    
}
