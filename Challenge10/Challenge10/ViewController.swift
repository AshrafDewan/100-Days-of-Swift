//
//  ViewController.swift
//  Challenge10
//
//  Created by Ashraf Dewan on 5/20/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    var cardsNames = ["MagicianOfBlackChaos", "DarkMagician", "DarkMagicianGirl", "King'sKnight", "Jack'sKnight", "Queen'sKnight"]
    var cards = [UIImage]()
    var shownCards = [UIImage]()
    var faceOffCard: UIImage!
    
    var selectedCardsIndicies = [Int]()
    var foundPairs = [Int]()
    var faceOnCounter = 0
    var index = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Find Pairs"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Restart Game", style: .plain, target: self, action: #selector(startGame))
        
        startGame()
    }
    
    @objc func startGame() {
        cards.removeAll()
        shownCards.removeAll()
        
        selectedCardsIndicies.removeAll()
        foundPairs.removeAll()
        faceOnCounter = 0
        
        loadCards()
        
        collectionView.reloadData()
    }
    
    func loadCards() {
        for _ in 0...1 {
            for card in cardsNames {
                guard let image = UIImage(named: card) else { return }
                cards.append(image)
            }
        }
        
        cards.shuffle()
        guard let image = UIImage(named: "faceOff") else { return }
        faceOffCard = image
        
        for _ in 1...12 {
            shownCards.append(image)
        }
    }
    
    func checkSelectedCard() {
        if !foundPairs.contains(index) && !selectedCardsIndicies.contains(index) {
            showSelectedCard(index)
            
            if faceOnCounter == 2 {
                shownCardsMatched()
            } else if faceOnCounter > 2 {
                shownCardsNotMatched()
            }
            
            collectionView.reloadData()
        }
    }
    
    func showSelectedCard(_ index: Int) {
        shownCards[index] = cards[index]
        selectedCardsIndicies.append(index)
        faceOnCounter += 1
    }
    
    func shownCardsMatched() {
        if cards[selectedCardsIndicies[0]] == cards[selectedCardsIndicies[1]] {
            matched()
            
            for i in selectedCardsIndicies {
                foundPairs.append(i)
            }
        }
    }
    
    func matched() {
        shownCards[selectedCardsIndicies[0]] = cards[selectedCardsIndicies[0]]
        shownCards[selectedCardsIndicies[1]] = cards[selectedCardsIndicies[1]]
    }
    
    func shownCardsNotMatched() {
        if cards[selectedCardsIndicies[0]] != cards[selectedCardsIndicies[1]] {
            notMatched()
        }
        
        selectedCardsIndicies.removeAll()
        showSelectedCard(index)
        faceOnCounter = 1
    }
    
    func notMatched() {
        shownCards[selectedCardsIndicies[0]] = faceOffCard
        shownCards[selectedCardsIndicies[1]] = faceOffCard
    }
    
    func gameEnded() {
        if !shownCards.contains(faceOffCard) {
            let ac = UIAlertController(title: "You Won", message: "Congratulations, You ended the game.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
                self?.startGame()
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shownCards.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCell else { fatalError("Unable to dequeue CardCell.") }
        
        cell.imageView.image = shownCards[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        index = indexPath.item
        checkSelectedCard()
        gameEnded()
    }
}
