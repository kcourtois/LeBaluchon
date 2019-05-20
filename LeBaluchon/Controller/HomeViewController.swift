//
//  HomeViewController.swift
//  LeBaluchon
//
//  Created by Kévin Courtois on 20/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        canTapNext(true)
        nextTapped()
    }

    override func viewDidAppear(_ animated: Bool) {
        //Notification observer for didSendAlert
        NotificationCenter.default.addObserver(self, selector: #selector(onDidFoundLocation(_:)),
                                               name: .didFoundLocation, object: nil)
    }

    //Triggers on notification didSendAlert
    @objc private func onDidFoundLocation(_ notification: Notification) {
        performSegue(withIdentifier: "segueToApp", sender: nil)
    }

    @IBAction func nextTapped() {
        switch LocationManager.shared.canGetLocation() {
        case .noAccess:
            canTapNext(true)
            presentPermissionDeniedAlert()
        case .loading:
            canTapNext(false)
        case .done:
            performSegue(withIdentifier: "segueToApp", sender: nil)
        }
    }

    private func canTapNext(_ canDo: Bool) {
        if canDo {
            nextButton.isHidden = false
            activityIndicator.isHidden = true
        } else {
            nextButton.isHidden = true
            activityIndicator.isHidden = false
        }
    }

    private func presentAlert(titre: String, message: String) {
        let alertVC = UIAlertController(title: titre, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

    //Shows a popup to access settings if user denied location permission
    private func presentPermissionDeniedAlert() {
        //Initialisation of the alert
        let alertController = UIAlertController(title: "Permission refusée",
                                                message: "Merci d'aller dans les Réglages pour activer" +
                                                " la localisation.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Réglages", style: .default) { (_) -> Void in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (_) in })
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Annuler", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        //Shows alert
        present(alertController, animated: true, completion: nil)
    }
}
