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
    @IBOutlet weak var weatherNY: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherService.shared.getWeather { (success, jsonObj) in

        }
    }
}
