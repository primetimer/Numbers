//
//  Extensions.swift
//  Numbers
//
//  Created by Stephan Jancar on 03.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit
import BigInt
import PrimeFactors

extension MutableCollection {
	/// Shuffles the contents of this collection.
	mutating func shuffle() {
		let c = count
		guard c > 1 else { return }
		
		for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
			let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
			let i = index(firstUnshuffled, offsetBy: d)
			swapAt(firstUnshuffled, i)
		}
	}
}

extension Sequence {
	/// Returns an array with the contents of this sequence, shuffled.
	func shuffled() -> [Element] {
		var result = Array(self)
		result.shuffle()
		return result
	}
}

extension Int {
	func formatnumber() -> String {
		let formater = NumberFormatter()
		formater.groupingSeparator = "."
		formater.numberStyle = .decimal
		return formater.string(from: NSNumber(value: self))!
	}
}

public extension Double {
	public static var phi: Double { return Double(sqrt(5.0) + 1.0 ) / 2.0 }
	public static var psi: Double { return Double(sqrt(5.0) - 1.0 ) / 2.0 }
	public static var gamma : Double { return 0.577215664901532860606512090 }
	public static var mill : Double { return 1.3063778838630806904686144926026057129167845851 }
}

extension UInt64 {
	var isPrime : Bool {
		get {
			return PrimeCache.shared.IsPrime(p: BigUInt(self))
		}
	}
}

extension String {
	mutating func appendnl(_ append : String) {
		if append.count == 0 { return }
		if self.count>0 { self = self + "\n" }
		self = self + append
	}
}

extension String {
	func capitalizingFirstLetter() -> String {
		return prefix(1).uppercased() + dropFirst()
	}
	
	mutating func capitalizeFirstLetter() {
		self = self.capitalizingFirstLetter()
	}
}

extension UIViewController {
	internal var navh : CGFloat {
		get {
			if let nvc = self.navigationController {
				let nh = nvc.navigationBar.intrinsicContentSize.height
				let sh = UIApplication.shared.statusBarFrame.height
				return nh + sh
			}
			return 64.0
		}
	}
	internal var toolh : CGFloat {
		get {
			if let nvc = self.navigationController {
				return nvc.toolbar.frame.height + 32.0
			}
			return 40.0
		}
	}
}

extension UIView {
	var bottom : CGFloat {
		get {
			return self.frame.origin.y + self.frame.height
		}
		set {
			self.frame.size.height = newValue - self.frame.origin.y
		}
	}
	var right : CGFloat {
		get {
			return self.x + self.width
		}
		set {
			let dif = width - x
			self.frame.size.width = self.x + dif
		}
	}
	var width : CGFloat {
		get {
			return self.frame.width
		}
		set {
			self.frame.size.width = newValue
		}
	}
	var height : CGFloat {
		get {
			return self.frame.height
		}
		set {
			self.frame.size.height = newValue
		}
	}
	
	var x : CGFloat {
		get {
			return self.frame.origin.x
		}
		set {
			self.frame.origin.x = newValue
		}
	}
	var y : CGFloat {
		get {
			return self.frame.origin.y
		}
		set {
			self.frame.origin.y = newValue
		}
	}
}



