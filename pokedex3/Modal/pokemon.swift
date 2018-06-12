//
//  pokemon.swift
//  pokedex3
//
//  Created by Student 3 on 11/6/18.
//  Copyright © 2018 Student 3. All rights reserved.
//

import Foundation

class Pokemon{
    private var _name : String!
    private var _pokedexId : Int!
    
    var name : String {
        return _name
    }
    
    var pokedexId : Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int){
        
        self._name = name
        self._pokedexId = pokedexId
    }

}
