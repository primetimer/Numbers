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

class TestLucky : XCTestCase {
	override func setUp() {
		super.setUp()
		while LuckyArr.shared.completed == false {
			sleep(1)
			print("Wait for LuckyArr setup:", LuckyArr.shared.last)
		}
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testLucky() {
		let t = LuckyTester()
		do {
			let n = BigUInt(3)
			let isspecial = t.isSpecial(n: n)
			XCTAssert(isspecial == true)
		}
		do {
			let n = BigUInt(897)
			let isspecial = t.isSpecial(n: n)
			XCTAssert(isspecial == true)
		}
		do {
			let n = BigUInt(19)
			let isspecial = t.isSpecial(n: n)
			XCTAssert(isspecial == false)
		}
		do {
			let n = BigUInt(2001)
			let isspecial = t.isSpecial(n: n)
			XCTAssert(isspecial == true)
		}
		do {
			let n = BigUInt(131361)
			let isspecial = t.isSpecial(n: n)
			XCTAssert(isspecial == true)
		}
	}
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}
}
