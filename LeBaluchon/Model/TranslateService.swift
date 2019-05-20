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

    //Init used for tests
    init(translateSession: URLSession) {
        self.translateSession = translateSession
    }

    //Request to Google Translation API, to translate a text from french to an other language
    func getTranslation(language: String, text: String, callback: @escaping (Bool, TranslationRequest?) -> Void) {

        let components = URLComponents(string: "https://translation.googleapis.com/language/translate/v2")

        guard var comp = components else {
            callback(false, nil)
            return
        }

        comp.queryItems = [URLQueryItem(name: "key", value: ApiKeys.googleTranslateKey),
                                 URLQueryItem(name: "source", value: "fr"),
                                 URLQueryItem(name: "target", value: language),
                                 URLQueryItem(name: "q", value: text)]

        guard let url = comp.url else {
            callback(false, nil)
            return
        }

        var request = URLRequest(url: url)
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
