//
//  StrokeAnimator2.swift
//  DrawTextAnimationDemo
//
//  Created by Franklin Schrans on 1/21/17.
//  Copyright © 2017 Franklin Schrans. All rights reserved.
//

import UIKit
import Photos

/*
public class UIWordCloudViewDeep : UIWordCloudView {
	
	//var deepPressGestureRecognizer : DeepPressGestureRecognizer!
	var longPressGestureRecognizer : UILongPressGestureRecognizer!
	override public init(frame: CGRect) {
		super.init(frame: frame)
		//deepPressGestureRecognizer = DeepPressGestureRecognizer(target: self,action: #selector(DeepPress),threshold: 0.75)
		longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(DeepPress))
		self.addGestureRecognizer(longPressGestureRecognizer)
		self.isUserInteractionEnabled = true
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func imageWithView(inView: UIView) -> UIImage? {
		let size = CGSize(width: 800, height: 800)
		UIGraphicsBeginImageContextWithOptions(size, inView.isOpaque, 0.0)
		defer { UIGraphicsEndImageContext() }
		if let context = UIGraphicsGetCurrentContext() {
			inView.layer.render(in: context)
			let image = UIGraphicsGetImageFromCurrentImageContext()
			return image
		}
		return nil
	}
	
	func Authorize() {
		// Get the current authorization state.
		let status = PHPhotoLibrary.authorizationStatus()
		if (status == PHAuthorizationStatus.authorized) {
			SaveImage() // Access has been granted.
		}
		else if (status == PHAuthorizationStatus.denied) {
			return // Access has been denied.
		}
		else if (status == PHAuthorizationStatus.notDetermined) {
			// Access has not been determined.
			PHPhotoLibrary.requestAuthorization({ (newStatus) in
				if (newStatus == PHAuthorizationStatus.authorized) {
					self.SaveImage()
				}
				else {
					return
				}
			})
		}
		else if (status == PHAuthorizationStatus.restricted) {
			// Restricted access - normally won't happen.
			return
		}
		return
	}
	
	@objc func DeepPress() {
		Authorize()
	}
	
	private func SaveImage() {
		guard let image = imageWithView(inView: self) else {
			print("No Image?")
			return
		}
		UIImageWriteToSavedPhotosAlbum(image, self,nil,nil)
		print("Saved")
		var alert = UIAlertView(title: "Numbers",
					message: "Your image has been saved to Photo Library!",
					delegate: nil,
					cancelButtonTitle: "Ok")
		alert.show()
	}
	
	
	
}
*/

public class UIWordCloudView: UIImageView {
	private var _verbose : Bool = false
	
	init() {
		super.init(frame: CGRect.zero)
		self.clearsContextBeforeDrawing = true
		self.backgroundColor = UIColor.black
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private var drawworker : DispatchWorkItem? = nil
	
	private var _rect : CGRect = CGRect.zero
	override public func layoutSubviews() {
		super.layoutSubviews()
		if self.frame != _rect {
			contentchanged = true
		}
		_rect = self.frame
	}
	/*
	override public var frame: CGRect {
		didSet {
			if frame != _rect {
				contentchanged = true
				_rect = frame
			}
		}
	}
	*/
	
	private var textarr : [(s: String,font : String?)] = []
	func AppendString(s: String,font : String? = nil) {
		//textarr.append((String(textarr.count),nil))
		textarr.append((s,font))
		contentchanged = true
	}
	func Clear() {
		textarr = []
	}
	
	private var contentchanged : Bool = false

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
		let brect = CGSize(width: frame.width * 0.6667 ,height: CGFloat.greatestFiniteMagnitude)
		let rect = attrString.boundingRect(with: brect, options: drawingOptions, context: nil)
		return rect.size
	}
	
