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
    var isPlayerOnLeft = true
    
    let gameClock = GameClock()
    
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
        
        SoundManager.shared.playBackgroundMusic(filename: "musicbackground", fileExtension: "mp3")
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
            NotificationCenter.default.removeObserver(self)
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
            gameClock.delegate = self
            gameClock.start()
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
            SoundManager.shared.playSoundEffect(filename: "flipcard", fileExtension: "mp3")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                let leftIndex = Int.random(in: 0...52)
                let rightIndex = Int.random(in: 0...52)
                
                self.leftCardImageView.image = UIImage(named: self.cardNames[leftIndex])
                self.rightCardImageView.image = UIImage(named: self.cardNames[rightIndex])
                
                let leftCardPower = self.getCardPower(fromIndex: leftIndex)
                let rightCardPower = self.getCardPower(fromIndex: rightIndex)
                
                if leftCardPower > rightCardPower {
                    if self.isPlayerOnLeft { self.playerScore += 1 } else { self.pcScore += 1 }
                } else if rightCardPower > leftCardPower {
                    if !self.isPlayerOnLeft { self.playerScore += 1 } else { self.pcScore += 1 }
                }
                
                self.updateScoreLabels()
            }
        }
        
    private func flipCardsFaceDown() {
            SoundManager.shared.playSoundEffect(filename: "flipcard", fileExtension: "mp3")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.leftCardImageView.image = UIImage(named: "card_back")
                self.rightCardImageView.image = UIImage(named: "card_back")
            }
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
    
    // MARK: - App LifeCycle Handling
        
        @objc func appMovedToBackground() {
            print("App moved to background - pausing game")
            gameClock.stop()
            SoundManager.shared.pauseBackgroundMusic()
        }
        
        @objc func appMovedToForeground() {
            print("App moved to foreground - resuming game")
            gameClock.start()
            SoundManager.shared.resumeBackgroundMusic()
        }
    
    private func endGame() {
        timerLabel.text = "0"
        
        SoundManager.shared.stopBackgroundMusic()
        if playerScore > pcScore {
            SoundManager.shared.playSoundEffect(filename: "winnersound", fileExtension: "mp3")
        } else {
            SoundManager.shared.playSoundEffect(filename: "losegame", fileExtension: "mp3")
        }
        
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

// MARK: - GameClockDelegate
extension GameViewController: GameClockDelegate {
    
    func gameClockDidUpdateTimer(currentTime: Int) {
        timerLabel.text = "\(currentTime)"
    }
    
    func gameClockDidTriggerRound() {
        playRound()
    }
    
    func gameClockDidTriggerFlip() {
        flipCardsFaceDown()
    }
    
    func gameClockDidFinish() {
        endGame()
    }
}
