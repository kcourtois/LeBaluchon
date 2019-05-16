//
//  GoogleTranslateService.swift
//  LeBaluchon
//
//  Created by Kévin Courtois on 09/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation

struct TranslationRequest: Codable {
    let data: TranslationData
}

struct TranslationData: Codable {
    let translations: [Translation]
}

struct Translation: Codable {
    let translatedText: String
}

class TranslateService {
    static var shared = TranslateService()
    private var translateSession = URLSession(configuration: .default)
    private var task: URLSessionDataTask?
    private init() {}

    init(translateSession: URLSession) {
        self.translateSession = translateSession
    }

    func getTranslation(language: String, text: String, callback: @escaping (Bool, TranslationRequest?) -> Void) {
        // swiftlint:disable:next line_length
        let translateUrl = URL(string: "https://translation.googleapis.com/language/translate/v2?key=\(ApiKeys.googleTranslateKey)&source=fr&target=\(language)&q=\(text.replacingOccurrences(of: " ", with: "+"))")!
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

                callback(true, responseJSON)
            }
        }
        task?.resume()
    }
}
