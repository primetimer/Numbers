//
//  ViewController.swift
//  Numbers
//
//  Created by Stephan Jancar on 03.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import UIKit
import iosMath
import BigInt
import BigFloat
import PrimeFactors
import YouTubePlayer
import GhostTypewriter

class RecordInformation : NSObject {
	var property : String = ""
	var value : String = ""
	var nr : BigUInt = 0
	var info : String = ""
	init(prop : String) {
		self.property = prop
	}
	var link : String? = nil
}

protocol RecordNotification {
	func EmitRecordInfo(record: RecordInformation)
}

protocol RecordTester : NumTester {
	func getRecord(n: BigUInt) -> RecordInformation?
	func getRecordkey(n: BigUInt) -> NSString?
}

/*
extension RecordTester {
	func getRecord(n: BigUInt) -> RecordInformation? {
		return nil
	}
	func getRecordkey(n: BigUInt) -> NSString? {
		return nil
	}
}
*/

extension PrimeTester : RecordTester {
	func getRecord(n: BigUInt) -> RecordInformation? {
		let record = RecordInformation(prop: self.property())
		if  isSpecial(n: n) {
			let yearn = n<BigUInt(2018) ? Int(n) : 2019
			let (year,p) = MersennePrimeHistory.shared.getHistory(year: yearn)
			record.nr = BigUInt(p)
			record.info = "Year " + String(year) + ":\n"
			record.info = record.info + "Largest known Mersenne prime:\n"
			record.info = record.info + "2^" + String(record.nr) + "-1 =\n"
			let m = MersenneDigit(p: UInt(record.nr))
			let s = m.DigitString(cfirst: 100, clast: 1000) //. FirstDigits(count: 10)
			record.value = s
			record.link = "https://en.wikipedia.org/wiki/Largest_known_prime_number"
			return record
		}
		return nil
	}
	func getRecordkey(n: BigUInt) -> NSString? {
		let yearn = n<BigUInt(2018) ? Int(n) : 2019
		let (year,_) = MersennePrimeHistory.shared.getHistory(year: yearn)
		return NSString(string: self.property() + String(year))
	}
}

extension MersenneTester : RecordTester {
	func getRecord(n: BigUInt) -> RecordInformation? {
		let record = RecordInformation(prop: self.property())
		if PrimeTester().isSpecial(n: n) {
			return PrimeTester().getRecord(n: n)
		}
		record.nr = 1277
		record.info = "The smallest composite Mersenne number (March 2018) with unknown factors is 2^" + String(record.nr) + "-1 =\n"
		//record.info = record.info + "1426696511 x 1200534351245458553 x "
		let m = MersenneDigit(p: UInt(record.nr))
		let s = m.DigitString(cfirst: 100, clast: 1000) //. FirstDigits(count: 10)
		record.value = s
		record.link = "https://en.wikipedia.org/wiki/Mersenne_prime#Factorization_of_composite_Mersenne_numbers"
		return record
	}
	func getRecordkey(n: BigUInt) -> NSString? {
		return NSString(string: self.property())
	}
}

class MersennePrimeHistory {
	
	static var shared = MersennePrimeHistory()
	private init() {}
	
	var history : [(year:Int,p:UInt64)] = [(1456,13),(1460,17),(1588,19),(1772,31),(1876,127),(1952,2281),(1957,3217),(1961,4423),
								  (1963,11213),(1971,19937),(1978,21701),(1979,44497),(1982,86243), //Some missing
		(2001,13466917),(2003,20996011),(2004,24036583),(2005,30402457),(2006,32582657),(2008,43112609),(2013,57885161),
		(2016,74207281),(2017,77232917),(2018,77232917)]
	
	private var maxyear = 2018
	
	func getHistory(year: Int) -> (year: Int, p:UInt64) {
		for h in history {
			if h.year >= year {
				return (h.year,h.p)
			}
		}
		let last = history.last!
		return (last.year,last.p)
	}
}

extension ProthTester : RecordTester {
	func getRecord(n: BigUInt) -> RecordInformation? {
		let k : UInt = 10223
		let n : UInt = 31172165
		let record = RecordInformation(prop: self.property())
		let p = ProthDigit(k: k, p: n)
		//record.value = p.DigitString(cfirst: 100, clast: 1000)
		record.info = "The largest known proth prime is p = " + String(k) + " x 2^" + String(n) + " + 1 =\n"
		record.value = p.DigitString(cfirst: 100, clast: 1000) //. FirstDigits(count: 10)

		return record
	}
	func getRecordkey(n: BigUInt) -> NSString? {
		return NSString(string: self.property())
	}
}

