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

    var rate: Double?

    override func viewDidLoad() {
        super.viewDidLoad()
        setRateLabel()
    }

    func setRateLabel() {
        ExchangeRateService.shared.getRate { (success, rateReq) in
            if success, let rateReq = rateReq, let rate = rateReq.rates {
                self.rate = rate.USD
                self.exchangeRateLabel.text = "Taux actuel: \(rate.USD)"
            } else {
                self.rate = nil
                self.presentAlert(titre: "Erreur", message: "Le taux de change EUR/USD n'a pas pu être téléchargé.")
                self.exchangeRateLabel.text = "Inconnu"
            }
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
