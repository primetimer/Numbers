
//  NumbersTests
//
//  Created by Stephan Jancar on 18.02.18.
//  Copyright © 2018 Stephan Jancar. All rights reserved.
//

import Foundation
import XCTest
import BigInt

@testable import Numbers

class TestSumOfCubes : XCTestCase {
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testSum3() {
		let t = SumOfTwoCubesTester()
		do {
			let n0 : BigUInt = 1027
			let (a,b) = t.Express(n: n0)!
			let n = Int(a*a*a+b*b*b)
			print(a,b,a*a,b*b,n,n0)
			XCTAssert(n == n0)
		}
		do {
			let n0 : BigUInt = 1729
			let (a,b) = t.Express(n: n0)!
			let n = Int(a*a*a+b*b*b)
			print(a,b,a*a*a,b*b*b,n,n0)
			XCTAssert(n == n0)
		}
		do {
			let n0 : BigUInt = 8*1729
			let (a,b) = t.Express(n: n0)!
			let n = Int(a*a*a+b*b*b)
			print(a,b,a*a*a,b*b*b,n,n0)
			XCTAssert(n == n0)
		}
		do {
			let n0 : BigUInt = 8*125*1729
			let (a,b) = t.Express(n: n0)!
			let n = Int(a*a*a+b*b*b)
			print(a,b,a*a*a,b*b*b,n,n0)
			XCTAssert(n == n0)
		}
		do {
			let n0 : BigUInt = 9
			let (a,b) = t.Express(n: n0)!
			let n = Int(a*a*a+b*b*b)
			print(a,b,a*a*a,b*b*b,n,n0)
			XCTAssert(n == n0)
		}
		do {
			let n0 : BigUInt = 16
			let (a,b) = t.Express(n: n0)!
			let n = Int(a*a*a+b*b*b)
			print(a,b,a*a*a,b*b*b,n,n0)
			XCTAssert(n == n0)
		}
		do {
			let n0 : BigUInt = 704977
			let (a,b) = t.Express(n: n0)!
			let n = Int(a*a*a+b*b*b)
			print(a,b,a*a*a,b*b*b,n,n0)
			XCTAssert(n == n0)
		}
		
	}
}
