//
//  DescCell.swift
//  Numbers
//
//  Created by Stephan Jancar on 01.01.18.
//  Copyright © 2018 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit
import BigInt
import FutureKit

class DescCollectionCell: BaseNrCollectionCell , UIWebViewDelegate {
	private (set) var uidesc = UIWebView()
	private (set) var uinr = UILabel()
	
	override var nr : BigUInt {
		get { return super.nr }
		set {
			if nr != newValue || nr == 0 {
				super.nr = newValue
				self.SetHtmlDesc(html: "")
				DispatchQueue.global(qos: .background).async {
					print("Explanation call", String(self.nr))
					let exp = Explain.shared.GetExplanation(nr: self.nr)
					print("Explanation called", String(self.nr))
					
					DispatchQueue.main.async(execute: {
						print("Explanation ready", String(self.nr))
						self.SetHtmlDesc(html: exp.html)
					})
				}
				
				let mayafont = UIFont(name: "Mayan", size: 20)
				let deffont = UIFont.systemFont(ofSize: UIFont.labelFontSize)
				uinr.font = deffont
				//uinr.text = nr.Abjad()
				uinr.text = nr.Phonician()
				
				//uinr.text = nr.Vingesimal()
				//uinr.text = nr.Hebraian() //nr.Egytian() // nr.Chinese() // nr.Greek() // nr.Arabian() //  nr.Duodezimal() // nr.Keilschrift()
			}
		}
	}
	
	override init(frame: CGRect){
		super.init(frame: frame)
		
		contentView.translatesAutoresizingMaskIntoConstraints = false
		uidesc.translatesAutoresizingMaskIntoConstraints = false
		uinr.translatesAutoresizingMaskIntoConstraints = false

		contentView.addSubview(uidesc)
		contentView.addSubview(uinr)
		
		print(contentView.frame)
		let margins = contentView.layoutMarginsGuide
		print(margins)

		//uidesc.frame = CGRect(x: 10.0, y: 0, width: self.frame.width, height: self.frame.height)
		let viewsDict = ["nr" : uinr, "web" : uidesc , "content" : contentView]
		let nrHorizontal = "H:|-[nr]-|"
		let descHorizontal = "H:|-[web]-|"
		
		let descVertical = "V:|-[web]-|"
		let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: descHorizontal,
																   options: NSLayoutFormatOptions(rawValue: 0),
																   metrics: nil,
																   views: viewsDict)
		let nrhorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: nrHorizontal,
																   options: NSLayoutFormatOptions(rawValue: 0),
																   metrics: nil,
																   views: viewsDict)
	
		let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: descVertical,
																   options: NSLayoutFormatOptions(rawValue: 0),
																   metrics: nil,
																   views: viewsDict)
		let descHorizontal2 = "H:|-[content]-|"
		let descVertical2 = "V:|-[content]-|"
		let horizontalConstraints2 = NSLayoutConstraint.constraints(withVisualFormat: descHorizontal2, options: NSLayoutFormatOptions(rawValue: 0),metrics: nil,views: viewsDict)
		let verticalConstraints2 = NSLayoutConstraint.constraints(withVisualFormat: descVertical2, options: NSLayoutFormatOptions(rawValue: 0),metrics: nil,views: viewsDict)
		self.addConstraints(horizontalConstraints2)
		self.addConstraints(verticalConstraints2)

		
		contentView.addConstraints(horizontalConstraints)
		contentView.addConstraints(nrhorizontalConstraints)
		contentView.addConstraints(verticalConstraints)
		
		/*
			uidesc.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
			uidesc.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
			uidesc.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
			uidesc.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
			uidesc.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
			//uidesc.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		*/
		
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private var _html = ""
	private var _loaded = false
	private func SetHtmlDesc(html : String) {
		if html == _html { return }
		_html = html
		_loaded = false
		uidesc.delegate = self
		uidesc.loadHTMLString(html, baseURL: nil)
	}
	
	func webViewDidFinishLoad(_ webView: UIWebView)
	{
		if _loaded { return }
		_loaded = true
		//tableparent?.beginUpdates()
		//tableparent?.endUpdates()
	}
	
	
	func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		switch navigationType {
		case .linkClicked:
			// Open links in Safari
			guard let url = request.url else { return true }
			
			if #available(iOS 10.0, *) {
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			} else {
				// openURL(_:) is deprecated in iOS 10+.
				UIApplication.shared.openURL(url)
			}
			return false
		default:
			// Handle other navigation types...
			return true
		}
	}
}

