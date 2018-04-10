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

class ConwayView : DrawNrImageView {

	init () {
		super.init(frame: CGRect.zero)
		self.imageview.animationDuration = 60.0
		self.imageview.animationRepeatCount = 1
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

	private var cols : [(String,String)] = [("U","Ta"),("Hf","Er"),("Ho","Sm"),("Pm","Xe"),("I","Y"),("Sr","Ga"),("Zn","Sc"),("Ca","He"),("H","H")]
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
	
	private func EvolutionInfo(elems: [ConwayElem]) -> String {
		var str = ""
		for (index,e) in elems.enumerated() {
			if index > 0 { str = str + "-" }
			str = str + e.name
		}
		return str
	}
	private func EvolutionNr(elems: [ConwayElem]) -> String {
		var str = ""
		for (index,e) in elems.enumerated() {
			if index > 0 { str = str + "-" }
			str = str + e.src
		}
		return str
	}
	
	struct InfoString {
		var srcnr : String = ""
		var destnr : String = ""
		var srcelem : String
		var destelem : String
		
		init(srcnr : String, elems : [ConwayElem]) {
			
			let prim = ConwayPrimordial(src: srcnr)
			self.srcelem = ""
			self.destelem = ""
			for e in elems {
				if !srcelem.isEmpty { srcelem = srcelem + ":"}
				if !destelem.isEmpty { destelem = destelem + ":"}
				srcelem = srcelem + e.name
				for i in e.Isotops() {
					destelem = destelem + i.name
				}
			}
			
			if !elems.isEmpty && !srcnr.isEmpty { srcelem = srcelem + ":"}
		}
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
		let y = dy * 9
		let rect1 = CGRect(x: x, y: y, width: rect.width, height: dy)
		let rect2 = CGRect(x: x, y: y+2*dy, width: rect.width, height: dy)
		let attrs = [
			NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),
			//NSParagraphStyleAttributeName: paragraphStyle,
			NSAttributedStringKey.foregroundColor: UIColor.white]
		var dest = String(self.nr)
		
		var found : [ConwayElem] = []
		for _ in 0..<92 {
			let look = dest
			let drawsrc = EvolutionInfo(elems: found) + look + "\n" + EvolutionNr(elems: found)
			
			found = ConwayActive.shared.Evolute(src: found)
			EvoluteDiagramm()
			
			if look != "" {
				dest = ""
				let elems = ConwayActive.shared.Compose(s: look)
				for mark in elems {
					if let foundelem = mark as? ConwayElem {
						marked[foundelem.index] += 1
						found.append(foundelem)
					} else {
						dest = mark.dest	//Nextlook
					}
				}
			}
			DrawPeriodSystem(context: context)

			let drawdest = EvolutionInfo(elems: found) + dest + "\n" + EvolutionNr(elems: found) + dest
			drawsrc.drawRight(in: rect1, withAttributes: attrs)
			drawdest.drawRight(in: rect2, withAttributes: attrs)
			while found.count > 50 {
				found.remove(at: 0)
			}
			
			if emitter != nil {
				guard let newimage  = UIGraphicsGetImageFromCurrentImageContext() else { continue }
				emitter?.Emit(image: newimage)
			}
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

		guard let newimage  = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
		emitter?.Emit(image: newimage)
		return newimage
	}
}





