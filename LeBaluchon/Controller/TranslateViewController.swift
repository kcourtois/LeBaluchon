//
//  TranslateViewController.swift
//  LeBaluchon
//
//  Created by Kévin Courtois on 06/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {

    @IBOutlet weak var userTextView: UITextView!
    @IBOutlet weak var resultTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        userTextView.textColor = UIColor.lightGray
        resultTextView.textColor = UIColor.lightGray
    }

    @IBAction func translateText() {
        userTextView.resignFirstResponder()

        getTranslation()
    }

    private func getTranslation() {
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

    private func countryService(country: String) {
        CountryService.shared.getCountryInfo(country: country, callback: { (success, result) in
            guard success, let countryRes = result, countryRes.languages.indices.contains(0) else {
                self.presentAlert(titre: "Erreur", message: "Impossible de déterminer votre position.")
                return
            }

            self.translateService(language: countryRes.languages[0].iso639_1)
        })
    }

    private func translateService(language: String) {
        guard let text = userTextView.text else {
            self.presentAlert(titre: "Erreur", message: "Pas de texte à traduire !")
            return
        }

        TranslateService.shared.getTranslation(language: language,
                                               text: text, callback: { (success, result) in
            guard success == true, let res = result, res.data.translations.indices.contains(0)  else {
                self.presentAlert(titre: "Erreur",
                                  message: "Nous n'avons pas réussi à traduire le texte.")
                return
            }

            self.resultTextView.text = res.data.translations[0].translatedText
            self.resultTextView.textColor = UIColor.black
        })
    }

    private func presentAlert(titre: String, message: String) {
        let alertVC = UIAlertController(title: titre, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

extension TranslateViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Entrez votre texte ici"
            textView.textColor = UIColor.lightGray
        }
    }

    @IBAction func dismissKeyboard(_ sender: Any) {
        userTextView.resignFirstResponder()
    }
}
