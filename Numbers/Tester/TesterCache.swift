//
//  TesterCache.swift
//  Numbers
//
//  Created by Stephan Jancar on 18.02.18.
//  Copyright © 2018 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt

class TestResult : NSObject {
	var special : Bool
	var desc : String?
	var latex : String?
	var property : String
	
	init(special : Bool, desc: String?,latex: String?, property: String) {
		self.special = special
		self.desc = desc
		self.latex = latex
		self.property = property
	}
	
	init(tester : NumTester, n: BigUInt) 	{
		self.special = tester.isSpecial(n: n)
		self.desc = tester.getDesc(n: n)
		self.latex = tester.getLatex(n: n)
		self.property = tester.property()
	}
}

class TesterCache  {
	
	private func Test(tester: NumTester, n: BigUInt) -> TestResult {
		let nsstr = NSString(string: tester.property() + ":" + String(n.hashValue))
		if let cachep = pcache.object(forKey: nsstr) {
			return cachep
		}
		
		let result = TestResult(tester: tester, n: n)
		pcache.setObject(result, forKey: nsstr)
		return result
	}

	func isSpecial(tester : NumTester, n: BigUInt) -> Bool {
		return Test(tester: tester,n: n).special
	}
	
	func getDesc(tester: NumTester,n: BigUInt) -> String? {
		return Test(tester: tester,n:n).desc
	}
	
	func getLatex(tester: NumTester,n: BigUInt) -> String? {
		return Test(tester: tester, n:n).latex
	}
	
	func property(tester: NumTester) -> String {
		return tester.property()
	}

	private var pcache = NSCache<NSString, TestResult>()
	static public var shared = TesterCache()
	private init() {}
}
