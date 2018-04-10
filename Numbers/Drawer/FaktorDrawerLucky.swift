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

class LuckyView : DrawNrImageView {
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.tester = LuckyTester()
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override func CreateImageDrawer(nr: UInt64, tester: NumTester?, worker: DispatchWorkItem?) -> ImageNrDrawer? {
		let ans = LuckyDrawer(nr: nr, tester: tester, emitter: self, worker: worker)
		return ans
	}
}

class LuckyDrawer : ImageNrDrawer {
	private var context : CGContext!
	let maxnr : Int = (120*120)
	private var determined : Int = 1
	private var picturemod : Int = 1
	private let maxpictures = 100
	private var picturecounter = 0
	private var count : Int = 0
	private let ulammode = UlamType.square
	private var luck : [Bool] = []
	
	private func PreEmitter() {
		if emitter == nil { return }
		picturecounter = picturecounter + 1
		picturemod = count / maxpictures + 1
		if picturecounter % picturemod == 0 {
			return
		}
		if let image = UIGraphicsGetImageFromCurrentImageContext() {
			emitter?.Emit(image: image)
		}
	}
	
	private func CreateSpiralDrawer(_ rect : CGRect) -> UlamDrawer {
		let drawer = UlamDrawer(pointcount: self.count, utype: self.ulammode)
		drawer.colored = false
		drawer.bprimesphere = false
		drawer.direction = 1
		drawer.bprimesizing = false
		drawer.overscan = 1.0
		drawer.setZoom(1.0)
		drawer.SetWidth(rect)
		drawer.pstart = nr
		return drawer
	}
	
	override func DrawNrImage(rect : CGRect) -> UIImage? {
		count = min(Int(nr),maxnr)
		if nr < 100 { count = 100 }
		luck = Array(repeating: true, count: self.count+1)
		self.rect = rect
		UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
		defer { UIGraphicsEndImageContext() }
		guard let context = UIGraphicsGetCurrentContext() else { return nil }
		self.context = context
		context.setStrokeColor(UIColor.red.cgColor)
		context.setLineWidth(1.0);
		context.beginPath()
		let spiral = CreateSpiralDrawer(rect)
		spiral.draw_spiral(context)
		let maxlevel = 10
		if emitter != nil {
			DrawAllNumbers(spiralDrawer: spiral)
			for level in 0...maxlevel {
				if worker?.isCancelled ?? false { return nil }
				self.removeLevel(level: level, spiralDrawer: spiral)
			}
		}
		let image = self.correct(spiralDrawer: spiral)

		return image
	}
	
	private func removeLevel(level : Int, spiralDrawer : UlamDrawer) {
		if level == 0 { return }
		guard let which = findLucky(which: level)  else { return }
		self.determined = which
		DrawNumber(k: which, spiralDrawer: spiralDrawer)
		var prev = 1
		while true {
			guard let next = getNext(from: prev,step: which) else { return }
			luck[next] = false
			DrawNumber(k: next, spiralDrawer: spiralDrawer)
			prev = next
		}
	}
	private func DrawAllNumbers(spiralDrawer: UlamDrawer)
	{
		for k in 0 ..< count {
			if worker?.isCancelled ?? false { return }
			let color = getColor(k)
			spiralDrawer.draw_number(context, ulamindex: k, p: UInt64(k), color: color)
		}
		if let image = UIGraphicsGetImageFromCurrentImageContext() {
			emitter?.Emit(image: image)
		}
	}
	
	private func DrawNumber(k: Int, spiralDrawer: UlamDrawer)
	{
		let color = getColor(k)
		if luck[k] && k != determined { return }
		spiralDrawer.draw_number(context, ulamindex: k, p: UInt64(k), color: color)
		PreEmitter()
	}
	
	//Helping routines
	private func findLucky(which : Int) -> Int? {
		if which <= 1 { return 2 }
		var count = 1
		for l in 1...self.count {
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
		for i in from ... self.count {
			if luck[i] == true {
				count = count + 1
			}
			if count == step {
				return i
			}
		}
		return nil
	}
	
	private func correct(spiralDrawer : UlamDrawer) -> UIImage? {
		//return nil
		let tester = LuckyTester()
		for i in 2...spiralDrawer.count {
			if !tester.isSpecial(n: BigUInt(i)) {
				//assert(luck[i] == false)
				if luck[i] == true {
					luck[i] = false
					DrawNumber(k: i, spiralDrawer: spiralDrawer)
				}
				continue
			}
			luck[i] = true
			determined = i
			DrawNumber(k: i, spiralDrawer: spiralDrawer)
			//spiralDrawer.draw_number(context, ulamindex: i, p: UInt64(i), color : color)
			//if let image = UIGraphicsGetImageFromCurrentImageContext() {
			//	emitter?.Emit(image: image)
			//}
		}
		// Final Picture {
		let image = UIGraphicsGetImageFromCurrentImageContext()
		return image
	}

	private func getColor(_ p : Int) -> UIColor {
		if self.luck[Int(p)] && p <= self.determined {
			return .orange
		}
		if luck[Int(p)] {
			return .cyan
		} else {
			return .blue
		}
	}
}

