//
//  pokemon.swift
//  pokedex3
//
//  Created by Student 3 on 11/6/18.
//  Copyright © 2018 Student 3. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon{
    
    private var _name : String!
    private var _pokedexId : Int!
    private var _description: String!
    private var _monsterType: String!
    private var _defense: Int!
    private var _attack: Int!
    private var _length: Int!
    private var _weight: Int!
    private var _nextEvolution: String!
    
    private var _pokemonURL: String!
    
    var name : String {
        return _name
    }
    
    var pokedexId : Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int){
        
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(BASE_URL)\(POKE_URL)\(self.pokedexId)/"
//        print(self._pokemonURL)
    }
    
    func downloadPokemonData(completed: @escaping DownloadComplete){
       
        Alamofire.request("https://pokeapi.co/api/v2/pokemon/1/").responseJSON { (response) in
//            print(response.result.value)
            if let dict = response.result.value as? Dictionary<String,AnyObject>{
                //  download raw pokemon data
                if let weight = dict["weight"] as? Int {
                    self._weight = weight
                }
                if let length = dict["height"] as? Int {
                    self._length = length
                }
                if let stats = dict["stats"] as? [Dictionary<String, AnyObject>]{
                    if let baseAttack = stats[4]["base_stat"] as? Int{
                        self._attack = baseAttack
                    }
                }
                if let types = dict["types"] as? [Dictionary<String, AnyObject>]{
                    var monsterType = ""
                    for x in 0..<types.count{
                        if let typedict = types[x]["type"] as? Dictionary<String,String>{
                            monsterType += "/\(typedict["name"] ?? "")"
                            
                        }
                        self._monsterType = monsterType
                    }
                }else{
                    self._monsterType = "unknown"
                }
            }
        }
        
        
        
    }
}
