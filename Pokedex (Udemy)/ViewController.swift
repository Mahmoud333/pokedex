//
//  ViewController.swift
//  Pokedex (Udemy)
//
//  Created by Mahmoud Hamad on 12/5/16.
//  Copyright © 2016 Mahmoud SMGL. All rights reserved.
// UICollectionViewDelegateFlowLayout to modify the Layout of CollectionView

import UIKit
import AVFoundation    //since we are woring with audio

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {


    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar! //anytime u type anything we filter the results
    
    var pokemonss = [Pokemon]()
    //var displayedPokemons = [Pokemon]()
    var filteredPokemonss = [Pokemon]()
    var inSearchMode = false
    
    var musicPlayer: AVAudioPlayer! //musicPlayer variable
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done //change search button to done button
        
        parsePokemonCSV()
        initAudio()
    }

    //the function that's going to get any of ur audio ready
    func initAudio() {
     
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")! //where is the file

        do {
            
            musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            musicPlayer.numberOfLoops = -1 //infinity
            musicPlayer.volume = 0.4
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
    }
    
    //func that parse pokemon csv data and put it into a form that is useful to us
    //want it to grab pokemonCSV file, parse it, 1st have to make path for it
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        //use the parser
        do {
            
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            //print(rows)
            
            for row in rows {
                //print(row)
                let pokeName = row["identifier"]! as String
                let pokeID = Int(row["id"]! as String)! //"species_id" or "id"
                //normaly we dont want to force & wrap these but in this we case we have csv file that either have or does not have these values, if its there its there if its not its not
                print("PokeName: \(pokeName), pokeID: \(pokeID)")
                let poke = Pokemon(name: pokeName, pokedexId: pokeID)
                pokemonss.append(poke)
            }
            
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //return the cell
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            //let Ivvysour = Pokemon(name: "Ivvysour", pokedexId: 2)
            //let pokemon = Pokemon(name: "Pokemon", pokedexId: indexPath.row)
            
            //let pokemon = pokemonss[indexPath.row]
            //let pokemon = displayedPokemons[indexPath.row]
            
            let pokemon: Pokemon!
            if inSearchMode == false {
                pokemon = pokemonss[indexPath.row]
            } else {
                pokemon = filteredPokemonss[indexPath.row]
            }
            
            cell.configureCell(pokemon)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //did select
        
        var pokemon: Pokemon!
        
        if inSearchMode == false {
            pokemon = pokemonss[indexPath.row] //original
        } else {
            pokemon = filteredPokemonss[indexPath.row] //filtered
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: pokemon)
        //sending our poke
    }

    //set data to be passed between two controllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let PokeDVC = segue.destination as? PokemonDetailVC {
                if let pokemon = sender as? Pokemon { //saying poke is the sender of type Pokemon
                    PokeDVC.pokemon = pokemon
                }
            }
        }
        
    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //returns how many items in collection view
        //return displayedPokemons.count
        
        if inSearchMode == false { return pokemonss.count }
        else { return filteredPokemonss.count }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying == true {
            musicPlayer.pause()
            sender.alpha = 0.4
        } else {
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //anytime we make keystroke in search bar whatever is here is going to be called
        
        //compare text with the pokemons names
        if searchBar.text == nil || searchBar.text == "" {
            
            //displayedPokemons = pokemonss
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true) //the keyboard will go away at that point
        } else {
           
            inSearchMode = true
            
            var lower = searchBar.text!.lowercased() //"!" because we checked its not nill
            
            filteredPokemonss = pokemonss.filter({ $0.name.range(of: lower) != nil })
            //filtertedPokemon array is equal to pokemonss array but filtered, we filter it by taking $0 and $0 can be thought of as placeholder for any and all of the objects in the pokemonss array "saying each object which is $0" we are taking the name value of that and we are saying is what we put in search bar contained inside of that name, and if it is then we're going to put that into the filteredpokemonss array
            //we're creating a filter list from the original list of pokemons & we're filtering it based on whether the search bar text is included in the range of the original name and the $0 is just a placeholder for each item in that array
            
            //then after filtering
            collection.reloadData()
            
            /*
            for poke in pokemonss {
                if poke.name == searchBar.text?.capitalized {
                    filteredPokemons.append(poke)
                    print("found one")
                }
            }
            displayedPokemons = searchedPokemons
            */
        }
    
    }
}

