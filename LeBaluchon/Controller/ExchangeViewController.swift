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

    func getExchangeRate() {
        ExchangeRateService.shared.getRate { (success, rateReq) in
            if success, let rateReq = rateReq, let rate = rateReq.rates {
                self.exchangeRateLabel.text = "\(rate.USD)"
            } else {
                //self.presentAlert()
                self.exchangeRateLabel.text = "Error"
            }
        }

    }

    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "The logo download failed.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
