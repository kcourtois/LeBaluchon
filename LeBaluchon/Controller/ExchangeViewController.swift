//
//  ExchangeViewController.swift
//  LeBaluchon
//
//  Created by Kévin Courtois on 06/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import UIKit

class ExchangeViewController: UIViewController {

    @IBOutlet weak var eurosTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var symbolCurrency: UILabel!
    @IBOutlet weak var imageWhiteBar: ImageWhiteBar!

    var rates: RateRequest?
    var code: String?

    override func viewDidAppear(_ animated: Bool) {
        setRateLabel()
        imageWhiteBar.titleLabel.text = "Conversion d'Euros"
        imageWhiteBar.imageView.image = #imageLiteral(resourceName: "bourse")
    }

    //Retrieves rate for local currency
    func setRateLabel() {
        ExchangeRateService.shared.getRate { (success, result) in
            guard success, let exRes = result else {
                self.rates = nil
                self.presentAlert(titre: "Erreur", message: "Le taux de change n'a pas pu être téléchargé.")
                self.imageWhiteBar.subTitleLabel.text = "Inconnu"
                return
            }
            self.rates = exRes
            self.geocodeService()
        }
    }

    //API Call to retrive local country
    private func geocodeService() {
        guard let coord = LocationManager.shared.coordinates else {
            self.presentAlert(titre: "Erreur", message: "Impossible de déterminer votre position.")
            return
        }
        GeocodeService.shared.getGeocode(coord: coord, callback: { (success, result) in
            guard success, let geoRes = result,
                let country = geoRes.plus_code.compound_code.split(separator: " ").last else {
                    self.presentAlert(titre: "Erreur", message: "Impossible de déterminer votre position.")
                    return
            }
            self.countryService(country: String(country))
        })
    }

    //API Call to retrieve local currency
    private func countryService(country: String) {
        CountryService.shared.getCountryInfo(country: country, callback: { (success, result) in
            guard success, let countryRes = result else {
                self.presentAlert(titre: "Erreur", message: "Impossible de déterminer votre position.")
                return
            }

            self.code = countryRes.currencies[0].code

            guard let rates = self.rates, let code = self.code, let rate = rates.rates[code] else {
                self.presentAlert(titre: "Erreur", message: "Le taux de change n'a pas pu être téléchargé.")
                return
            }

            self.imageWhiteBar.subTitleLabel.text = "Taux actuel: \(rate)"
            self.symbolCurrency.text = countryRes.currencies[0].symbol
        })
    }

    @IBAction func convertEurToUSD() {
        eurosTextField.resignFirstResponder()
        guard let rates = self.rates, let code = self.code, let rate = rates.rates[code] else {
            presentAlert(titre: "Erreur", message: "Le taux de change n'a pas pu être téléchargé.")
            return
        }
        guard let txt = eurosTextField.text, let valueToConvert = Double(txt) else {
            presentAlert(titre: "Erreur", message: "Impossible d'effectuer la conversion.")
            return
        }

        eurLabel.text = "\(valueToConvert)"
        resultLabel.text = "\(String(format: "%.2f", valueToConvert*rate))"
    }

    //Creates an alert with a title and a message
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
