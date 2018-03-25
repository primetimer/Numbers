//
//  MersenneDigit.swift
//  Numbers
//
//  Created by Stephan Jancar on 21.03.18.
//  Copyright © 2018 Stephan Jancar. All rights reserved.
//


//
//  MersenneDigit.swift
//  PrimeTime
//
//  Created by Stephan Jancar on 28.01.17.
//  Copyright © 2017 esjot. All rights reserved.
//

import Foundation
import BigInt
import BigFloat

extension BigUInt {
	func NumberString() -> String {
		return self.asString(toBase: 10)
	}
}

extension BigFloat {
	func FloorDown() -> BigFloat {
		var s = self.significand
		var e = self.exponent
		while e < 0 {
			s = s >> 1
			e = e + 1
		}
		return BigFloat(s)
	}
}
protocol ObserveLucasTest {
	func NeedObservation() -> Bool
	func NeedStop() -> Bool
	func ObserveLucas(nr: UInt64, lucas : BigUInt)
}

class MersenneDigit {
	private var p : UInt
	private var m : BigUInt
	
	init(p : UInt) {
		self.p = p
		self.m = BigUInt(1) << BigUInt(p) - 1
	}
	
	var lucasdelegate : ObserveLucasTest? = nil
	func IsPrime() -> Bool? {
		let isprime = PrimeTester().isSpecial(n: BigUInt(p))
		if isprime == false { return false }
		
		var s:BigUInt = 4
		let d = m
		let n = BigUInt(p)
		for o in 0..<(p-2) {
			// s = (s * s - 2) % d  // BigUInt is used to avoid overflow at s * s
			let s2 = s * s
			s = (s2 & d) + (s2 >> n)
			if d <= s { s -= d }
			s -= 2
			
			if lucasdelegate != nil {
				if lucasdelegate!.NeedStop() { return nil }
				if lucasdelegate!.NeedObservation() {
					lucasdelegate?.ObserveLucas(nr: UInt64(o+1), lucas: s)
				}
			}
			// print(i, s.toString(16))
		}
		lucasdelegate?.ObserveLucas(nr: UInt64(p-1), lucas: s)
		return s == 0
	}
	
	func LastDigits(pow10: Int) -> BigUInt {
		let two = BigUInt(2)
		let ten = BigUInt(10)
		//let p10 = BigUInt(pow10)
		
		if pow10 == 0 { return BigUInt(0) }
		let tenpow = ten.power(Int(pow10))
		let bigp = BigUInt(p)
		let mp = two.power(bigp, modulus: tenpow)
		
		let ret = (mp - BigUInt(1)) % tenpow
		return ret
	}
	
	func FirstDigits(count: Int) -> BigUInt {
		
		let ndig = count
		//let p = 77232917
		let m = BigInt(1) << p - 1
		let ten = BigFloat(10)
		let l2 = BigFloat.ln(x: BigFloat(2))
		let l10 = BigFloat.ln(x: BigFloat(10))
		let ppp = BigFloat(BigInt(p))
		let l = l2 / l10 * ppp
		
		/*
		if l <= Double(count) {
		let ret = pow(10.0,l) - 1.0
		let dig = BigUInt(UInt64(ret))
		return dig
		}
		*/
		
		let frac = l - l.FloorDown()
		let frac2 = frac + BigFloat(ndig-1)
		let ret = BigFloat.pow(x: ten,y: frac2)
		let retf = ret.FloorDown()
		//let dig = retf.asString(10, maxlen: ndig, fix: 0)
		let (dig,_) = retf.SplitIntFract()
		return BigUInt(dig)
	}
	
	func CountDigits() -> Int {
		let l = log(2) / log(10) * Double(p)
		let count = Int(l)
		return count
	}
}

extension MersenneDigit {
	func DigitString(cfirst : Int, clast: Int) -> String {
		if cfirst + clast == 0 {
			return "....."
		}
		if clast == 0 {
			let firstdig = FirstDigits(count: cfirst)
			let firststr = firstdig.NumberString()
			return firststr
		}
		
		let c = CountDigits()
		let first = cfirst // min(cfirst,10)
		if first >= c {
			return m.NumberString()
		}
		if cfirst + clast >= c {
			return m.NumberString()
		}
		
		let last = min(c - first, clast)
		let firstdig = FirstDigits(count: first)
		let lastdig = LastDigits(pow10: last)
		
		if cfirst == 0 {
			return "....." + lastdig.NumberString()
		}
		
		let firststr = firstdig.NumberString()
		let laststr = lastdig.NumberString()
		let ret = firststr + "....." + laststr
		return ret
		
	}
}

class ProthDigit {
	private var p : UInt
	private var k : UInt

	init(k: UInt, p : UInt) {
		self.p = p
		self.k = k
		//self.m = BigUInt(1) << BigUInt(p) - 1
	}

	func LastDigits(pow10: Int) -> BigUInt {
		let two = BigUInt(2)
		let ten = BigUInt(10)
		if pow10 == 0 { return BigUInt(0) }
		let tenpow = ten.power(Int(pow10))
		let bigp = BigUInt(p)
		let mp = BigUInt(k) * two.power(bigp, modulus: tenpow)
		
		let ret = (mp + BigUInt(1)) % tenpow
		return ret
	}
	
	func FirstDigits(count: Int) -> BigUInt {
		let ndig = count
		let ten = BigFloat(10)
		let l2 = BigFloat.ln(x: BigFloat(2))
		let l10 = BigFloat.ln(x: BigFloat(10))
		let lk = BigFloat.ln(x: BigFloat(Int(k)))
		let ppp = BigFloat(BigInt(p))
		let l = l2 / l10 * ppp + lk / l10
		
		let frac = l - l.FloorDown()
		let frac2 = frac + BigFloat(ndig-1)
		let ret = BigFloat.pow(x: ten,y: frac2)
		let retf = ret.FloorDown()
		//let dig = retf.asString(10, maxlen: ndig, fix: 0)
		let (dig,_) = retf.SplitIntFract()
		return BigUInt(dig)
	}
	
	func CountDigits() -> Int {
		let l = log(2) / log(10) * Double(p) + log(Double(k)) / log(10)
		let count = Int(l)
		return count
	}
}

extension ProthDigit {
	func DigitString(cfirst : Int, clast: Int) -> String {
		if cfirst + clast == 0 {
			return "....."
		}
		if clast == 0 {
			let firstdig = FirstDigits(count: cfirst)
			let firststr = firstdig.NumberString()
			return firststr
		}
		
		let c = CountDigits()
		let first = cfirst // min(cfirst,10)
		if cfirst + clast >= c  {
			let m = BigUInt(1) << BigUInt(p)
			let n = BigUInt(k) * m + BigUInt(1)
			return n.NumberString()
		}
		
		let last = min(c - first, clast)
		let firstdig = FirstDigits(count: first)
		let lastdig = LastDigits(pow10: last)
		
		if cfirst == 0 {
			return "....." + lastdig.NumberString()
		}
		
		let firststr = firstdig.NumberString()
		let laststr = lastdig.NumberString()
		let ret = firststr + "....." + laststr
		return ret
		
	}
}



