//
//  AbundanceTester.swift
//  Numbers
//
//  Created by Stephan Jancar on 11.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt
import PrimeFactors

class SumOfTwoSquaresTester : NumTester {
	
	func getDesc(n: BigUInt) -> String? {
		let desc = WikiLinks.shared.getLink(tester: self, n: n)
		return desc
	}
	
	
	func getLatex(n: BigUInt) -> String? {
		if !isSpecial(n: n) { return nil }
		if let (a,b) = Express(n: n) {
			let stra = String(a)
			let strb = String(b)
			let latex = String(n) + "=" + stra + "^2 + " + strb + "^2"
			return latex
		}
		return nil
	}
	func property() -> String {
		return "sum of two squares"
	}
	
	private func mods(_ a: BigInt, _ n: BigInt) -> BigInt {
		assert(n>0)
		let amodn = a % n
		if (2 * amodn > n) {
			return amodn - n
		}
		return amodn
	}
	
	private func powmods(_ aa : BigInt, _ rr : BigInt, _ n: BigInt) -> BigInt {
		var out : BigInt = 1
		var r = rr
		var a = aa
		while r > 0 {
			if (r % 2) == 1 {
				r = r - 1
				out = mods(out * a, n)
			}
			r = r / 2
			a = mods(a * a, n)
		}
		return out
	}
	
	private func quos(_ a : BigInt, _ n: BigInt) -> BigInt {
		return (a - mods(a, n)) / n
	}
	
	private func GaussRemainder(_ w0: BigInt, _ w1: BigInt, _ z0: BigInt, _ z1 : BigInt) -> (BigInt,BigInt) {
		//Divide w by z
		let n = z0 * z0 + z1 * z1
		assert(n != 0)
		let u0 = quos(w0 * z0 + w1 * z1, n)
		let u1 = quos(w1 * z0 - w0 * z1, n)
		let r1 = w0 - z0 * u0 + z1 * u1
		let r2 = w1 - z0 * u1 - z1 * u0
		return (r1,r2)
	}
	
	private func ggcd(_ ww: (BigInt,BigInt), _ zz:(BigInt,BigInt)) -> (BigInt,BigInt) {
		var z = zz
		var w = ww
		while z != (0,0) {
			let temp = GaussRemainder(w.0, w.1, z.0, z.1)
			w = z
			z = temp
		}
		return w
	}
	
	private func root4(p : BigInt) -> BigInt {
		//# 4th root of 1 modulo p
		assert(p>1)
		assert(p % 4 == 1)
		let k = p / 4
		var j : BigInt = 2
		while true {
			let a = powmods(j, k, p)
			let b = mods(a * a, p)
			if b == -1 {
				return a
			}
			//assert( b != 1) //not a prime input
		
			j = j + 1
		}
	}
	
	private func sq2(p : BigInt) -> (BigInt,BigInt) {
		if p <= 1 { return (0,1) }
		if p == 2 { return (1,1) }
		let r = root4(p: p)
		var (a,b) = ggcd((p,0),(r,1))
		if a < 0 { a = -a }
		if b < 0 { b = -b }
		return(a,b)
	}
	
	func Express(n: BigUInt) -> (a: BigUInt, b:BigUInt)? {
		if n <= 1 {
			return nil
		}
		if n == 2 {
			return (1,1)
		}
		if n.isPrime() {
			if n % 4 == 3 { return nil }
			let (a,b) = sq2(p: BigInt(n))
			return (BigUInt(a),BigUInt(b))
		}
		
		let factors = FactorCache.shared.FactorsWithPot(n: n)
		var squarerest : BigUInt = 1
		var singlefactors : [BigUInt] = []
		for f in factors {
			if (f.f % 4 != 1 ) && (f.e % 2 == 1) {
				return nil
			}
			if f.e % 2 == 1 {
				singlefactors.append(f.f)
				squarerest = squarerest * f.f.power((f.e-1) / 2 )
			}
			else {
				squarerest = squarerest * f.f.power((f.e) / 2 )
			}
		}
		
		//Zerlege die einzelnen Faktoren
		var (a,b) = (BigInt(1),BigInt(0))
		for s in singlefactors {
			let (c,d) = sq2(p: BigInt(s))
			(a,b) = (a*c+b*d,a*d-b*c)
		}
		if a < 0 { a = -a }
		if b < 0 { b = -b }
		let reta = BigUInt(a) * squarerest
		let retb = BigUInt(b) * squarerest
		
		return (a: BigUInt(reta), b: BigUInt(retb))
	}
	func isSpecial(n: BigUInt) -> Bool {
		if n <= 1 { return false }
		if n == 2 { return true }
		if n.isPrime() {
			if n % 4 != 1 { return false }
			return true
		}
		let factors = FactorCache.shared.FactorsWithPot(n: n)
		for f in factors {
			if (f.e % 2 == 1) && (f.f % 4 == 3) { return false }
		}
		return true
	}
	
	//NUmber of ways to write n = a^2 + b^2
	func r2(n: BigUInt) -> BigUInt {
		if n == 0 { return 1 }
		var (ans,d1,d3) = (0,0,0)
		let divisors = FactorCache.shared.Divisors(p: n)
		for d in divisors {
			switch Int(d % 4) {
			case 1:
				d1 = d1 + 1
			case 3:
				d3 = d3 + 1
			default:
				break
			}
		}
		ans = 4*(d1 - d3)
		return BigUInt(ans)
	}
}

