//
//  Pokemon.swift
//  Pokedex (Udemy)
//
//  Created by Mahmoud Hamad on 12/5/16.
//  Copyright © 2016 Mahmoud SMGL. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    fileprivate var _description: String!
    fileprivate var _type: String!
    fileprivate var _defense: String!
    fileprivate var _height: String!
    fileprivate var _weight: String!
    fileprivate var _attack: String!
    fileprivate var _nextEvolutionTxt: String!
    fileprivate var _nextEvolutionName: String!
    fileprivate var _nextEvolutionID: String!
    fileprivate var _nextEvolutionLevel: String!
    
    fileprivate var _pokemonURL: String!
    
    var description: String {
        if _description == nil { _description = "" }
        return _description
    }
    
    var type: String {
        if _type == nil { _type = "" }
        return _type
    }
    
    var defense: String {
        if _defense == nil { _defense = ""}
        return _defense
    }
    
    var height: String {
        if _height == nil {_height = ""}
        return _height
    }
    
    var weight: String {
        if _weight == nil {_weight = ""}
        return _weight
    }
    
    var attack: String {
        if _attack == nil { _attack = ""}
        return _attack
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil { _nextEvolutionTxt = "" }
        return _nextEvolutionTxt
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil { _nextEvolutionName = "" }
        return _nextEvolutionName
    }
    
    var nextEvolutionID: String {
        if _nextEvolutionID == nil { _nextEvolutionID = ""}
        return _nextEvolutionID
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil { _nextEvolutionLevel = ""}
        return _nextEvolutionLevel
    }
    
    var name: String {
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
        
        //once we create pokemon we want to go ahead and create the pokemon API URL
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
        
    }
    //we don't want to make 718 network calls right off the bat that would be too manyso we will whenever we click on one of the pokemon and we go to detail controller its then we make network call and pull down the data "Called Lazy Loading" might take 0.5~1.0 sec
    
    //asynchronous meaning we don't know when they are completed so in PokemonDVC we can just start setting the labels to those variables because it would crash bec. those aren't immediatley available on ViewDidLoad
    //what we want to do have a way  let VC know when that data will be available and we are gonna do it with the closure
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        //.GET
        Alamofire.request(self._pokemonURL).responseJSON { response in
            print(response.result.value)
            
            if let dict = response.result.value as? Dictionary<String,AnyObject> {
               
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
            
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
            
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                
                //, means where     ,if it there has atleast one
                if let types = dict["types"] as? [Dictionary<String, AnyObject>], types.count > 0 {
                    
                    if let name = types[0]["name"] as? String {
                        self._type = name.capitalized
                    }
                    
                    //more than one type
                    if types.count > 1 {
                        //loop through the rest of types
                        for x in 1..<types.count { //for x in 1 to less than types.count
                            
                            if let name = types[x]["name"] as? String {
                                
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                    print(self._type)
                } else { //there is no types
                    self._type = ""
                }
                
                
                //, means where
                if let descriptions = dict["descriptions"] as? [Dictionary<String, AnyObject>] , descriptions.count > 0 {
                    
                    self._description = "" //empty it first important for speech
                    
                    let diceRoll = Int(arc4random_uniform(UInt32(descriptions.count)))
                    print("DiceRoll: \(diceRoll)") //0 until .count -1(0,1,2,3, .count-1)
                    
                    if let descURL = descriptions[diceRoll]["resource_uri"] as? String {
                        
                        Alamofire.request("\(URL_BASE)\(descURL)").responseJSON { response2 in
                            
                            //dict-descriptions-Request
                            if let dictDescRequest = response2.result.value as? Dictionary<String, AnyObject> {
                                
                                if let description = dictDescRequest["description"] as? String {
                                    print(description) //in description pokemon = POKMONs so we will
                                    
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    //make a new description & we are going to create it from the old description but replace "POKMON" with "pokemon"
                                    
                                    print(newDescription) //can try with Wartortle
                                    self._description = newDescription
                                }
                                
                            }
                            completed()
                        }
                    }
                } else { //if there isn't any descriptions at all
                    self._description = ""
                }

                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                    
                    if let nextEvo = evolutions[0]["to"] as? String {
                        //make sure that we use evolutions that exclude megas, we gonna make filter here
                        if nextEvo.range(of: "mega") == nil { //then we gonna continue "dont have mega" if its not a mega continue
                            self._nextEvolutionName = nextEvo
                        }
                    }
                    //get PokedexID out from "URL" "/api/v1/pokemon/3/"
                    if let uri = evolutions[0]["resource_uri"] as? String {
                        
                        let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                        let newerStr = newStr.replacingOccurrences(of: "/", with: "")
                        
                        self._nextEvolutionID = newerStr
                    }
                    
                    if let lvlExist = evolutions[0]["level"] as? Int { //not all pokemons have it
                        
                        self._nextEvolutionLevel = "\(lvlExist)"
                    
                    } else {
                        
                        self._nextEvolutionLevel = ""
                    }
                
                    print("nextEvolutionLevel: \(self._nextEvolutionLevel)")
                    print("nextEvolutionID: \(self.nextEvolutionID)")
                    print("nextEvolutionName: \(self.nextEvolutionName)")
                }
                
            }
            
            completed() //then we are letting the func know that its been complete
        }
        
    }
    
    
}
