//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by Kévin Courtois on 06/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var weatherNemours: UILabel!
    @IBOutlet weak var weatherCurrent: UILabel!
    @IBOutlet weak var titleCurrent: UILabel!
    @IBOutlet weak var nameCurrent: UILabel!

    override func viewDidAppear(_ animated: Bool) {
        WeatherService.shared.getWeather(coord: Coordinates(latitude: 48.27, longitude: 2.7),
                                         callback: { (success, result) in
            guard success == true, let res = result, res.weather.indices.contains(0) else {
                self.presentAlert(titre: "Erreur", message: "Impossible de récupérer la météo de Nemours.")
                self.weatherNemours.text = "Météo inconnue."
                return
            }
            self.weatherNemours.text = "\(res.main.temp)°C, \(res.weather[0].description)"

            guard let coord = LocationManager.shared.coordinates else {
                self.presentAlert(titre: "Erreur", message: "Impossible de déterminer votre position.")
                return
            }

            WeatherService.shared.getWeather(coord: coord,
                                             callback: { (success, result) in
                guard success == true, let res = result, res.weather.indices.contains(0) else {
                    self.presentAlert(titre: "Erreur", message: "Impossible de récupérer la météo de à votre position.")
                    self.weatherCurrent.text = "Météo inconnue."
                    return
                }

                self.titleCurrent.text = "\(res.name)"
                self.weatherCurrent.text = "\(res.main.temp)°C, \(res.weather[0].description)"
            })
        })
    }

    private func presentAlert(titre: String, message: String) {
        let alertVC = UIAlertController(title: titre, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
