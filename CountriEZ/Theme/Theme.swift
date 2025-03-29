//
//  Theme.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 28/03/25.
//

import UIKit

struct Theme {
    
    // MARK: - Colors
    
    static var correctAnswer: UIColor {
        return UIColor(named: "CorrectAnswer") ?? UIColor(red: 81/255, green: 152/255, blue: 114/255, alpha: 1)
    }
    
    static var wrongAnswer: UIColor {
        return UIColor(named: "WrongAnswer") ?? UIColor(red: 215/255, green: 38/255, blue: 61/255, alpha: 1)
    }
    
    static var backgroundColor: UIColor {
        return UIColor(named: "BackgroundColor") ?? UIColor(red: 241/255, green: 237/255, blue: 238/255, alpha: 1)
    }
    
    static var textColor: UIColor {
        return UIColor(named: "TextColor") ?? UIColor(red: 225/255, green: 255/255, blue: 255/255, alpha: 1)
    }
    
    static var buttonsColor: UIColor {
        return UIColor(named: "ButtonsColor") ?? UIColor(red: 76/255, green: 181/255, blue: 174/255, alpha: 1)
    }
    
    static var itemCollection: UIColor {
        return UIColor(named: "ItemCollection") ?? UIColor(red: 113/255, green: 126/255, blue: 195/255, alpha: 1)
    }
}
