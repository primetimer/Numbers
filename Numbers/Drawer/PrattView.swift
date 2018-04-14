//
//  Pratt
//  Numbers
//
//  Created by Stephan Jancar on 15.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//


import Foundation
import UIKit
import BigInt
import GhostTypewriter
import iosMath

class PrattView : DrawNrView {
	
	private var uiscrollv = UIScrollView()
	private var uipratt = MTMathUILabel()
	
	private func LayoutViews() {
		self.backgroundColor = .white
		
		uipratt.translatesAutoresizingMaskIntoConstraints = false
		uiscrollv.translatesAutoresizingMaskIntoConstraints = false
		
		uipratt.fontSize = 20.0
		addSubview(uiscrollv)
		
		uiscrollv.addSubview(uipratt)
		uiscrollv.leftAnchor.constraint (equalTo: self.leftAnchor, constant : 10.0).isActive = true
		uiscrollv.rightAnchor.constraint(equalTo: self.rightAnchor, constant : -10.0 ).isActive = true
		uiscrollv.topAnchor.constraint(equalTo: self.topAnchor,constant: 0.0).isActive = true
		uiscrollv.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: 0.0).isActive = true
		uiscrollv.contentSize = CGSize(width: 1000.0, height: 1000.0)
		
		//uipratt.backgroundColor = .white
		uipratt.leftAnchor.constraint (equalTo: uiscrollv.leftAnchor,constant: 0.0).isActive = true
		uipratt.topAnchor.constraint(equalTo: uiscrollv.topAnchor,constant: 0.0).isActive = true
		
		//uipratt.heightAnchor.constraint(equalToConstant: 1000.0).isActive = true
		//uipratt.widthAnchor.constraint(equalToConstant: 1000.0).isActive = true
		
		//let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
		uiscrollv.isUserInteractionEnabled = true
		//imageview.addGestureRecognizer(tapGestureRecognizer)
		
		
	}
	
	override func layoutSubviews() {
		ShowCertificat()
	}
	
	init () {
		super.init(frame: CGRect.zero)
		LayoutViews()
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/*
	override var frame : CGRect {
	didSet {
	uiscrollv.frame = frame
	self.setNeedsDisplay()
	}
	}
	*/
	
	override var nr : BigUInt {
		didSet {
			ShowCertificat()
			self.setNeedsLayout()
		}
	}
	
	private func CreatePratt() {
		uipratt.removeFromSuperview()
		uipratt = MTMathUILabel()
		uipratt.translatesAutoresizingMaskIntoConstraints = false
		uiscrollv.addSubview(uipratt)
	}
	
	//private var workItem: DispatchWorkItem? = nil
	private func ShowCertificat() {
		CreatePratt()
		
		workItem?.cancel()
		self.workItem = DispatchWorkItem {
			let worker = self.workItem
			let prattcert = PrattCertficate(nr: BigUInt(self.nr))
			let latex = prattcert.LatexCertificate()
			var latexconcat = ""
			if prattcert.PrattTest() {
				latexconcat = "\\text{ PRATT CERTIFICATE }" //+ "\\\\" //+ general
			} else {
				latexconcat = "\\text{ COMPOSITE CERTIFICATE }" //+ "\\\\" //+ general
			}
			for l in latex {
				if latexconcat != "" { latexconcat = latexconcat + " \\\\" }
				latexconcat = latexconcat + l
			}
			latexconcat = latexconcat + "\\\\ \\\\" +  prattcert.LatexGeneralInfo()
			
			
			DispatchQueue.main.async(execute: {
				
				self.uipratt.latex = latexconcat
				self.uipratt.sizeToFit()
				let size : CGSize = self.uipratt.sizeThatFits(CGSize(width:1000.0, height: CGFloat.greatestFiniteMagnitude))
				self.uipratt.removeFromSuperview()
				self.uiscrollv.addSubview(self.uipratt)
				self.uipratt.sizeToFit()
				self.uiscrollv.contentSize = CGSize(width: 1000.0, height: size.height+40.0)
				
				self.uipratt.leftAnchor.constraint (equalTo: self.uiscrollv.leftAnchor,constant: 0.0).isActive = true
				self.uipratt.topAnchor.constraint(equalTo: self.uiscrollv.topAnchor,constant: 0.0).isActive = true
				self.uipratt.heightAnchor.constraint(equalToConstant: self.uiscrollv.contentSize.height).isActive = true
				self.uipratt.widthAnchor.constraint(equalToConstant: 1000.0).isActive = true
			})
		}
		DispatchQueue.global(qos: .userInitiated).async(execute: workItem!)
	}
}







