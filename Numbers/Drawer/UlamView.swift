//
//  UlamView.swift
//  PrimeTime
//
//  Created by Stephan Jancar on 03.04.16.
//  Copyright © 2016 esjot. All rights reserved.
//

import UIKit


class UlamView: DrawNrView {
	
	private var _ulammode = UlamType.square
	private var _start : UInt64 = 2         // Irrelevant!? Alles UlamDraw
	private var _count : Int = 1000                // Irrelevant!?
	//private var _ulamdrawer : UlamDrawer? = nil
	fileprivate var _needRecalc : Bool = true
	var ulamimageview : UlamImageView!
	
	override var frame : CGRect {
		set {
			super.frame = newValue
			setNeedsDisplay()
		}
		get { return super.frame }
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		ulamimageview = UlamImageView(frame: self.frame)
		addSubview(ulamimageview)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		ulamimageview = UlamImageView(frame: self.frame)
		addSubview(ulamimageview)
	}
	
	override func SetNumber(_ nextnr : UInt64) {
		super.SetNumber(nextnr)
		self.start = nextnr
	}
	
	var start : UInt64 {
		set {
			/*#
			if (newValue < _start) || (newValue >= _start + UInt64(count))
			{
			_needRecalc = true
			}
			*/
			if newValue != _start { _needRecalc = true }
			_start = newValue
		}
		get { return _start }
	}
	var ulammode : UlamType {
		set {
			if (_ulammode != newValue) { _needRecalc = true }
			_ulammode = newValue
		}
		get { return _ulammode }
	}
	var count : Int {
		set {
			if (count != newValue) { _needRecalc = true }
			_count = newValue
		}
		get { return _count }
	}
	
	fileprivate var _colored : Bool = false
	var UlamColored : Bool {
		set {
			if (_colored == newValue) { return }
			_colored = newValue
			_needRecalc = true
			//_ulamdrawer?.colored = _colored
		}
		get { return _colored }
	}
	
	fileprivate var _sphere: Bool = false
	var UlamSphere : Bool {
		set {
			if (_sphere == newValue) { return }
			_sphere = newValue
			_needRecalc = true
			//_ulamdrawer?.bprimesphere = newValue
		}
		get {
			return _sphere
		}
	}
	
	fileprivate var _semiprimes: Bool = false
	var UlamSemiPrimes : Bool {
		set {
			if (_semiprimes == newValue) { return }
			_semiprimes = newValue
			_needRecalc = true
			//_ulamdrawer?.bsemiprimes = newValue
		}
		get {
			return _semiprimes
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
		let drawer = UlamDrawer(pointcount: self._count, utype: self._ulammode)
		drawer.colored = self._colored
		drawer.bprimesphere = self._sphere
		drawer.direction = self._direction
		drawer.bprimesizing = self._tausizing
		drawer.bsemiprimes = self._semiprimes
		drawer.overscan = self._overscan
		drawer.setZoom(self._zoom)
		drawer.SetWidth(rect)
		drawer.pstart = _start
		
		return drawer
	}
	
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		ulamimageview.frame = rect
		let drawer = CreateDrawer(rect)
		ulamimageview.CreateImage(rect,drawer: drawer)
		
	}
}

class UlamImageView : UIView {
	
	fileprivate var uispin : UIActivityIndicatorView!
	fileprivate var ulamimage : UIImage? = nil
	//private var blockOperation : NSOperation? = nil
	fileprivate let queue = OperationQueue()
	var tlimit = TimeInterval(0.2)  //zeichnet asynchron
	
	//private var drawer : UlamDrawer?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		//backgroundColor = UIColor.blackColor()
		uispin = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
		uispin.center = self.center
		uispin.hidesWhenStopped = true
		#if os(iOS)
			addSubview(uispin)
		#endif
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	
	//var ulamimage : UIImage? = nil
	//var drawreentry = false
	//var canceldrawing = false
	
	override func draw(_ rect: CGRect) {
		//CreateImage(rect)
		//print("Drawing")
		super.draw(rect)
		ulamimage?.draw(in: rect)
	}
	
	func CreateImage(_ rect : CGRect, drawer : UlamDrawer, k0 : Int = 0)  {
		
		
		queue.cancelAllOperations()
		if tlimit>0.0 {
			self.uispin.startAnimating()
		}
		//print("Start")
		
		//drawreentry = true
		
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
					self.uispin.stopAnimating()
					//print("Stop")
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

