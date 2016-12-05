//
//  Pokemon.swift
//  Pokedex (Udemy)
//
//  Created by Mahmoud Hamad on 12/5/16.
//  Copyright © 2016 Mahmoud SMGL. All rights reserved.
//

import Foundation

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    
    var pokeName: String {
        if _name == nil { _name = "" }
        return _name
    }
    
    var pokedexId: Int {
        if _pokedexId == nil { _pokedexId = 0 }
        return _pokedexId
    }
    
    init(name: String,pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
    }
    
    
}
