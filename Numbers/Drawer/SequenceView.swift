//
//  UlamView.swift
//  PrimeTime
//
//  Created by Stephan Jancar on 03.04.16.
//  Copyright © 2016 esjot. All rights reserved.
//

import UIKit


class SequenceView : DrawNrView {
	private var _needRecalc : Bool = true
	var ulamimageview : SequenceImageView!
	
	override var frame : CGRect {
		set {
			super.frame = newValue
			setNeedsDisplay()
		}
		get { return super.frame }
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		ulamimageview = SequenceImageView(frame: self.frame)
		addSubview(ulamimageview)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		ulamimageview = SequenceImageView(frame: self.frame)
		addSubview(ulamimageview)
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
	var count : Int = 1000 {
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
	
	var _direction : Int = 1
	var UlamBackward : Bool {
		set {
			if newValue == true {
				_direction = -1
				//_ulamdrawer?.direction = -1
			}
			if newValue == false {
				_direction = 1
				//_ulamdrawer?.direction = 1
			}
		}
		get {
			if _direction == -1 { return true }
			return false
		}
	}
	
	func CreateDrawer(_ rect : CGRect) -> UlamDrawer {
		let drawer = UlamDrawer(pointcount: self.count, utype: self.ulammode)
		drawer.colored = self.UlamColored
		drawer.bprimesphere = self.UlamSphere
		drawer.direction = self._direction
		drawer.bprimesizing = self._tausizing
		drawer.overscan = self._overscan
		drawer.setZoom(self._zoom)
		drawer.SetWidth(rect)
		drawer.pstart = start
		return drawer
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		ulamimageview.frame = rect
		let drawer = CreateDrawer(rect)
		ulamimageview.CreateImage(rect,drawer: drawer)
		
	}
}

class SequenceImageView : UIView {
	
	fileprivate var ulamimage : UIImage? = nil
	//private var blockOperation : NSOperation? = nil
	fileprivate let queue = OperationQueue()
	var tlimit = TimeInterval(0.2)  //zeichnet asynchron
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		ulamimage?.draw(in: rect)
	}
	func CreateImage(_ rect : CGRect, drawer : UlamDrawer, k0 : Int = 0)  {
		
		queue.cancelAllOperations()
		var k = k0
		var drawfinished = false
		
		let blockOperation = BlockOperation()
		blockOperation.addExecutionBlock {
			
			
			UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
			let context = UIGraphicsGetCurrentContext()
			if k > 0 {
				self.ulamimage?.draw(in: rect)
				//CGContextDrawImage(context, rect, self.ulamimage?.CGImage)
			}
			
			context!.setStrokeColor(UIColor.red.cgColor)
			context!.setLineWidth(1.0);
			context!.beginPath()
			drawer.draw_spiral(context!)
			
			k = drawer.draw_primes(context!, k0 : k0, tlimit: self.tlimit)
			if k == 0 { drawfinished = true }
			self.ulamimage  = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			
			OperationQueue.main.addOperation {
				//self.drawreentry = false
				self.setNeedsDisplay()
				if !blockOperation.isCancelled && !drawfinished {
					self.CreateImage(rect, drawer: drawer, k0: k)
					//print("Restart")
				}
				else {
			
					print("Sequenceview stop Stop")
				}
			}
		}
		
		if tlimit == 0.0 {
			blockOperation.start()
		} else
		{
			queue.addOperation(blockOperation)
		}
	}
}

