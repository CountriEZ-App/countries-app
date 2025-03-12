//
//  Model.swift
//  PruebaCountiEZ
//
//  Created by Zelene Yosseline Isayana Montes Cantero on 10/03/25.
//

import Foundation

struct DataCountries: Codable {
    var name: NameCommonAndOfficial
    var currencies: [String: Currencies]?
    var capital: [String]?
    var region: String
    var subRegion: String?
    var languages : [String: String]?
    var latAndLong: [Double]
    var population: Int
    var continents: [String]
    var flags: Flag
    
    private enum CodingKeys: String, CodingKey {
        case name
        case currencies
        case capital
        case region
        case subRegion = "subregion"
        case languages
        case latAndLong = "latlng"
        case population
        case continents
        case flags
    }
    
    struct NameCommonAndOfficial: Codable {
        var nameCountry: String
        var nameOfficial: String
        
        private enum CodingKeys: String, CodingKey {
            case nameCountry = "common"
            case nameOfficial = "official"
        }
    }
    
    struct Currencies: Codable {
        var nameCurrencie: String
        var symbolCurrencie: String
        
        private enum CodingKeys: String, CodingKey {
            case nameCurrencie = "name"
            case symbolCurrencie = "symbol"
        }
    }
    
    struct Flag: Codable {
        var nameImagePNG: String
        var informationFlag: String?
        
        private enum CodingKeys: String, CodingKey {
            case nameImagePNG = "png"
            case informationFlag = "alt"
        }
    }
}

// ALL https://restcountries.com/v3.1/all
// NAME https://restcountries.com/v3.1/name/deutschland
// language  https://restcountries.com/v3.1/lang/spanish
// capital https://restcountries.com/v3.1/capital/tallinn
// region https://restcountries.com/v3.1/region/europe
