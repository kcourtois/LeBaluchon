//
//  ExchangeViewController.swift
//  LeBaluchon
//
//  Created by Kévin Courtois on 06/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import UIKit

class ExchangeViewController: UIViewController {

    @IBOutlet weak var exchangeRateLabel: UILabel!
    @IBOutlet weak var eurosTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var symbolCurrency: UILabel!

    var rate: Double?
    let locationManager = LocationManager()

    override func viewDidAppear(_ animated: Bool) {
        setRateLabel()
    }

    func setRateLabel() {
        ExchangeRateService.shared.getRate { (success, result) in
            guard success, let exRes = result else {
                self.rate = nil
                self.presentAlert(titre: "Erreur", message: "Le taux de change n'a pas pu être téléchargé.")
                self.exchangeRateLabel.text = "Inconnu"
                return
            }

            guard let coord = self.locationManager.coordinates else {
                self.presentAlert(titre: "Erreur", message: "Impossible de déterminer votre position.")
                return
            }

            GeocodeService.shared.getGeocode(coord: coord, callback: { (success, result) in

                guard success, let geoRes = result,
                    let country = geoRes.plus_code.compound_code.split(separator: " ").last else {
                        self.presentAlert(titre: "Erreur", message: "Impossible de déterminer votre position.")
                        return
                }

                CountryService.shared.getCountryInfo(country: String(country), callback: { (success, result) in
                    guard success, let countryRes = result, let rate = exRes.rates[countryRes.currencies[0].code] else {
                        self.presentAlert(titre: "Erreur", message: "Impossible de déterminer votre position.")
                        return
                    }

                    self.rate = rate
                    self.exchangeRateLabel.text = "Taux actuel: \(rate)"
                    self.symbolCurrency.text = countryRes.currencies[0].symbol
                })
            })
        }
    }

    @IBAction func convertEurToUSD() {
        eurosTextField.resignFirstResponder()
        guard let txt = eurosTextField.text, let valueToConvert = Double(txt), let rate = rate else {
            presentAlert(titre: "Erreur", message: "Impossible d'effectuer la conversion.")
            return
        }

        eurLabel.text = "\(valueToConvert)"
        resultLabel.text = "\(String(format: "%.2f", valueToConvert*rate))"
    }

    private func presentAlert(titre: String, message: String) {
        let alertVC = UIAlertController(title: titre, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - Keyboard
extension ExchangeViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: Any) {
        eurosTextField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
