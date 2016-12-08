//
//  ViewController.swift
//  Pokedex (Udemy)
//
//  Created by Mahmoud Hamad on 12/5/16.
//  Copyright © 2016 Mahmoud SMGL. All rights reserved.
// UICollectionViewDelegateFlowLayout to modify the Layout of CollectionView

import UIKit
import AVFoundation    //since we are woring with audio

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    @IBOutlet weak var collection: UICollectionView!
    
    var pokemonss = [Pokemon]()
    var musicPlayer: AVAudioPlayer! //musicPlayer variable
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collection.delegate = self
        collection.dataSource = self
        
        parsePokemonCSV()
        initAudio()
    }

    //the function that's going to get any of ur audio ready
    func initAudio() {
     
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")! //where is the file

        do {
            
            musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            musicPlayer.numberOfLoops = -1 //infinity
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
            
            let pokemon = pokemonss[indexPath.row]
            
            cell.configureCell(pokemon)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //did select
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //returns how many items in collection view
        
        return pokemonss.count
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
    
}

