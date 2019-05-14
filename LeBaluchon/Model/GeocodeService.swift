//
//  GeocodeService.swift
//  LeBaluchon
//
//  Created by Kévin Courtois on 14/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation

struct GeocodeRequest: Decodable {
    // swiftlint:disable:next identifier_name
    let plus_code: PlusCode
}

struct PlusCode: Decodable {
    // swiftlint:disable:next identifier_name
    let compound_code: String
}

class GeocodeService {
    static var shared = GeocodeService()
    private var geocodeSession = URLSession(configuration: .default)
    private var task: URLSessionDataTask?
    private init() {}

    init(geocodeSession: URLSession) {
        self.geocodeSession = geocodeSession
    }

    func getGeocode(coord: Coordinates, callback: @escaping (Bool, GeocodeRequest?) -> Void) {
        // swiftlint:disable:next line_length
        let geocodeUrl = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(coord.latitude),\(coord.longitude)&key=\(ApiKeys.googleTranslateKey)&result_type=country")!
        var request = URLRequest(url: geocodeUrl)
        request.httpMethod = "GET"

        task?.cancel()
        task = geocodeSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }

                guard let responseJSON = try? JSONDecoder().decode(GeocodeRequest.self, from: data) else {
                    callback(false, nil)
                    return
                }

                callback(true, responseJSON)
            }
        }
        task?.resume()
    }
}
