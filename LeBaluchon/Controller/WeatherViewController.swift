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
    @IBOutlet weak var nameCurrent: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherService.shared.getWeather(coord: Coordinates(latitude: 48.27, longitude: 2.7),
                                         callback: { (success, result) in
            guard success == true, let res = result, res.weather.indices.contains(0) else {
                self.presentAlert(titre: "Erreur", message: "Impossible de récupérer la météo de Nemours.")
                self.weatherNemours.text = "Météo inconnue."
                return
            }
            self.weatherNemours.text = "\(res.main.temp)°C, \(res.weather[0].description)"

            WeatherService.shared.getWeather(coord: Coordinates(latitude: 40.7, longitude: -74),
                                             callback: { (success, result) in
                guard success == true, let res = result, res.weather.indices.contains(0) else {
                    self.presentAlert(titre: "Erreur", message: "Impossible de récupérer la météo de New York.")
                    self.weatherCurrent.text = "Météo inconnue."
                    return
                }
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
