//
//  PokeCell.swift
//  Pokedex (Udemy)
//
//  Created by Mahmoud Hamad on 12/5/16.
//  Copyright © 2016 Mahmoud SMGL. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    //for each pokeCell we will have to create a class of pokemon so that it stored in here
    var pokemon: Pokemon!
    
    //the rounded corners 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //this will happen on layer level cell where u impelement things to modify how it looks
        layer.cornerRadius = 5.0
        
    }
    
    func configureCell(_ pokemon: Pokemon) {
        
        self.pokemon = pokemon
        
        //Update Cell Label and Image
        nameLbl.text = self.pokemon.name.capitalized //Capital it
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        
    }
    
    
}
