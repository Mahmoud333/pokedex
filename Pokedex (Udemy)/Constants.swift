//
//  Constants.swift
//  Pokedex (Udemy)
//
//  Created by Mahmoud Hamad on 12/15/16.
//  Copyright © 2016 Mahmoud SMGL. All rights reserved.
//

import Foundation

let URL_BASE = "http://pokeapi.co"
let URL_POKEMON = "/api/v1/pokemon/" //then the number of pokedexID

typealias DownloadComplete = () -> () //create clouser that run at specific time 'later time'
