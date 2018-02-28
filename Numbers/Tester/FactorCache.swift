//
//  FactorCache.swift
//  Numbers
//
//  Created by Stephan Jancar on 17.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt
import PrimeFactors

public class NSFactorArray : NSObject {
	public override init() {
		super.init()
	}
	init(f: [BigUInt]) {
		super.init()
		arr = f
	}
	var arr : [BigUInt] = []
}

public class FactorCache {
	
	static let strat = PrimeFactorStrategy()
	private var pcache = NSCache<NSString, NSFactorArray>()
	static public var shared = FactorCache()
	
	private init() {}
	
	public func Factor(p: BigUInt) -> [BigUInt] {
		if PrimeCache.shared.IsPrime(p: p) {
			return [p]
		}
		let nsstr = NSString(string: String(p.hashValue))
		if let cachep = pcache.object(forKey: nsstr) {
			return cachep.arr
		}
		let factors = FactorCache.strat.Factorize(ninput: p)
		let nsarr = NSFactorArray(f: factors)
		
		pcache.setObject(nsarr, forKey: nsstr)
		return factors
	}
	
	public func Sigma(p: BigUInt) -> BigUInt {
		var (ret,produkt) = (BigUInt(1),BigUInt(1))
		let factors = Factor(p: p)
		let count = factors.count
		if count == 0 { return ret }
		for i in 0..<count {
			produkt = produkt * factors[i]
			if (i + 1 < count) && (factors[i] == factors [i+1]) {
				continue
			}
			ret = ret * ( produkt * (factors[i]) - 1 ) / ((factors[i]) - 1)
			produkt = BigUInt(1)
		}
		return ret
	}
	
	func Divisors(p: BigUInt) -> [BigUInt]
	{
		let factors = Factor(p: p)
		let c = factors.count
		if c == 0 { return [BigUInt(1)] }
		
		let d1 = factors[0]
		var d1potenz : BigUInt = 1
		var multiplicity = 0
		while multiplicity < c {
			if factors[multiplicity] != d1 {
				break
			}
			multiplicity = multiplicity + 1
			d1potenz = d1potenz * d1
		}
		
		//let ret : [UInt64] = []
		if c > multiplicity {
			
			let p2 = p/d1potenz
			var ret = Divisors(p: p2)
			
			let n = ret.count
			d1potenz = d1
			for _ in 1...multiplicity {
				for i in 0..<n {
					ret.append(d1potenz*ret[i])
				}
				d1potenz = d1potenz * d1
			}
			return ret
		}
		
		var ret : [BigUInt] = [BigUInt(1)]
		d1potenz = 1
		for _ in 1...multiplicity
		{
			d1potenz = d1 * d1potenz
			ret.append(d1potenz)
		}
		return ret
	}
}
