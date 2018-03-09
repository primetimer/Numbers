//
//  UlamView.swift
//  PrimeTime
//
//  Created by Stephan Jancar on 03.04.16.
//  Copyright © 2016 esjot. All rights reserved.
//

import UIKit
import BigInt


class SequenceView : DrawNrView {
	private var _needRecalc : Bool = true
	override var frame : CGRect {
		set {
			super.frame = newValue
			setNeedsDisplay()
		}
		get { return super.frame }
	}
	
	var tester : NumTester? = nil
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func SetNumber(_ nextnr : UInt64) {
		super.SetNumber(nextnr)
		self.start = nextnr
	}
	
	var start : UInt64 = 2 {
		didSet {
			if oldValue != start { _needRecalc = true }
		}
	}
	var ulammode : UlamType = UlamType.square {
		didSet {
			if ( ulammode != oldValue) { _needRecalc = true }
		}
	}
	var count : Int = 100 {
		didSet {
			if (count != oldValue) { _needRecalc = true }
		}
	}
	var UlamColored : Bool = false {
		didSet {
			if (UlamColored != oldValue) { _needRecalc = true }
		}
	}
	var UlamSphere : Bool = false {
		didSet {
			if ( UlamSphere == oldValue){ _needRecalc = true }
		}
	}
	
	fileprivate var _zoom : CGFloat = 1.0
	func setZoom(_ zoom : CGFloat)
	{
		_zoom *= zoom
		_needRecalc = true
	}
	func resetZoom()
	{
		_zoom = 1.0
		_needRecalc = true
	}
	func getZoom() -> CGFloat { return _zoom }
	
	fileprivate var _overscan : CGFloat = 1.0
	var OverScan : CGFloat {
		set {
			if (_overscan == newValue) { return }
			_overscan = newValue
			_needRecalc = true
			//_ulamdrawer?.overscan = newValue
		}
		get {
			return _overscan
		}
	}
	
	fileprivate var _tausizing: Bool = false
	var UlamTauSizing : Bool {
		set {
			if (_tausizing == newValue) { return }
			_tausizing = newValue
			_needRecalc = true
			//_ulamdrawer?.bprimesizing = newValue
		}
		get {
			return _tausizing
		}
	}
	
	var Direction : Int = 1
	
	func CreateDrawer(_ rect : CGRect) -> UlamDrawer {
		let drawer = UlamDrawer(pointcount: self.count, utype: self.ulammode)
		drawer.colored = self.UlamColored
		drawer.bprimesphere = self.UlamSphere
		drawer.direction = self.Direction
		drawer.bprimesizing = self._tausizing
		drawer.overscan = self._overscan
		drawer.setZoom(self._zoom)
		drawer.SetWidth(rect)
		drawer.pstart = start
		return drawer
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		let drawer = CreateDrawer(rect)
		CreateImages(rect,drawer: drawer)
	}

	var tlimit = TimeInterval(0.2)  //zeichnet asynchron
	private var workItem : DispatchWorkItem? = nil
	private func DrawNumbers(drawer: UlamDrawer, since : Int, _ context: CGContext!, worker : DispatchWorkItem) -> Int
	{
		guard let tester = tester else { return 0 }
		for k in since ..< count {
			
			if worker.isCancelled {
				return k
			}
			let j = count - 1 - k
			let nr =  Int(start) + j * Direction - 1
			if nr < 0 { break }
			if !tester.isSpecial(n: BigUInt(nr)) { continue }
			drawer.draw_number(context, ulamindex: j, p: UInt64(nr))
		}
		return 0
	}
	func CreateImages(_ rect : CGRect, drawer : UlamDrawer)  {
		workItem?.cancel()
		self.workItem = DispatchWorkItem {
			guard let worker = self.workItem else { return }
			UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
			guard let context = UIGraphicsGetCurrentContext() else { return }
			context.setStrokeColor(UIColor.red.cgColor)
			context.setLineWidth(1.0);
			context.beginPath()
			drawer.draw_spiral(context)
			//drawer.draw_primes(context)
			self.DrawNumbers(drawer: drawer, since: 0, context, worker: worker)
			let image = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			if !worker.isCancelled {
				self.workItem = nil
				DispatchQueue.main.async(execute: {
					self.imageview.image  = image
				})
			}
		}
		DispatchQueue.global(qos: .userInitiated).async(execute: workItem!)
	}
}

