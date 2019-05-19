//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by Kévin Courtois on 06/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var localImageBar: ImageWhiteBar!
    @IBOutlet weak var currentImageBar: ImageWhiteBar!

    override func viewDidAppear(_ animated: Bool) {
        weatherService(coordinates: Coordinates(latitude: 48.27, longitude: 2.7), imageBar: localImageBar, completion: {
            guard let coord = LocationManager.shared.coordinates else {
                self.presentAlert(titre: "Erreur", message: "Impossible de récupérer la météo de à votre position.")
                self.currentImageBar.titleLabel.text = "Inconnu"
                self.currentImageBar.subTitleLabel.text = "Météo inconnue."
                return
            }
            self.weatherService(coordinates: coord, imageBar: self.currentImageBar, completion: {})
        })
    }

    private func weatherService(coordinates: Coordinates, imageBar: ImageWhiteBar, completion: @escaping () -> Void) {
        WeatherService.shared.getWeather(coord: coordinates,
                                         callback: { (success, result) in
            guard success == true, let res = result else {
                self.presentAlert(titre: "Erreur", message: "Impossible de récupérer la météo de à votre position.")
                imageBar.titleLabel.text = "Inconnu"
                imageBar.subTitleLabel.text = "Météo inconnue."
                return
            }
            imageBar.titleLabel.text = "\(res.city)"
            imageBar.subTitleLabel.text = "\(res.weather)"
            imageBar.imageView.image = UIImage(data: res.image)
            completion()
        })
    }

    private func presentAlert(titre: String, message: String) {
        let alertVC = UIAlertController(title: titre, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
