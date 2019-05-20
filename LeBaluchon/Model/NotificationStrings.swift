//
//  NotificationStrings.swift
//  LeBaluchon
//
//  Created by Kévin Courtois on 20/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation

class NotificationStrings {
    static let didFoundLocationParameterKey: String = "locationFound"
}

extension Notification.Name {
    static let didFoundLocation = Notification.Name("didFoundLocation")
}
