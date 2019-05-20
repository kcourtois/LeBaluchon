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

    //Func used to translate a text from french to user's current country language
    private func getTranslation() {
        guard let coord = LocationManager.shared.coordinates else {
            self.presentAlert(titre: "Erreur", message: "Impossible de déterminer votre position.")
            return
        }

        //API Call to get local country
        GeocodeService.shared.getGeocode(coord: coord, callback: { (success, result) in
            guard success, let geoRes = result,
                let country = geoRes.plus_code.compound_code.split(separator: " ").last else {
                    self.presentAlert(titre: "Erreur", message: "Impossible de déterminer votre position.")
                    return
            }
            self.countryService(country: String(country))
        })
    }

    //API Call to get country informations such as language or currency
    private func countryService(country: String) {
        CountryService.shared.getCountryInfo(country: country, callback: { (success, result) in
            guard success, let countryRes = result, countryRes.languages.indices.contains(0) else {
                self.presentAlert(titre: "Erreur", message: "Impossible de déterminer votre position.")
                return
            }

            self.translateService(language: countryRes.languages[0].iso639_1)
        })
    }

    //API Call to get translated text from french to local language
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

    //Creates an alert with a title and a message
    private func presentAlert(titre: String, message: String) {
        let alertVC = UIAlertController(title: titre, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

//Used to handle keyboard dismiss and create a placeholder
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
