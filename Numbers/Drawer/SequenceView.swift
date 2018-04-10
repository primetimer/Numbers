//
//  UlamView.swift
//  PrimeTime
//
//  Created by Stephan Jancar on 03.04.16.
//  Copyright © 2016 esjot. All rights reserved.
//

import UIKit
import BigInt

class SequenceView : DrawNrImageView {
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.tester = PrimeTester()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func CreateImageDrawer(nr: UInt64, tester: NumTester?, worker: DispatchWorkItem?) -> ImageNrDrawer? {
		return SequenceDrawer(nr: nr, tester: tester!, emitter: self, worker: worker)
	}
}

class SequenceDrawer : ImageNrDrawer {
	var bgcolor: UIColor? = nil
	var Direction : Int = 1
	private var context : CGContext!
	let count = 100
	let ulammode = UlamType.linear // UlamType.square //UlamType.fibonacci
	

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
		DrawNumbers(spiralDrawer: spiral, since: 0)
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
		drawer.pstart = nr
		return drawer
	}
	
	private func DrawNumbers(spiralDrawer: UlamDrawer, since : Int)
	{
		guard let tester = tester else { return }
		for k in since ..< count {
			if worker?.isCancelled ?? false {
				return
			}
			let j = k // count - 1 - k
			let nr =  Int(self.nr) + j * Direction
			if nr < 0 { break }
			if !tester.isSpecial(n: BigUInt(nr)) { continue }
			spiralDrawer.draw_number(context, ulamindex: j, p: UInt64(nr), color : UIColor.red)
			guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
			emitter?.Emit(image: image)
		}
	}
}

