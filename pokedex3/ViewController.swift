//
//  ViewController.swift
//  pokedex3
//
//  Created by Student 3 on 11/6/18.
//  Copyright © 2018 Student 3. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    
// Outlets connecting to StoryBoard View
    @IBOutlet weak var collection : UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
// Main View variable declaration
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]()
    
    var musicPlayer :AVAudioPlayer!
    var inSearchMode : Bool = false
    
// Methods and Protocol Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done // phone keyboard dismissed when hitting done key
        parsePokemonCSV()   // Parse pokemon data (to be displayed)
        audioMusicPlay()    // Input 'Pokemon' audio music (mp3)
    }

    func parsePokemonCSV(){
        if let path = Bundle.main.path(forResource: "pokemon", ofType: "csv"){
            do{
                let csv = try CSV(contentsOfURL: path)
                let rows = csv.rows
                
                for row in rows{
                    let pokeId = Int(row["id"]!)!
                    let name = row["identifier"]!
//                    print("\(pokeId), \(name)")
                    pokemons.append(Pokemon(name: name.capitalized, pokedexId: pokeId))
                }
                
            }catch let err as NSError {
                print(err.debugDescription)
            }
        }
    }
    
    // Searching and filtering Pokemon with String manipulation, triggered when input text changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchBar.text == nil || searchBar.text == ""){
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
        } else{
            inSearchMode = true
            let loweredText = searchBar.text?.lowercased()
            filteredPokemons = pokemons.filter({
                let loweredPokeName = $0.name.lowercased()
                return (loweredPokeName.range(of: loweredText!) != nil)
            })
            collection.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
  
    
    // Music Controller and Playback
    
    func audioMusicPlay(){
        if let path = Bundle.main.path(forResource:"music", ofType: "mp3"){
            do{
                musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                musicPlayer.prepareToPlay()
                musicPlayer.numberOfLoops = -1
                musicPlayer.play()
            }catch let err as NSError{
                print(err.debugDescription)
            }
        }
    }
    
    @IBAction func musicTapBtn(_ sender: UIButton) {
        if (musicPlayer != nil){
            if (musicPlayer.volume<0.2) {
                musicPlayer.volume = 1.0
                sender.alpha = 1.0
            }else {
                musicPlayer.volume = 0.0
                sender.alpha = 0.2
            }
        }
    }
    
    
    // Collection View Protocol inside View Controller class
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell{
        
            if (inSearchMode) {
                let pokemon = filteredPokemons[indexPath.row]
                cell.configureCell(pokemon: pokemon)
                return cell
            }
            let pokemon = pokemons[indexPath.row]
            cell.configureCell(pokemon: pokemon)
            return cell
        }
        else { return UICollectionViewCell() }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (inSearchMode) {
            return filteredPokemons.count
        }
        return (pokemons.count)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let pokemon : Pokemon
        if (inSearchMode){
            pokemon = filteredPokemons[indexPath.row]
        }
        else {
            pokemon = pokemons[indexPath.row]
        }
        performSegue(withIdentifier: "PokemonDetailVC", sender: pokemon)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "PokemonDetailVC"){
            if let detailVC = segue.destination as? PokemonDetailVC{
                if let pokemon = sender as? Pokemon{
                    detailVC.pokemon = pokemon
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }
    
    
}

