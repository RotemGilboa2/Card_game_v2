//
//  ViewController.swift
//  task1
//
//  Created by Rotem Gilboa on 30/05/2026.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var insertNameButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var westSideImageView: UIImageView!
    @IBOutlet weak var eastSideImageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - Properties
    let locationManager = CLLocationManager()
    var userSide: String?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialUI()
        checkSavedName()
        setupLocationManager()
    }

    // MARK: - Setup
    private func setupInitialUI() {
            startButton.isEnabled = false
            
            westSideImageView.alpha = 0.5
            eastSideImageView.alpha = 0.5
            
          
            let attributes: [NSAttributedString.Key: Any] = [
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            let attributedString = NSAttributedString(string: "Insert name", attributes: attributes)
            insertNameButton.setAttributedTitle(attributedString, for: .normal)
        }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization() 
        locationManager.startUpdatingLocation()
    }
    
    private func checkSavedName() {
        if let savedName = UserDefaults.standard.string(forKey: "saved_player_name") {
            welcomeLabel.text = "Hi \(savedName)"
            welcomeLabel.isHidden = false
            insertNameButton.isHidden = true
        } else {
            welcomeLabel.isHidden = true
            insertNameButton.isHidden = false
        }
        checkEnableStartButton()
    }
    
    // MARK: - CoreLocation Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        locationManager.stopUpdatingLocation()
        
        let currentLongitude = location.coordinate.longitude
        let midPoint = 34.817549168324334
        
        if currentLongitude > midPoint {
            userSide = "East"
            eastSideImageView.alpha = 1.0
            westSideImageView.alpha = 0.3
        } else {
            userSide = "West"
            westSideImageView.alpha = 1.0
            eastSideImageView.alpha = 0.3
        }
        
        checkEnableStartButton()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }

    // MARK: - Helpers
    private func checkEnableStartButton() {
        let hasName = UserDefaults.standard.string(forKey: "saved_player_name") != nil
        let hasLocation = userSide != nil
        
        if hasName && hasLocation {
            startButton.isEnabled = true
        } else {
            startButton.isEnabled = false
        }
    }

    // MARK: - IBActions
    @IBAction func insertNameTapped(_ sender: UIButton) {
        showNameInputDialog()
    }
    
    @IBAction func startGameTapped(_ sender: UIButton) {
        print("Starting game on side: \(userSide ?? "Unknown")")
    }
    
    private func showNameInputDialog() {
        let alert = UIAlertController(title: "Enter Name", message: "Please enter your name to start", preferredStyle: .alert)
        alert.addTextField { textField in textField.placeholder = "Player Name" }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            if let name = alert.textFields?.first?.text, !name.isEmpty {
                UserDefaults.standard.set(name, forKey: "saved_player_name")
                self?.checkSavedName()
            }
        }
        
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    // MARK: - Navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "startGameSegue" {
                if let gameVC = segue.destination as? GameViewController {
                    gameVC.playerSide = self.userSide
                    gameVC.playerName = UserDefaults.standard.string(forKey: "saved_player_name")
                }
            }
        }
}
