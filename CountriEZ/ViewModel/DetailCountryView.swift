//
//  DetailCountryView.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 17/03/25.
//

import UIKit

class DetailCountryView {
    
    
    
    let cellIdentifier = "cell-data"
    let countrySelectedData: DataCountries
    
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
        
    }
    
    
    
    
    
    func fetchImageFlag (completion: @escaping (UIImage?, Error?) -> Void) {
        
        guard let url = URL(string: countrySelectedData.flags.nameImagePNG) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, let image = UIImage(data: data), error == nil else { return }
            completion (image, nil)
        }
     
        task.resume()
    }
    
}
