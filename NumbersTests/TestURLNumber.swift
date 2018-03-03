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

extension String {
	func index(of string: String, options: CompareOptions = .literal) -> Index? {
		return range(of: string, options: options)?.lowerBound
	}
	func endIndex(of string: String, options: CompareOptions = .literal) -> Index? {
		return range(of: string, options: options)?.upperBound
	}
	func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
		var result: [Index] = []
		var start = startIndex
		while let range = range(of: string, options: options, range: start..<endIndex) {
			result.append(range.lowerBound)
			start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
		}
		return result
	}
	func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
		var result: [Range<Index>] = []
		var start = startIndex
		while let range = range(of: string, options: options, range: start..<endIndex) {
			result.append(range)
			start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
		}
		return result
	}
}

class TestURLNumber : XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testURL() {
		do {
			let str = "https://en.wikipedia.org/wiki/42_(number).xxx"
			let nr = WikiLinks.shared.ExtractLinkToNumber(url : str)
			print(nr!)
			XCTAssert(nr == 42)
		}

	}
}
