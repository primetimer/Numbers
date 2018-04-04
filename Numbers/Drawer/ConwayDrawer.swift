//
//  ConwayDrawer.swift
//  Numbers
//
//  Created by Stephan Jancar on 15.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit
import BigInt

class ConwayView : DrawNrView {

	init () {
		super.init(frame: CGRect.zero)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func CreateImageDrawer(nr: UInt64, tester: NumTester?, worker: DispatchWorkItem?) -> ImageNrDrawer? {
		return ConwayDrawer(nr: nr, tester: self.tester, emitter: self, worker: self.workItem)
	}
}

extension ConwayElem {
	func get1Decay() -> String {
		var ans = self.name
		let subs = self.Isotops(upto: self.index)
		if subs.count == 1 {
			ans = ans + "->" + subs[0].get1Decay()
		}
		//return self.name
		return ans
	}
}

class ConwayDrawer : ImageNrDrawer
{
	override init(nr : UInt64, tester : NumTester?, emitter : EmitImage?, worker: DispatchWorkItem?) {
		super.init(nr: nr, tester: tester, emitter: emitter, worker: worker)
	}
	
	
	/*
	private var drawnCounter : [Int] = []
	
	func ResetCounter() {
		drawnCounter = Array(repeating: 0, count: 92)
	}
	func IncrementElem(elem : ConwayElem) -> Int {
		drawnCounter[elem.index] = drawnCounter[elem.index]
	}
	*/
	
	/*
	
	private func DrawElem(context : CGContext, rect : CGRect, elems : [ConwayElem],rekurs : Int)
	{
		if rekurs >= 3 { return }
		
		let count = CGFloat(elems.count)
		var dx : CGFloat = 0.0
		var dy : CGFloat = 0.0
		var w: CGFloat = rect.width
		var h: CGFloat = rect.height
		var (x0,y0) = (rect.minX,rect.minY)
		
		
		if rect.width >= rect.height {
			if elems.count % 2 == 1 {
				y0 = y0 + rect.height / 10
			}
			dx = rect.width / count
			dy = 0.0
			w = dx
			h = rect.height
		} else {
			if elems.count % 2 == 1 {
				x0 = x0 + rect.height / 10
			}
			dx = 0.0
			dy = rect.height / count
			w = rect.width
			h = dy
		}
		

		
		for i in 0..<elems.count {
			
			if worker?.isCancelled ?? false { return  }
			let x = x0 + CGFloat(i) * dx
			let y = y0 + CGFloat(i) * dy
			let drect =  CGRect(x: x, y: y, width: w, height: h)
			print(elems[i].name,drect)
			
			UIColor.white.setStroke()
			context.setLineWidth(2.0)
			//context.strokePath()
			
			//Wenn nur ein Subelem, dann direkte Evolutionslinie
			let str = elems[i].get1Decay()
			str.drawCentered(in: drect)
			if emitter != nil {
				guard let newimage  = UIGraphicsGetImageFromCurrentImageContext() else { continue }
				emitter?.Emit(image: newimage)
			}
		}
			
		//Rest in Rekursion
		for i in 0..<elems.count {
			if worker?.isCancelled ?? false { return  }
			let x = rect.minX + CGFloat(i) * dx
			let y = rect.minY + CGFloat(i) * dy
			let drect =  CGRect(x: x, y: y, width: w, height: h)

			print("getting subelems for :", elems[i].name)
			var subelems = elems[i].Isotops(upto: elems[i].index)
			while subelems.count == 1 {
				subelems = subelems[0].Isotops(upto: subelems[0].index)
			}
			if subelems.count > 0 {
				DrawElem(context: context, rect: drect, elems: subelems, rekurs: rekurs + 1)
			}
		}
		
	}

	private func DrawNumber(context : CGContext)
	{
		
		guard let elem = ConwayActive.shared.contains(nr: BigUInt(self.nr)) else {
			assert(false)
			return
		}
		
		let elems : [ConwayElem] = [elem]
		DrawElem(context: context, rect: rect, elems: elems, rekurs: 0)
		
		
	}

	*/
	
	//U-Ta, Hf-Er, Ho-Gd, Eu-Sm, Pm-Y, Sr-Ga, Zn-Sc, Ca-He, H
	private var cols : [(String,String)] = [("U","Ta"),("Hf","Er"),("Ho","Gd"),("Eu","Sm"),("Pm","Xe"),("I","Y"),("Sr","Ga"),("Zn","Sc"),("Ca","He"),("H","H")]
	private func GetColIndices(col : Int) -> (start:Int,end:Int) {
		let end = cols[col].0
		let start = cols[col].1
		
		var startidx = 0
		var endidx = 0
		
		for (index,e) in ConwayActive.shared.elems.enumerated() {
			if e.name == start { startidx = index }
			if e.name == end { endidx = index }
		}
		return (startidx,endidx)
	}
	
