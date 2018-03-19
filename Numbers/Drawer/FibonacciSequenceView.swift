//
//  UlamView.swift
//  PrimeTime
//
//  Created by Stephan Jancar on 03.04.16.
//  Copyright © 2016 esjot. All rights reserved.
//

import UIKit
import BigInt



class FibonacciSequenceView : DrawNrView {
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func CreateImageDrawer(nr: UInt64, tester: NumTester?, worker: DispatchWorkItem?) -> ImageNrDrawer? {
		return FibonacciSequenceDrawer(nr: nr, tester: tester!, emitter: self, worker: worker)
	}
}

class FibonacciSequenceDrawer : ImageNrDrawer {
	var bgcolor: UIColor? = nil
	var Direction : Int = 1
	private var context : CGContext!
	private var count : Int {
		if nr < 10 {
			return 10
		}
		if nr < 3600 {
			return Int(nr)
		}
		return 3600
	}
	let ulammode = UlamType.fibonacci

	override func DrawNrImage(rect : CGRect) -> UIImage? {
		self.rect = rect
		UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
		defer { UIGraphicsEndImageContext() }
		guard let context = UIGraphicsGetCurrentContext() else { return nil }

		if bgcolor != nil {
			bgcolor?.setFill()
			UIRectFill(rect)
		}

		self.context = context
		context.setStrokeColor(UIColor.red.cgColor)
		context.setLineWidth(1.0);
		context.beginPath()
		let spiral = CreateSpiralDrawer(rect)
		spiral.draw_spiral(context)
		for since in 0...count {
					context.clear(rect)
			DrawNumbers(spiralDrawer: spiral, since: since)
		}
		let image = UIGraphicsGetImageFromCurrentImageContext()
		return image
	}
	
	private func CreateSpiralDrawer(_ rect : CGRect) -> UlamDrawer {
		let drawer = UlamDrawer(pointcount: self.count, utype: self.ulammode)
		drawer.colored = false
		drawer.bprimesphere = false
		drawer.direction = self.Direction
		drawer.bprimesizing = false
		drawer.overscan = 1.0
		drawer.setZoom(1.0)
		drawer.SetWidth(rect)
		drawer.pstart = 0 //nr
		return drawer
	}
	
	private func DrawNumbers(spiralDrawer: UlamDrawer, since : Int)
	{
		let dhue = 1.0 / CGFloat(count)
		spiralDrawer.pstart = UInt64(since)
		for k in 0 ..< since {
			if worker?.isCancelled ?? false {
				return
			}
			let j = k //count - 1 - k
			let nr =  since - k //Int(self.nr) + j * Direction
			if nr < 0 { continue }
			//if !tester.isSpecial(n: BigUInt(nr)) { continue }
			let hue = CGFloat(nr) * dhue
			let color = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
			do {
				spiralDrawer.draw_number(context, ulamindex: j, p: UInt64(nr), color : color)
			}
		}
		guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
		emitter?.Emit(image: image)
	}
}

