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
	/*
	private func BackgroundWorker() -> DispatchWorkItem {
		let workItem = DispatchWorkItem {
			if self._verbose { print("Computing:") }
			guard let worker = self.workItem else { return }
			self.workItem = nil
			var images = self.CreateImages(worker: worker)
			if let last = images.last {
				let stillcount = images.count
				for _ in 0...stillcount {
					images.append(last)
				}
			}
			if worker.isCancelled {
				if self._verbose { print("Calculation break") }
				return
			}
			DispatchQueue.main.async(execute: {
				if self._verbose { print("Displaying") }
				self.workItem = nil
				self.imageview.animationImages = images
				self.imageview.image = images.last
				self.imageview.animationDuration = 5.0 //TimeInterval(self.param.maxrekurs)
				self.imageview.animationRepeatCount = 0
				self.imageview.startAnimating()
			})
		}
		return workItem
	}
	*/
	/*
	override func draw(_ rect : CGRect) {
		if !needredraw { return }
		super.draw(rect)
		workItem  = BackgroundWorker()
		DispatchQueue.global(qos: .userInitiated).async(execute: workItem!)
	}
	*/
	
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



