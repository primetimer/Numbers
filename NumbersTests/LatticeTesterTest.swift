//
//  TetraHedral.swift
//  NumbersTests
//
//  Created by Stephan Jancar on 18.02.18.
//  Copyright © 2018 Stephan Jancar. All rights reserved.
//

import Foundation
import XCTest
import BigInt

@testable import Numbers

class LatticeTest : XCTestCase {
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testWays() {
		let ref = [
			1, 4, 4, 0, 4, 8, 0, 0, 4, 4, 8, 0, 0, 8, 0, 0, 4, 8, 4, 0, 8, 0, 0, 0, 0, 12, 8, 0, 0, 8, 0, 0, 4, 0, 8, 0, 4, 8, 0, 0, 8, 8, 0, 0, 0, 8, 0, 0, 0, 4, 12, 0, 8, 8, 0, 0, 0, 0, 8, 0, 0, 8, 0, 0, 4, 16, 0, 0, 8, 0, 0, 0, 4, 8, 8, 0, 0, 0, 0, 0, 8, 4, 8, 0, 0, 16, 0, 0, 0, 8, 8, 0, 0, 0, 0, 0, 0, 8, 4, 0, 12, 8]
		let t = SumOfTwoSquaresTester()
		for n in 0..<ref.count {
			let r2 = t.r2(n: BigUInt(n))
			let refn = ref[n]
			if refn != Int(r2) {
				print(n,r2,refn)
			}
			XCTAssert(Int(r2) == refn)
		}
	}
}
