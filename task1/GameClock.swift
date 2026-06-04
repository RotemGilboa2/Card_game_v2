//
//  GameClock.swift
//  task1
//
//  Created by Rotem Gilboa on 31/05/2026.
//

import Foundation

// MARK: - Protocol
protocol GameClockDelegate: AnyObject {
    func gameClockDidUpdateTimer(currentTime: Int)
    func gameClockDidTriggerRound()
    func gameClockDidTriggerFlip()
    func gameClockDidFinish()
}

class GameClock {
    private var timer: Timer?
    private var countdown = 5
    private var roundsPlayed = 0
    private let maxRounds = 10
    
    weak var delegate: GameClockDelegate?
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    @objc private func tick() {
        if roundsPlayed == maxRounds && countdown == 1 {
            stop()
            delegate?.gameClockDidFinish()
            return
        }
        
        delegate?.gameClockDidUpdateTimer(currentTime: countdown)
        
        if countdown == 5 {
            roundsPlayed += 1
            delegate?.gameClockDidTriggerRound()
        } else if countdown == 2 {
            delegate?.gameClockDidTriggerFlip()
        }
        
        countdown -= 1
        if countdown == 0 {
            countdown = 5
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