	private func CheckIntersect(rect : CGRect,params : [DrawCloudParam] ) -> Bool {
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
	
	private func GetParam(str: String,font:String?,frame : CGRect, params : [DrawCloudParam]) -> DrawCloudParam? {
		var fontsize : CGFloat = 100.0
		let svert = VerticalText(s: str)
		var vertical = false
		
		for iteration in 1...1000  {
			let x0 = CGFloat(arc4random_uniform(UInt32(frame.width)))
			let y0 = CGFloat(arc4random_uniform(UInt32(frame.height)))
			let maxframe = CGRect(x:0,y: 0, width : frame.width * 1.0 , height : frame.height * 1.0)
			let s = vertical ? svert : str
			let size = GetStrSize(s: s, font: font, fontsize: fontsize,frame : maxframe)

			let x = x0 - size.width / 2
			let y = y0 - size.height / 2
			let rect = CGRect(x: x, y: y, width: size.width,height:size.height)
			let x1 = x + size.width
			let y1 = y + size.height
			
			let isvalid = x > 0 && y > 0 && x1 < frame.width && y1 < frame.height
			
			if isvalid && CheckIntersect(rect: rect, params: params) {
				let ans = DrawCloudParam(str: s, font: font, fontsize: fontsize, rect: rect)
				return ans
			}
			
			if iteration % 11 == 0 {
				fontsize = fontsize * 8.0 / 10.0
			}
			if iteration % 13 == 0 {
				vertical = !vertical
			}
			if iteration % 17 == 0 {
				vertical = false
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
	
	private var indicator = ViewControllerUtils()
	private var workItem : DispatchWorkItem? = nil
	
	private func Compute(frame : CGRect) {
		if contentchanged && workItem != nil {
			workItem?.cancel()
			if _verbose { print("Cancelled") }
		}
		self.contentchanged = false

		self.workItem = DispatchWorkItem {
			if self._verbose { print("Computing:" , frame) }
			let worker = self.workItem
			self.textarr.shuffle()
			var params : [DrawCloudParam] = []
			var iscancel = false
			
			for t in self.textarr {
				let tsplit = t.s
				if let p = self.GetParam(str: tsplit, font: t.font,frame : self._rect, params: params) {
					params.append(p)
				}
				iscancel = worker?.isCancelled ?? true
				if iscancel {
					if self._verbose { print("Calculation break") }
					break
				}
				//Draw in progress
				#if true
					self.PerformDraw(rect: self._rect, params: params)
					#else
				DispatchQueue.main.async(execute: {
					if self._verbose { print("DisplayingInProgress", t.s) }
					self.PerformDraw(rect: _rect, params: params)
					if self._verbose { print("DisplayedInProgres",t.s) }
				})
				#endif
			}
			if !iscancel {
				if self._verbose { print("Computing end") }
					DispatchQueue.main.async(execute: {
						if self._verbose { print("Displaying") }
						self.workItem = nil
						self.PerformDraw(rect: frame, params: params)
						if self._verbose { print("Displayed") }
					})
			}
			else {
				if self._verbose { print("Cancelled without display") }
			}
		}
		DispatchQueue.global(qos: .userInitiated).async(execute: workItem!)
	}
	private func PerformDraw(rect : CGRect, params : [DrawCloudParam] ) {
		drawworker?.cancel()
		self.drawworker = DispatchWorkItem {
			if self.frame.size == CGSize.zero { return }

			let worker = self.drawworker
			let size = rect.size //CGSize(width: 800, height: 800)
			UIGraphicsBeginImageContext(size)
			defer { UIGraphicsEndImageContext() }
		
			let dhue : CGFloat = self.textarr.count == 0 ? 0.0 : 1.0 / CGFloat(self.textarr.count)
			var hue : CGFloat = 0.0
			for p in params {
				if worker?.isCancelled ?? false { break }
				let color = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
				let attrString = self.getAttrString(s: p.str, fontname: p.font, fontsize: p.fontsize, color: color)
				let drawingOptions: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
				attrString.draw(with: p.rect, options: drawingOptions, context: nil)
				hue = hue + dhue
			}
			let iscancelled = worker?.isCancelled ?? false
			if !iscancelled {
				let image = UIGraphicsGetImageFromCurrentImageContext()
				self.image = image
			}
		}
		
		//DispatchQueue.global(qos: .userInteractive).async(execute: drawworker!)
		DispatchQueue.main.async(execute: drawworker!)
		
	}
	
	//private var lastsize = CGSize.zero
	public func DrawCloud(force : Bool = false) {
		if _rect == CGRect.zero { return }
		if force { contentchanged = true }
		
		/*
		if frame.size.height != lastsize.height {
			contentchanged = true;
			lastsize = self.frame.size
		}
		*/
		if contentchanged {
			//	InitialImage(rect: self.frame)
			Compute(frame: self._rect)
		}
	}
}
