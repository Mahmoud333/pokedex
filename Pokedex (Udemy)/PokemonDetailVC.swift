//
//  PokemonDetailVC.swift
//  Pokedex (Udemy)
//
//  Created by Mahmoud Hamad on 12/10/16.
//  Copyright © 2016 Mahmoud SMGL. All rights reserved.
//

import UIKit
import AVFoundation

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    
    
    
    var pokemon: Pokemon!
    
    let synthesizer = AVSpeechSynthesizer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLbl.text = "Downloading Data..."

        
        //the things we have already Name and PokedexID
        nameLabel.text = pokemon.name.capitalized
        mainImg.image = UIImage(named: "\(pokemon.pokedexId)")
        currentEvoImg.image = UIImage(named: "\(pokemon.pokedexId)")
        pokedexLbl.text = "\(pokemon.pokedexId)"

        
        pokemon.downloadPokemonDetails { 
            //whatever run here/write here will only be called after the network call is complete 
            //whenever data is avilabel update UI
            print("Did Arrive Here?")
            self.updateUI()
        }
    }

    func updateUI() {
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        weightLbl.text = pokemon.weight
        heightLbl.text = pokemon.height
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        
        //make sure, some pokemons don't have evolution like charizard so we need to check for that
        
        if pokemon.nextEvolutionID == "" || Int(pokemon.nextEvolutionID)! > 718  {
            evoLbl.text = "No Evolution"
            nextEvoImg.isHidden = true //hide the image, & in stack view it will auto center the image
        
        } else {
            
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: "\(pokemon.nextEvolutionID)")
            let str = "Next Evolution: \(pokemon.nextEvolutionName) - LVL \(pokemon.nextEvolutionLevel)"
            evoLbl.text = str
        }
    
        let utterance1 = AVSpeechUtterance(string: "\(nameLabel.text!)")
        utterance1.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance1.volume = 2.0
        
        synthesizer.speak(utterance1)
        
        let utterance2 = AVSpeechUtterance(string: "\(descriptionLbl.text!)")
        utterance2.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance2.volume = 2.0
        synthesizer.speak(utterance2)
        
    }
    
    deinit {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        descriptionLbl.text = "Downloading Data..."
        dismiss(animated: true, completion: nil) //get us back
    }
    


}
