//
//  FaktorDrawerUlam.swift
//  Numbers
//
//  Created by Stephan Jancar on 17.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit
import BigInt
import PrimeFactors

class LuckyView : DrawNrView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	let maxnr : UInt64 = (120*120)
	override func SetNumber(_ nextnr : UInt64) {
		if nextnr > maxnr {
			super.SetNumber(maxnr)
		} else {
			super.SetNumber(nextnr)
		}
	}
	
	private var imagearr : [UIImage] = []
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		
		
		DispatchQueue.global().async {
			let drawer = LuckyDrawer(nr: self.nr)
			self.imagearr = drawer.CreateImages()
			
			DispatchQueue.main.async(execute: {
				self.imageview.animationImages = self.imagearr
				self.imageview.image = self.imagearr.last
				self.imageview.animationDuration = 5.0
				self.imageview.animationRepeatCount = 0
				self.imageview.startAnimating()
			})
		}
	}
}


class LuckyDrawer : UlamDrawer {
	private let rect = CGRect(x: 0, y: 0, width: 400.0, height: 400.0)
	private var imagearr : [UIImage] = []
	private (set) var luck : [Bool] = []
	private var determined : Int = 1
	private var picturemod : Int = 1
	private let maxpictures = 100		//round abtout
	private var picturecounter = 0
	
	init(nr : UInt64) {
		super.init(pointcount: Int(nr), utype: .square)
		luck = Array(repeating: true, count: count+1)
		self.picturecounter = 0
		self.picturemod = Int(nr) / maxpictures + 1
	}
	
	func CreateImages() -> [UIImage] {
		let maxlevel = 10
		for level in 0...maxlevel {
			self.removeLevel(level: level)
			if level == maxlevel {
				self.correct()
			}
		}
		return imagearr
	}
	
	private func removeLevel(level : Int) {
		if level == 0 { return }
		guard let which = findLucky(which: level)  else { return }
		self.determined = which
		
		var prev = 1
		while true {
			guard let next = getNext(from: prev,step: which) else { return }
			luck[next] = false
			prev = next
			if let image = CreateImage() {
				imagearr.append(image)
			}
		}
	}
	
	private func CreateImage(force : Bool = false) -> UIImage? {
		picturecounter = picturecounter + 1
		if force == false && picturecounter % picturemod != 0 { return nil }
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		defer { UIGraphicsEndImageContext() }
		guard let context = UIGraphicsGetCurrentContext() else { return nil }
		context.setStrokeColor(UIColor.red.cgColor)
		context.setLineWidth(1.0);
		context.beginPath()
		
		super.pstart = 1
		super.SetWidth(rect)
		super.bdrawspiral = true
		super.draw_spiral(context)
		
		for i in 1...Int(self.count) {
			super.draw_number(context, ulamindex : i-1, p: UInt64(i))
		}
		let image  = UIGraphicsGetImageFromCurrentImageContext()
		return image
	}
	
	//Helping routines
	private func findLucky(which : Int) -> Int? {
		if which <= 1 { return 2 }
		var count = 1
		for l in 1...luck.count-1 {
			if luck[l] == true {
				if count == which {
					return l
				}
				count = count + 1
			}
		}
		return nil
	}
	private func getNext(from : Int, step: Int)  -> Int? {
		var count = 0
		for i in from ... luck.count-1 {
			if luck[i] == true {
				count = count + 1
			}
			if count == step {
				return i
			}
		}
		return nil
	}
	
	private func correct() {
		let test = LuckyTester()
		for i in 2..<luck.count {
			if test.isSpecial(n: BigUInt(i)) {
				luck[i] = true
				determined = i
				if let image = CreateImage() {
					imagearr.append(image)
				}
			} else {
				luck[i] = false
			}
		}
		// Final Picture {
		if let image = CreateImage(force : true) {
			imagearr.append(image)
		}
	}
	
	override func getColor(_ p : UInt64) -> UIColor? {
		if self.luck[Int(p)] && p <= self.determined {
			return .blue
		}
		if luck[Int(p)] {
			return .red
		} else {
			return .cyan
		}
	}
}

