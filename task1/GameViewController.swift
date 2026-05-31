//
//  GameViewController.swift
//  task1
//
//  Created by Rotem Gilboa on 30/05/2026.
//

import UIKit

class GameViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var leftNameLabel: UILabel!
    @IBOutlet weak var leftScoreLabel: UILabel!
    @IBOutlet weak var leftCardImageView: UIImageView!
    
    @IBOutlet weak var rightNameLabel: UILabel!
    @IBOutlet weak var rightScoreLabel: UILabel!
    @IBOutlet weak var rightCardImageView: UIImageView!
    
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    var playerSide: String?
    var playerName: String?
    
    var playerScore = 0
    var pcScore = 0
    var roundsPlayed = 0
    var countdown = 5
    var gameTimer: Timer?
    var isPlayerOnLeft = true
    
    let cardNames = [
        "001-ace of spades", "002-ace of clubs", "003-ace of diamonds", "004-ace of hearts",
        "005-two of spades", "006-two of clubs", "007-two of diamonds", "008-two of hearts",
        "009-three of spades", "010-three of clubs", "011-three of diamonds", "012-three of hearts",
        "013-four of spades", "014-four of clubs", "015-four of diamonds", "016-four of hearts",
        "017-five of spades", "018-five of clubs", "019-five of diamonds", "020-five of hearts",
        "021-six of spades", "022-six of clubs", "023-six of diamonds", "024-six of hearts",
        "025-seven of spades", "026-seven of clubs", "027-seven of diamonds", "028-seven of hearts",
        "029-eight of spades", "030-eight of clubs", "031-eight of diamonds", "032-eight of hearts",
        "033-nine of spades", "034-nine of clubs", "035-nine of diamonds", "036-nine of hearts",
        "037-ten of spades", "038-ten of clubs", "039-ten of diamonds", "040-ten of hearts",
        "041-jack of spades", "042-jack of clubs", "043-jack of diamonds", "044-jack of hearts",
        "045-queen of spades", "046-queen of clubs", "047-queen of diamonds", "048-queen of hearts",
        "049-king of spades", "050-king of clubs", "051-king of diamonds", "052-king of hearts",
        "053-jokers"
    ]
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isModalInPresentation = true
        
        setupGame()
        startGameLoop()
    }
    
    // MARK: - Setup
    private func setupGame() {
        
        leftScoreLabel.text = "0"
        rightScoreLabel.text = "0"
        
        if playerSide == "West" {
            isPlayerOnLeft = true
            leftNameLabel.text = playerName
            rightNameLabel.text = "PC"
        } else {
            isPlayerOnLeft = false
            rightNameLabel.text = playerName
            leftNameLabel.text = "PC"
        }
        
        flipCardsFaceDown()
    }
    
    // MARK: - Timer & Game Logic
    private func startGameLoop() {
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    @objc private func timerTick() {
        if roundsPlayed == 10 && countdown == 1 {
            endGame()
            return
        }
        
        timerLabel.text = "\(countdown)"
        
        if countdown == 5 {
            roundsPlayed += 1
            playRound()
        } else if countdown == 2 {
            flipCardsFaceDown()
        }
        
        countdown -= 1
        if countdown == 0 {
            countdown = 5
        }
    }
    
    private func getCardPower(fromIndex index: Int) -> Int {
        if index == 52 { return 15 }
        
        let rankGroup = index / 4
        if rankGroup == 0 {
            return 14
        }
        
        return rankGroup + 1
    }
    
    private func playRound() {
        let leftIndex = Int.random(in: 0...52)
        let rightIndex = Int.random(in: 0...52)
        
        leftCardImageView.image = UIImage(named: cardNames[leftIndex])
        rightCardImageView.image = UIImage(named: cardNames[rightIndex])
        
        let leftCardPower = getCardPower(fromIndex: leftIndex)
        let rightCardPower = getCardPower(fromIndex: rightIndex)
        
        if leftCardPower > rightCardPower {
            if isPlayerOnLeft { playerScore += 1 } else { pcScore += 1 }
        } else if rightCardPower > leftCardPower {
            if !isPlayerOnLeft { playerScore += 1 } else { pcScore += 1 }
        }
        
        updateScoreLabels()
    }
    
    private func flipCardsFaceDown() {
        leftCardImageView.image = UIImage(named: "card_back")
        rightCardImageView.image = UIImage(named: "card_back")
    }
    
    private func updateScoreLabels() {
        if isPlayerOnLeft {
            leftScoreLabel.text = "\(playerScore)"
            rightScoreLabel.text = "\(pcScore)"
        } else {
            rightScoreLabel.text = "\(playerScore)"
            leftScoreLabel.text = "\(pcScore)"
        }
    }
    
    private func endGame() {
        gameTimer?.invalidate()
        timerLabel.text = "0"
        
        print("Game Over! Player: \(playerScore), PC: \(pcScore)")
        
        performSegue(withIdentifier: "showSummarySegue", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSummarySegue" {
            if let summaryVC = segue.destination as? SummaryViewController {
                summaryVC.finalPlayerScore = self.playerScore
                summaryVC.finalPcScore = self.pcScore
                summaryVC.playerName = self.playerName
            }
        }
    }
}
