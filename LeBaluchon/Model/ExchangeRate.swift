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

    func getEurToUsd(value: Double) -> Double? {
        guard let rate = rate else {
            return nil
        }
        return value*rate
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
