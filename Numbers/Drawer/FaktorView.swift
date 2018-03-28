//
//  FaktorView.swift
//  Numbers
//
//  Created by Stephan Jancar on 15.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit


class FaktorView: DrawNrView {
	
	var param = FaktorDrawerParam()
	override func CreateImageDrawer(nr: UInt64, tester: NumTester?, worker: DispatchWorkItem?) -> ImageNrDrawer? {

		let ans = FaktorNrDrawer(nr: nr, tester: tester, emitter: self, worker: worker)
		param.nr = self.nr
		ans.param = param
		
		return ans
	}
}

class FaktorNrDrawer : ImageNrDrawer {
	
	var param = FaktorDrawerParam()	
	override func DrawNrImage(rect : CGRect) -> UIImage? {
		self.rect = rect
		let drawer = param.CreateDrawer(rect)
		let maxrekurs = drawer.CalcRekursLevel()
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		defer { UIGraphicsEndImageContext() }
		
		guard let context = UIGraphicsGetCurrentContext() else { return nil }
		
		for k in 0...maxrekurs {
			if worker?.isCancelled ?? false { return nil }
			
			self.param.imagenr = k				//Only for ulam
			self.param.imagemax = maxrekurs		//Only for ulam
			self.param.maxrekurs = UInt64(k)
			self.param.rectLimit = 64
			self.param.rect = rect

			context.setStrokeColor(UIColor.black.cgColor)
			context.setLineWidth(1.0);
			context.beginPath()
			let drawer = self.param.CreateDrawer(rect)
			drawer.drawFaktor(rect,context: context)
				
			guard let image  = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
			emitter?.Emit(image: image)
		}
		let image = UIGraphicsGetImageFromCurrentImageContext()
		return image
	}
}