	private func GetDxDy() -> (x: CGFloat,y: CGFloat) {
		let dy = rect.height / 12.0 // CGFloat(cols.count)
		let dx = rect.width / 20.0
		return (dx,dy)
	}
	
	private var marked : [Int] = [] //Array(repeating: 0, count: 92)
	private var maxcounter : Int {

		var mx = 0
		for m in self.marked {
			mx = max(mx,m)
		}
		return mx
	}
	
	private func DrawPeriodSystem(context : CGContext) {
		
		UIColor.black.setFill()
		context.fill(self.rect)
		let (dx,dy) = GetDxDy()
		let maxcount = maxcounter
		print(maxcount)
		for i in 0..<cols.count {
			let (start,end) = GetColIndices(col: i)
			for j in 0...end-start {
				let elem = ConwayActive.shared.elems[j+start]
				let markcounter = marked[elem.index]
				let name = elem.name
				let x = CGFloat(j) * dx
				let y = CGFloat(i) * dy
				let drect = CGRect(x: x, y: y, width: dx, height: dy)
				UIColor.red.setStroke()
				if markcounter > 0 {
					let hue = CGFloat(markcounter) / CGFloat(1000.0)
					let color = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
					color.setFill()
				} else {
					UIColor.blue.setFill()
				}
				context.fill(drect)
				context.stroke(drect, width: 2.0)
				let attrs = [
					NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),
					//NSParagraphStyleAttributeName: paragraphStyle,
					NSAttributedStringKey.foregroundColor: UIColor.white]
				name.drawCentered(in: drect, withAttributes: attrs)
			}
		}
	}
	
	private func EvolutionInfo(elems: [ConwayPrimordial]) -> String {
		var str = ""
		for e in elems {
			if let c = e as? ConwayElem {
				str = str + c.name
			} else {
				str = str + e.src
			}
		}
		//print(str)
		return str
	}
	
	private func EvoluteDiagramm() {
		//Evolution of found elems
		for i in 0..<marked.count {
			if marked[i] > 0 {
				let markedelem = ConwayActive.shared.elems[i]
				let isotops = markedelem.Isotops()
				for isotop in isotops {
					marked[isotop.index] += 1
				}
				marked[i] -= 1
			}
		}
	}
	
	private func DrawEvolution(context : CGContext) {
		
		let (dx,dy) = GetDxDy()
		let x = CGFloat(0)
		let y = dy * 10
		let rect1 = CGRect(x: x, y: y, width: rect.width, height: dy)
		let rect2 = CGRect(x: x, y: y+dy, width: rect.width, height: dy)
		let attrs = [
			NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),
			//NSParagraphStyleAttributeName: paragraphStyle,
			NSAttributedStringKey.foregroundColor: UIColor.white]
		var look = String(self.nr)
		

		var evolutingelems : [ConwayElem] = []
		
		for _ in 0..<92 {
			var dest = "" // ConwayElem.LookandSay(look: look)

			EvoluteDiagramm()
			DrawPeriodSystem(context: context)
			
			look.drawRight(in: rect1, withAttributes: attrs)
			
			if look != "" {
				let elems = ConwayActive.shared.Compose(s: look)
				for mark in elems {
					if let markelem = mark as? ConwayElem {
						marked[markelem.index] += 1
					} else {
						dest = mark.dest	//Nextlook
					}
				}
				let draw = EvolutionInfo(elems: elems)
				draw.drawCentered(in: rect2, withAttributes: attrs)
			}
			
			
			if emitter != nil {
				guard let newimage  = UIGraphicsGetImageFromCurrentImageContext() else { continue }
				emitter?.Emit(image: newimage)
			}
			look = dest
			//if dest == "" { break }
		}
		
	}
	
	override func DrawNrImage(rect: CGRect) -> UIImage? {
		_ = super.DrawNrImage(rect: rect)
		
		marked = Array(repeating: 0, count: 92)
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		defer { UIGraphicsEndImageContext() }
		guard let context = UIGraphicsGetCurrentContext() else { return nil }
		
		DrawPeriodSystem(context: context)
		DrawEvolution(context : context)

		/*
		context.setStrokeColor(UIColor.black.cgColor)
		context.setLineWidth(1.0);
		context.beginPath()
		
		let color = UIColor.white
		color.setFill()
		context.fill(rect)
		
		DrawNumber(context : context)
		*/
		
		guard let newimage  = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
		emitter?.Emit(image: newimage)
		return newimage
	}
}