extension FermatTester : RecordTester {
	func getRecord(n: BigUInt) -> RecordInformation? {
		let record = RecordInformation(prop: self.property())
		guard let f = BigUInt("115792089237316195423570985008687907853269984665640564039457584007913129639937") else { return nil }
		record.info = "The largest known Fermat prime is = \n"
		record.value = f.asString(toBase: 10)
		return record
	}
	func getRecordkey(n: BigUInt) -> NSString? {
		return NSString(string: self.property())
	}
}

extension SupersingularTester : RecordTester {
	func getRecordkey(n: BigUInt) -> NSString? {
		return NSString(string: self.property() + String(n.hashValue))
	}
	func getRecord(n: BigUInt) -> RecordInformation? {
		let record = RecordInformation(prop: self.property())
		let MStr = "808017424794512875886459904961710757005754368000000000"
		//let M = BigUInt(MStr)
		record.info = String(n) + "is a Divisor of the Order of the Fischer-Griess Monster group (M):"
		record.value = MStr
		return record
	}
	
}

extension MathConstantTester : RecordTester {
	
	func getRecord(n: BigUInt) -> RecordInformation? {
		if let (type,_) = self.FindConst(n: n) {
			let value = type.asString()
			let record = RecordInformation(prop: self.property())
			record.nr = n
			record.value = value
			record.info = "The first digits of " + type.Symbol() + " are:\n"
			return record
		}
		return nil
	}
	
	
	func getRecordkey(n: BigUInt) -> NSString? {
		return NSString(string: self.property() + String(n.hashValue))
	}
}

extension LuckyTester : RecordTester {
	func getRecordkey(n: BigUInt) -> NSString? {
		return NSString(string: self.property() + String(n.hashValue))
	}
	func getRecord(n: BigUInt) -> RecordInformation? {
		let fn = BigFloat(BigInt(n))
		let p = BigFloat(1) / BigFloat.ln(x: fn)
		let record = RecordInformation(prop: self.property())
		record.nr =  n
		record.value = p.asString(10, maxlen: 1000, fix: 1000)
		record.info = "The possibility of beeing lucky is:"
		return record
	}
}

extension SquareTester : RecordTester {
	func getRecordkey(n: BigUInt) -> NSString? {
		return NSString(string: self.property() + String(n.hashValue))
	}
	func getRecord(n: BigUInt) -> RecordInformation? {
		var (n2,nn) = (n,n)
		var symbol = ""
		repeat {
			nn = n2
			n2 = nn.squareRoot()
			symbol = symbol + "√"
		} while n2 * n2 == nn
		
		let f2 = BigFloat(BigInt(nn))
		let r2 = BigFloat.sqrt(x: f2)
		let record = RecordInformation(prop: self.property())
		record.nr = n
		record.value = r2.asString(10, maxlen: 1000, fix: 1000)
		record.info = "The first digits of " + symbol + " are:\n"
		return record
	}
}
	



class RecordChecker {
	
	private var pcache = NSCache<NSString, RecordInformation>()
	static var shared = RecordChecker()
	
	private var tester : [RecordTester] = [MersenneTester(),LuckyTester(),FermatTester(),SupersingularTester(), MathConstantTester(),ProthTester(),SquareTester()]
	
	private init() {
	}
	
	func getInfo(tester : RecordTester, nr : BigUInt,notifier : RecordNotification? = nil) -> RecordInformation? {
		guard let key = tester.getRecordkey(n: nr) else { return nil }
		if let cachep = pcache.object(forKey: key) {
			return cachep
		}
		if let record = tester.getRecord(n: nr) {
			pcache.setObject(record, forKey: key)
			return record
		}
		return nil
	}
	
	func getRecordInfo(nr: BigUInt, notifier : RecordNotification? = nil) -> RecordInformation? {
		for t in tester {
			guard t.isSpecial(n: nr) else { continue }
			if let record = getInfo(tester: t, nr: nr, notifier : nil) {
				notifier?.EmitRecordInfo(record: record)
				return record
			}
		}
		return nil
	}
}

