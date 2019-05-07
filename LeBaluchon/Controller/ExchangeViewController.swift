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

    override func viewDidLoad() {
        super.viewDidLoad()
        getExchangeRate()
    }

    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "The logo download failed.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

    func getExchangeRate() {
        //toggleActivityIndicator(shown: true)

        ExchangeRateService.shared.getRate { (success, rate) in
            //self.toggleActivityIndicator(shown: false)
            if success, let rate = rate {
                self.exchangeRateLabel.text = "\(rate.USD)"
                print("RATE: \(rate)")
            } else {
                //self.presentAlert()
                self.exchangeRateLabel.text = "Error"
                print("RATE: Error")
            }
        }

    }

    private func toggleActivityIndicator(shown: Bool) {
        //activityIndicator.isHidden = !shown
        //searchButton.isHidden = shown
    }
}
