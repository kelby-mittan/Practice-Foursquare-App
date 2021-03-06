//
//  Practice_Foursquare_AppTests.swift
//  Practice-Foursquare-AppTests
//
//  Created by Kelby Mittan on 2/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import XCTest
@testable import Practice_Foursquare_App

class Practice_Foursquare_AppTests: XCTestCase {

    func testAPIClient() {
        
//        let expectedLatitude = 40.745835357994196
        let expTitle = "Ruth's Chris Steak House"
        
        FoursquareAPIClient.getVenues(location: "new york", search: "steak house") { (result) in
            switch result {
            case .failure(let error):
                XCTFail("error: \(error)")
            case .success(let venues):
                let title = venues.first?.name
                dump(venues)
                XCTAssertEqual(expTitle, title)
            }
        }
    }

}
