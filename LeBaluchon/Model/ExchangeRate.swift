//
//  ExchangeRate.swift
//  LeBaluchon
//
//  Created by Kévin Courtois on 09/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation

class ExchangeRate {
    var rate: Double?

    init() {
        getExchangeRate()
    }

    private func getExchangeRate() {
        ExchangeRateService.shared.getRate { (success, rateReq) in
            if success, let rateReq = rateReq, let rate = rateReq.rates {
                self.rate = rate.USD
            } else {
                self.rate = nil
            }
        }
    }
}
