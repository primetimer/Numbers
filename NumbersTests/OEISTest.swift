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

class OEISTests : XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOEISConsistency() {
		for t in Tester.shared.testers {
			if let seq = OEIS.shared.seq[t.property()] {
				for n in seq {
					if n == 0 { continue }
					let istest = t.isSpecial(n: n)
					print(t.property(),String(n))
					if !istest {
						print(t.property(), String(n))
					}
					XCTAssert(istest == true)
				}
			}
		}
		
    }
	
	func testOEIS100() {
		for t in Tester.shared.testers {
			if let seq = OEIS.shared.seq[t.property()] {
				for i in 1...100 {
					let n = BigUInt(i)
					let istest = t.isSpecial(n: n)
					let iscontained = seq.contains(n)
					//print(t.property(),String(n))
					
					XCTAssert(istest == iscontained)
					if istest != iscontained {
						print(t.property(), String(n))
						break
					}
				}
			}
		}
		
	}
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
