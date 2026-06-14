//
//  SummaryViewController.swift
//  task1
//
//  Created by Rotem Gilboa on 30/05/2026.
//


import UIKit

class SummaryViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var finalPlayerScore = 0
    var finalPcScore = 0
    var playerName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isModalInPresentation = true
        setupSummary()
    }
    
    private func setupSummary() {
        let name = playerName ?? "Player"
        
        if finalPlayerScore > finalPcScore {
            statusLabel.text = "Winner: \(name)"
            scoreLabel.text = "score: \(finalPlayerScore)"
        } else if finalPcScore > finalPlayerScore {
            statusLabel.text = "Winner: PC"
            scoreLabel.text = "score: \(finalPcScore)"
        } else {
            statusLabel.text = "Winner: PC"
            scoreLabel.text = "score: \(finalPcScore)"
        }
    }
    
    // MARK: - IBActions
    @IBAction func backToMenuTapped(_ sender: UIButton) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
