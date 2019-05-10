//
//  GoogleTranslateService.swift
//  LeBaluchon
//
//  Created by Kévin Courtois on 09/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation

struct TranslationRequest: Decodable {
    let data: TranslationData
}

struct TranslationData: Decodable {
    let translations: [Translation]
}

struct Translation: Decodable {
    let translatedText: String
}

class TranslateService {
    static var shared = TranslateService()
    private var translateSession = URLSession(configuration: .default)
    // swiftlint:disable:next line_length
    private let translateUrl = URL(string: "https://translation.googleapis.com/language/translate/v2?key=\(ApiKeys.googleTranslateKey)&source=fr&target=en&q=bonjour")!
    private var task: URLSessionDataTask?
    private init() {}

    init(translateSession: URLSession) {
        self.translateSession = translateSession
    }

    func getTranslation(callback: @escaping (Bool, TranslationRequest?) -> Void) {
        var request = URLRequest(url: translateUrl)
        request.httpMethod = "POST"

        task?.cancel()
        task = translateSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }

                guard let responseJSON = try? JSONDecoder().decode(TranslationRequest.self, from: data) else {
                    callback(false, nil)
                    return
                }

                print(responseJSON.data.translations[0].translatedText)
                callback(true, responseJSON)
            }
        }
        task?.resume()
    }
}
