//
//  NumbersTests.swift
//  NumbersTests
//
//  Created by Stephan Jancar on 03.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import XCTest
import BigInt
@testable import Numbers

class WikiTests : XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testWikiConsistency() {
		for t in Tester.shared.testers {
			let wiki = WikiLinks.shared.Link(key: t.property())
			if wiki.isEmpty {
				print("Unlinked:",t.property())
			}
			XCTAssert(!wiki.isEmpty)
		}
	}
    
    func testOEISConsistency() {
		for t in Tester.shared.testers {
			let oeis = OEIS.shared.OEISNumber(key: t.property())
			if oeis == nil {
				print("Unlinked OEIS:",t.property())
			}
			XCTAssert(oeis != nil)
		}
    }
}
