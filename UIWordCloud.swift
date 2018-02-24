//
//  StrokeAnimator2.swift
//  DrawTextAnimationDemo
//
//  Created by Franklin Schrans on 1/21/17.
//  Copyright © 2017 Franklin Schrans. All rights reserved.
//

import UIKit

public class UIWordCloudView: UIView {
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		self.clearsContextBeforeDrawing = true
		self.backgroundColor = UIColor.black
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private var textarr : [(s: String,font : String?)] = []
	var needcomputing = true
	func AppendString(s: String,font : String? = nil) {
		textarr.append((s,font))
		needcomputing = true
	}
	func Clear() {
		textarr = []
	}
	
	override public var frame: CGRect {
		get { return super.frame }
		set {
			super.frame = newValue
			needcomputing = true
			setNeedsDisplay()
		}
	}
	
	struct DrawCloudParam {
		var str : String
		var font : String?
		var fontsize : CGFloat
		var rect : CGRect
		init(str : String, font: String?,fontsize : CGFloat, rect : CGRect) {
			self.str = str
			self.font = font
			self.fontsize = fontsize
			self.rect = rect
		}
	}
	private var params : [DrawCloudParam] = []
	
	var paragraph : NSMutableParagraphStyle {
		get {
			let p = NSMutableParagraphStyle()
			p.alignment = .center
			p.lineHeightMultiple = 0.8
			p.lineBreakMode = .byWordWrapping
			return p
		}
	}
	
	func Font(fontname : String?, fontsize : CGFloat) -> UIFont {
		if let name = fontname {
			if let font = UIFont(name: name, size: fontsize) {
				return font
			}
		}
		return UIFont.systemFont(ofSize: fontsize)
	}
	
	func getAttrString(s: String,fontname: String?,fontsize : CGFloat,color : UIColor) -> NSAttributedString {
		let font = Font(fontname: fontname,fontsize: fontsize)
		let attributes = [NSAttributedStringKey.paragraphStyle:paragraph,
						  NSAttributedStringKey.font:font,
						  NSAttributedStringKey.foregroundColor : color]
		let attrString = NSAttributedString(string: s,attributes: attributes)
		return attrString
	}
	
	private func GetStrSize(s : String, font: String?,fontsize : CGFloat, frame : CGRect) -> CGSize{
		let attrString = getAttrString(s: s, fontname: font,fontsize: fontsize, color: UIColor.black)
		let drawingOptions: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
		let brect = CGSize(width: frame.width / 2,height: CGFloat.greatestFiniteMagnitude)
		let rect = attrString.boundingRect(with: brect, options: drawingOptions, context: nil)
		return rect.size
		//let size = attrString.size()
		//return size
	}
	
	private func CheckIntersect(rect : CGRect) -> Bool {
		for p in params {
			if p.rect.intersects(rect) {
				return false
			}
		}
		return true
	}
	
	private func VerticalText(s: String) -> String {
		var ans = ""
		for (index,c) in s.reversed().enumerated() {
			if String(c) == "\u{200B}" { continue }
			if String(c) == "\u{00AD}"  { continue }
			
			if index > 0 { ans = "\n" + ans }
			
			ans = String(c) + ans
		}
		return ans
	}
	
	private func GetParam(str: String,font:String?,frame : CGRect) -> DrawCloudParam? {		
		var fontsize : CGFloat = 100.0
		let svert = VerticalText(s: str)
		var vertical = false
		
		for iteration in 1...1000  {
			let x0 = CGFloat(arc4random_uniform(UInt32(frame.width)))
			let y0 = CGFloat(arc4random_uniform(UInt32(frame.height)))
			var maxframe = CGRect(x:0,y: 0, width : frame.width , height : frame.height)
			let s = vertical ? svert : str
			let size = GetStrSize(s: s, font: font, fontsize: fontsize,frame : maxframe)
			
			/*
			if size.width > frame.width {
				fontsize = fontsize * frame.width / size.width * 0.8
				continue
			}
			if size.height > frame.height {
				fontsize = fontsize * frame.height / size.height * 0.8
				continue
			}
			*/
			let x = x0 - size.width / 2
			let y = y0 - size.height / 2
			let rect = CGRect(x: x, y: y, width: size.width,height:size.height)
			let x1 = x + size.width
			let y1 = y + size.height
			
			let isvalid = x > 0 && y > 0 && x1 < frame.width && y1 < frame.height
			
			if isvalid && CheckIntersect(rect: rect) {
				let ans = DrawCloudParam(str: s, font: font, fontsize: fontsize, rect: rect)
				return ans
			}
			
			if iteration % 11 == 0 {
				fontsize = fontsize * 8.0 / 10.0
			}
			if iteration % 13 == 0 {
				vertical = !vertical
			}
			
		}
		return nil
	}
	
	private func InsertNL(s: String) -> String {
		let words = s.split(separator: " ").map(String.init)
		var ans = ""
		for w in words {
			if ans != "" { ans = ans + "\n" }
			ans = ans + w
		}
		return ans
	}
	
	private var workItem : DispatchWorkItem? = nil
	func Compute(frame : CGRect) {
		
		let frame = self.frame
		if workItem != nil {
			workItem?.cancel()
			//print("Cancelled")
		}
		workItem = DispatchWorkItem {
			//print("Computing")
			self.textarr.shuffle()
			self.params = []
			var iscancel = false
			for t in self.textarr {
				let tsplit = t.s //self.InsertNL(s: t.s)
				if let p = self.GetParam(str: tsplit, font: t.font,frame : frame) {
					self.params.append(p)
				}
				iscancel = self.workItem?.isCancelled ?? true
				if iscancel {
					print("Calculation break")
					break
				}
			}
			if !iscancel {
					//print("Computing end")
					DispatchQueue.main.async(execute: {
						//print("Displaying")
						self.needcomputing = false
						self.setNeedsDisplay()
						self.workItem = nil
						//print("Displayed")
					})
			}
			else {
				print("Cancelled without display")
			}
		}
		
		DispatchQueue.global(qos: .userInitiated).async(execute: workItem!)
	}
	
	private var isindraw = 0
	private func PerformDraw() {
		let dhue : CGFloat = textarr.count == 0 ? 0.0 : 1.0 / CGFloat(textarr.count)
		var hue : CGFloat = 0.0
		isindraw = isindraw + 1
		for p in params {
			let color = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
			let attrString = getAttrString(s: p.str, fontname: p.font, fontsize: p.fontsize, color: color)
			let drawingOptions: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
			attrString.draw(with: p.rect, options: drawingOptions, context: nil)
			hue = hue + dhue
		}
		isindraw = 0
	}
	public override func draw(_ rect: CGRect) {
		//textarr = [("1aaaa a aaaaaa aaabbb bbbbbbbbbbb bbbcccccccccccc ccccccdddd1",nil)]
		if needcomputing {
			Compute(frame: self.frame)
			if let s = textarr.first {
				let infin = "\u{221E}"
				let attrString = getAttrString(s: s.s, fontname: nil, fontsize: 20.0, color: UIColor.darkGray)
				let drawingOptions: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
				attrString.draw(with: rect, options: drawingOptions, context: nil)
			}
		} else {
			PerformDraw()
		}
		
	}
}
