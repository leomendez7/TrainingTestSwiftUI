//
//  Currency.swift
//
//
//  Created by Leonardo Mendez on 9/11/23.
//

import Foundation

public struct Currency: Identifiable {
    
    public var id = UUID()
    public var name: String = ""
    public var abbreviation: String = ""
    
    public init() { }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case abbreviation = "abbreviation"
    }
    
}

public enum AbbreviationCurrency: String {
    case usd = "USD"
    case jpy = "JPY"
    case eur = "EUR"
    case cop = "COP"
    case pre = "preference"

}
