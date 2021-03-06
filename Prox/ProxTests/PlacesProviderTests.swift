/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import XCTest
import CoreLocation
import MapKit

@testable import Prox

class PlacesProviderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    fileprivate func placesList(number: Int) -> [Place] {
        var places = [Place]()

        let yelpProvider = SinglePlaceProvider(fromDictionary: [:])
        for index in 0..<number {
            let placeID = index + 1

            places.append(Place(id: "\(index)", name: "Place \(placeID)", latLong: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), categories: ([""], ids: [""]), yelpProvider: yelpProvider))
        }

        return places
    }
    
}

// PlaceDataSource implementation tests
extension PlacesProviderTests {

    func testPlaceDataSourceReturnsCorrectNumberOfPlaces() {
        let places = placesList(number: 4)

        let placeDataSource = PlacesProvider(places: places)

        XCTAssertEqual(placeDataSource.numberOfPlaces(), places.count)
    }

    func testPlaceDataSourceReturnsCorrectPlaceForIndex() {
        let places = placesList(number: 4)
        let placeDataSource = PlacesProvider(places: places)

        let requestedIndex = 2

        let thirdPlace = try? placeDataSource.place(forIndex: requestedIndex)
        XCTAssertNotNil(thirdPlace)

        XCTAssertEqual(thirdPlace!.id, "\(requestedIndex)")
    }

    func testPlaceDataSourceThrowsErrorOnOutOfBoundsIndex() {
        let places = placesList(number: 4)
        let placeDataSource = PlacesProvider(places: places)

        XCTAssertThrowsError(try placeDataSource.place(forIndex: 4))
        XCTAssertThrowsError(try placeDataSource.place(forIndex: -1))
    }

    func testPlaceDataSourceReturnsCorrectNextPlace() {
        let places = placesList(number: 4)
        let placeDataSource = PlacesProvider(places: places)

        // test with known next place
        var requestedIndex = 0
        var currentPlace = places[requestedIndex]
        // should be 1
        XCTAssertEqual(currentPlace.id, "\(requestedIndex)")
        var nextPlace = placeDataSource.nextPlace(forPlace: currentPlace)
        // should be 2
        XCTAssertNotNil(nextPlace)
        XCTAssertEqual(nextPlace!.id, "\(requestedIndex + 1)")

        // test with known no next place
        requestedIndex = places.endIndex - 1
        currentPlace = places[requestedIndex]
        nextPlace = placeDataSource.nextPlace(forPlace: currentPlace)
        XCTAssertNil(nextPlace)
    }

    func testPlaceDataSourceReturnsCorrectPreviousPlace() {
        let places = placesList(number: 4)
        let placeDataSource = PlacesProvider(places: places)

        // test with known next place
        var requestedIndex = 3
        var currentPlace = places[requestedIndex]
        // should be 4
        XCTAssertEqual(currentPlace.id, "\(requestedIndex)")
        var previousPlace = placeDataSource.previousPlace(forPlace: currentPlace)
        XCTAssertNotNil(previousPlace)
        // should be 3
        XCTAssertEqual(previousPlace!.id, "\(requestedIndex - 1)")

        // test with known no next place
        requestedIndex = places.startIndex
        currentPlace = places[requestedIndex]
        previousPlace = placeDataSource.previousPlace(forPlace: currentPlace)
        XCTAssertNil(previousPlace)
    }

}
