//
//  GeocodeTests.swift
//  LeBaluchonTests
//
//  Created by Kévin Courtois on 14/05/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation
@testable import LeBaluchon
import XCTest

class GeocodeTests: XCTestCase {

    func testGetGeocodeShouldPostFailedCallback() {
        // Given
        let geocodeService = GeocodeService(
            geocodeSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        geocodeService.getGeocode(coord: Coordinates(latitude: 40.785091, longitude: -73.968285),
                                  callback: { (success, geocode) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(geocode)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetGeocodeShouldPostFailedCallbackIfNoData() {
        // Given
        let geocodeService = GeocodeService(
            geocodeSession: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        geocodeService.getGeocode(coord: Coordinates(latitude: 40.785091, longitude: -73.968285),
                                  callback: { (success, geocode) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(geocode)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetGeocodeShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let geocodeService = GeocodeService(
            geocodeSession: URLSessionFake(
                data: FakeResponseData.geocodeCorrectData,
                response: FakeResponseData.responseKO,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        geocodeService.getGeocode(coord: Coordinates(latitude: 40.785091, longitude: -73.968285),
                                  callback: { (success, geocode) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(geocode)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetGeocodeShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let geocodeService = GeocodeService(
            geocodeSession: URLSessionFake(
                data: FakeResponseData.incorrectData,
                response: FakeResponseData.responseOK,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        geocodeService.getGeocode(coord: Coordinates(latitude: 40.785091, longitude: -73.968285),
                                  callback: { (success, geocode) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(geocode)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetGeocodeShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let geocodeService = GeocodeService(
            geocodeSession: URLSessionFake(
                data: FakeResponseData.geocodeCorrectData,
                response: FakeResponseData.responseOK,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        geocodeService.getGeocode(coord: Coordinates(latitude: 40.785091, longitude: -73.968285),
                                  callback: { (success, response) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(response)

            let geocodeText = "Q2PJ+2M New York, NY, USA"

            XCTAssertEqual(geocodeText, response?.plus_code.compound_code)

            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }
}
