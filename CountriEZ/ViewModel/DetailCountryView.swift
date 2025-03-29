//
//  DetailCountryView.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 17/03/25.
//

import UIKit
import CoreData

class DetailCountryView {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var countriesFavorite: [CountryFavorite]?
    
    
    let cellIdentifier = "cell-data"
    
    let countrySelectedData: DataCountries
    
    var imageFlag: String {
        countrySelectedData.flags.nameImagePNG
    }
    

    var labelInformation: String? {
        countrySelectedData.flags.informationFlag
    }
    
    var coordinateCountry: [Double] {
        countrySelectedData.latAndLong
    }
    
    //MARK: - Data Cells
    let nameSections = ["Country Identification", "Political and Administrative Data", "Language","Economic Data", "Geographical Location"]
    
    var countryIdentification: (nameCommon: String, nameOfficial: String) {
        (countrySelectedData.name.nameCountry, countrySelectedData.name.nameOfficial)
    }
    
    var politicalAndAdministrativeData: (capital: [String], population: Int) {
        (countrySelectedData.capital ?? [], countrySelectedData.population)
    }
    
    var language: [String] {
        countrySelectedData.languages?.values.compactMap { $0 } ?? []
    }
    
    var economicData: [(currencyName: String, currencySymbol: String)] {
        countrySelectedData.currencies?.map { ($0.value.nameCurrencie, $0.value.symbolCurrencie) } ?? []
    }
    
    var geographicalLocation: (continents: [String], region: String, subregion: String) {
        (countrySelectedData.continents, countrySelectedData.region, countrySelectedData.subRegion ?? "")
    }
    
    init(countryData: DataCountries) {
        self.countrySelectedData = countryData
        self.countriesFavorite = loadCountriesFavorites()    
    }
    

//MARK: - CoreData
    func addCountryToFavorite (name: String, url: String) {
        let newCountryFavorite = CountryFavorite(context: context)
        newCountryFavorite.name = name
        newCountryFavorite.imageURL = url
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        countriesFavorite = loadCountriesFavorites()
        NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)

    }
    
    
    func deleteCountryToFavorite (name: String) {
        let fetchRequestDelete: NSFetchRequest<CountryFavorite> = CountryFavorite.fetchRequest()
        fetchRequestDelete.predicate = NSPredicate(format: "name ==[c] %@", name)
        
        do {
            let result = try context.fetch(fetchRequestDelete)
            if let countryToDelete = result.first {
                context.delete(countryToDelete)
                try context.save()
            } else {
                print("No se borro nada")
            }
        } catch {
            print(error.localizedDescription)
        }
        
        countriesFavorite = loadCountriesFavorites()
        NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
    }
    
    
    func loadCountriesFavorites () -> [CountryFavorite] {
        let fetchRequest: NSFetchRequest<CountryFavorite> = CountryFavorite.fetchRequest()
        
        do {
            let countries = try context.fetch(fetchRequest)
            return countries
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    
    func updateImageButton (name: String) -> String {
        let isFavorite = countriesFavorite?.contains { $0.name == name } ?? false
            return isFavorite ? "star.fill" : "star"
    }
    
}
