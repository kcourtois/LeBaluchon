//
//  WeatherTests.swift
//  LeBaluchonTests
//
//  Created by Kévin Courtois on 10/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation
@testable import LeBaluchon
import XCTest

class WeatherTests: XCTestCase {

    func testGetWeatherShouldPostFailedCallback() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(city: .nemours, callback: { (success, weather) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfNoData() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(city: .nemours, callback:  { (success, weather) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(
                data: FakeResponseData.weatherCorrectData,
                response: FakeResponseData.responseKO,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(city: .nemours, callback:  { (success, weather) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(
                data: FakeResponseData.incorrectData,
                response: FakeResponseData.responseOK,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(city: .nemours, callback:  { (success, weather) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(
                data: FakeResponseData.weatherCorrectData,
                response: FakeResponseData.responseOK,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(city: .nemours, callback:  { (success, result) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(result)

            let name = "Nemours"
            let idWeather = 803
            let main = "Clouds"
            let description = "broken clouds"
            let icon = "04d"

            XCTAssertEqual(name, result?.name)
            XCTAssertEqual(idWeather, result?.weather[0].id)
            XCTAssertEqual(main, result?.weather[0].main)
            XCTAssertEqual(description, result?.weather[0].description)
            XCTAssertEqual(icon, result?.weather[0].icon)

            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }
}
