//
//  PiTester.swift
//  Numbers
//
//  Created by Stephan Jancar on 29.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import BigInt
import BigFloat

extension MathConstantType {
	func OEISRational() -> (n: String,d: String,cf: String)? {
		switch self {
		case .pi:
			return ("A046947","A002486","A001203")
		case .e:
			return ("A007676","A007677","A003417")
		case .gamma:
			return ("A046114","A064115","A002852")
		case .bruns:
			return ("A065421","A065421N","A065421D")	//Bruns decimal not Continued Fractions"
		case .pisquare:
			return nil //return ("A096456","A096463")
		case .root2:
			return ("A001333","A000129","A040000")
		case .ln2:
			return ("A016730","A079942","A079943")
		case .phi:
			return ("A000012","A000045+1","A000045+2")
		case .crt2:
			return ("A002945","A002945N","A002945D")
		case .zeta3: 
			return ("A013631","A084223","A084224")
		case .conwaylambda:
			return ("A014967","A014967N","A014967D")
		case .mill:
			return nil
		}
	}
	
	func asBigFloat() -> BigFloat {
		switch self {
		case .pi:
			return BigFloatConstant.pi
		case .e:
			return BigFloatConstant.e
		case .root2:
			return BigFloatConstant.sqrt2
		case .ln2:
			return BigFloatConstant.ln2
		case .gamma:
			return BigFloatConstant.gamma
		case .mill:
			return BigFloatConstant.mills
		case .pisquare:
			return BigFloatConstant.pi2
		case .phi:
			return BigFloatConstant.phi
		case .crt2:
			return BigFloatConstant.crt2
		case .bruns:
			return BigFloatConstant.bruns
		case .conwaylambda:
			assert(false)
		case .zeta3:
			assert(false)
		}
	}
}


class ContinuedFractions {
	private let uptodefault = 100
	
	static let shared = ContinuedFractions()
	private init() {
		//CreateOEIS()
	}

	func getSeries(value : BigFloat, upto : Int = 0) -> [BigUInt] {
		let count = upto == 0 ? uptodefault : upto
		var a: [BigUInt] = []
		var (a0,x) = (BigInt(0),value)
		for _ in 0...count {
			(a0,x) = x.SplitIntFract()
			
			a.append(BigUInt(a0))
			if x == BigFloat(0) {
				return a
			}
			x = BigFloat(1) / x
		}
		return a
	}

	func RationalSequence(seq: [BigInt], count : Int = 0) -> [(n: BigInt,d: BigInt)] {
		var ans : [(n: BigInt,d: BigInt)] = []
		let c = count == 0 ? seq.count : min(count,seq.count)
		var (h1,k1) = (BigInt(1), BigInt(0))
		var (h0,k0) = (BigInt(0), BigInt(1))
		
		for i in 0..<c {
			let a = BigInt(seq[i])
			let (h,k) = (a*h1+h0,a*k1+k0)
			(h0,k0) = (h1,k1)
			(h1,k1) = (h,k)
			
			ans.append((h1,k1))
		}
		return ans
	}
	
	func ValueRational(seq: [BigUInt], count : Int = 0) -> (numerator: BigUInt,denominator: BigUInt){	//0 is use all terms
		let c = count == 0 ? seq.count : min(count,seq.count)
		var (h1,k1) = (BigUInt(1), BigUInt(0))
		var (h0,k0) = (BigUInt(0), BigUInt(1))
		
		for i in 0..<c {
			let a = BigUInt(seq[i])
			let (h,k) = (a*h1+h0,a*k1+k0)
			(h0,k0) = (h1,k1)
			(h1,k1) = (h,k)
		}
		return (h1,k1)
	}
}


