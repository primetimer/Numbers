//
//  SquareDrawer.swift
//  Numbers
//
//  Created by Stephan Jancar on 15.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit
import BigInt
import GhostTypewriter

class DullView : DrawNrView {
	
	private var uiscrollv = UIScrollView()
	private var imageview = UIImageView()

	private func LayoutViews() {
		imageview.backgroundColor = self.backgroundColor
		imageview.translatesAutoresizingMaskIntoConstraints = false
		uiscrollv.translatesAutoresizingMaskIntoConstraints = false
		addSubview(uiscrollv)
		uiscrollv.addSubview(imageview)
		uiscrollv.leftAnchor.constraint (equalTo: self.leftAnchor, constant : 10.0).isActive = true
		uiscrollv.rightAnchor.constraint(equalTo: self.rightAnchor, constant : -10.0 ).isActive = true
		uiscrollv.topAnchor.constraint(equalTo: self.topAnchor,constant: 0.0).isActive = true
		uiscrollv.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: 0.0).isActive = true
		uiscrollv.contentSize = CGSize(width: self.width, height: 1000.0)
		
		imageview.leftAnchor.constraint(equalTo: uiscrollv.leftAnchor).isActive = true
		imageview.rightAnchor.constraint(equalTo: uiscrollv.rightAnchor).isActive = true
		imageview.topAnchor.constraint(equalTo: uiscrollv.topAnchor).isActive = true
		imageview.heightAnchor.constraint(equalToConstant: uiscrollv.contentSize.height)
		
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
		uiscrollv.isUserInteractionEnabled = true
		imageview.isUserInteractionEnabled = true
		imageview.addGestureRecognizer(tapGestureRecognizer)
		

	}

	init () {
		super.init(frame: CGRect.zero)
		LayoutViews()
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override var frame : CGRect {
		didSet {
			uiscrollv.frame = frame
			self.setNeedsDisplay()
		}
	}
	
	@objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
	{
		AddAnimation()
	}
	
	private func scrollDown() {
		
		UIView.animate(withDuration: 10.0, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
			self.uiscrollv.contentOffset.y = self.uiscrollv.contentSize.height / 2.0 // - self.uiscrollv.height
		}, completion: { finished in
			self.uiscrollv.contentOffset.y = 0
			self.scrollDown()
		})
	}
	private func scrollUp() {
		self.uiscrollv.contentOffset.y = 0.0
		return
		UIView.animate(withDuration: 10.0, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
			self.uiscrollv.contentOffset.y = 0.0
		}, completion:  nil)
	}
	/*
	private func scrollDown() {
		DispatchQueue.main.async(execute: {
			UIView.animate(withDuration: 10.0, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
				self.uiscrollv.contentOffset.y = 1000.0
			}, completion: { finished in
				self.scrollUp()
			})
		})
	}
	private func scrollUp() {
		DispatchQueue.main.async(execute: {
			UIView.animate(withDuration: 10.0, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
				self.uiscrollv.contentOffset.y = 0.0
			}, completion: { finished in self.scrollDown() })
		})
	}
	*/
	func AddAnimation() {
		scrollDown()
	}
	
	//lazy var animation : CAKeyframeAnimation = { return CAKeyframeAnimation(keyPath: "transform") } ()
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		imageview.stopAnimating()
		let drect = CGRect(x: rect.minX, y: rect.minY,width: rect.width, height: rect.height*4.0)
		if let image = NumberImage(rect: drect) {
			imageview.image = image
			AddAnimation()
		}
	}
	
	private func NumberImage(rect : CGRect) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		defer { UIGraphicsEndImageContext() }
		guard let context = UIGraphicsGetCurrentContext() else { return nil }
		
		context.setStrokeColor(UIColor.black.cgColor)
		context.setLineWidth(1.0);
		context.beginPath()
		let draw = DullDrawer(nr: self.nr, rect: rect)
		let size = draw.AttrDullSize()
		//let size = draw.DrawNumber(context : context)
		uiscrollv.contentSize = size
		draw.DrawNumber(context: context)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		return image
	}
}

class DullDrawer : NSObject
{
	private var context : CGContext!
	private var nr : UInt64 = 1
	private var rect : CGRect!
	
	init(nr : UInt64, rect : CGRect) {
		super.init()
		self.nr = nr
		self.rect = rect
	}
	
	private func DullString() -> String {
		var ans = ""
		for t in Tester.shared.testers {
			if t is CompositeTester { continue }
			//if t is DullTester { continue }
			if !ans.isEmpty { ans = ans + "\n" }
			let special = t.isSpecial(n: BigUInt(self.nr))
			if !special { ans = ans + "not " }
			ans = ans + t.property()
		}
		return ans
	}
	
	private func colorWithGradient(frame: CGRect, colors: [UIColor]) -> UIColor {
		
		// create the background layer that will hold the gradient
		let backgroundGradientLayer = CAGradientLayer()
		backgroundGradientLayer.frame = frame
		
		// we create an array of CG colors from out UIColor array
		let cgColors = colors.map({$0.cgColor})
		
		backgroundGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
		backgroundGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
		backgroundGradientLayer.colors = cgColors
		
		UIGraphicsBeginImageContext(backgroundGradientLayer.bounds.size)
		backgroundGradientLayer.render(in: UIGraphicsGetCurrentContext()!)
		let backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return UIColor(patternImage: backgroundColorImage!)
	}
	
	private func Font(fontsize : CGFloat) -> UIFont {
		return UIFont.systemFont(ofSize: fontsize)
	}
	
	private func Attributes(fontsize : CGFloat, color : UIColor ) -> [NSAttributedStringKey: Any] {
		let font = Font(fontsize:fontsize)
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .center

		let attributes = [NSAttributedStringKey.paragraphStyle  :  paragraphStyle,
						  NSAttributedStringKey.font: font,
						  NSAttributedStringKey.foregroundColor : color]
		return attributes
	}
	
	func AttrDullString() -> NSAttributedString {
		let dullstring = DullString() + "\n" + DullString()
		let fontSize : CGFloat = 20.0
		let attributes = Attributes(fontsize: fontSize, color : .white)
		let attrString = NSAttributedString(string: dullstring,attributes: attributes)
		return attrString
	}
	
	func AttrDullSize() -> CGSize {
		let atrrstring = AttrDullString()
		return atrrstring.size()
	}
	func DrawNumber(context : CGContext)
	{
		self.context = context
		let attrString = AttrDullString()
		attrString.draw(in: rect)
	}
}





