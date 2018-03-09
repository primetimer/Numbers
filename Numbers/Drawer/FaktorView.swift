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
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func SetNumber(_ nextnr : UInt64) {
		super.SetNumber(nextnr)
		param.nr = nextnr
	}
	
	private let _verbose = true
	private var _workItem : DispatchWorkItem? = nil
	private func BackgroundWorker() -> DispatchWorkItem {
		let workItem = DispatchWorkItem {
			if self._verbose { print("Computing:") }
			guard let worker = self._workItem else { return }
			self._workItem = nil
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
				self._workItem = nil
				self.imageview.animationImages = images
				self.imageview.image = images.last
				self.imageview.animationDuration = 5.0 //TimeInterval(self.param.maxrekurs)
				self.imageview.animationRepeatCount = 0
				//self.imageview.isUserInteractionEnabled = true
				self.imageview.startAnimating()
			})
		}
		return workItem
	}
	
	override func draw(_ rect : CGRect) {
		if _workItem != nil {
			_workItem?.cancel()
		}
		_workItem  = BackgroundWorker()
		DispatchQueue.global(qos: .userInitiated).async(execute: _workItem!)
	}
	
	private func CreateImages(worker : DispatchWorkItem? = nil )  -> [UIImage] {
		let rect = CGRect(x: 0, y: 0, width: 400.0, height: 400.0)
		var images : [UIImage] = []
		let drawer = param.CreateDrawer(rect)
		let maxrekurs = drawer.CalcRekursLevel()
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		defer { UIGraphicsEndImageContext() }
		guard let context = UIGraphicsGetCurrentContext() else { return images }
		do {
			for k in 0...maxrekurs {
				if worker?.isCancelled ?? false
				{
					return images
				}
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
				
				guard let newimage  = UIGraphicsGetImageFromCurrentImageContext() else { return images }
				images.append(newimage)
				
			}
		}
		return images
	}
}



