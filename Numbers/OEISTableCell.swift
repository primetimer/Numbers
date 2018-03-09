//
//  WikiCell.swift
//  Numbers
//
//  Created by Stephan Jancar on 02.03.18.
//  Copyright © 2018 Stephan Jancar. All rights reserved.
//

import Foundation
import UIKit
import BigInt
import WebKit
import SafariServices

class OEISTableCell: BaseNrTableCell , WKNavigationDelegate {
	private (set) var uiweb = WKWebView() // UIWebView()
	
	private var oeisurl : String = ""
	func SetOEISUrl(oeis : String) {
		if oeis == oeisurl {
			return
		}
		oeisurl = oeis
		if let url = URL(string: oeis) {
			let request = URLRequest(url: url)
			//uiweb.delegate = self
			uiweb.navigationDelegate = self
			uiweb.load(request)
		}
	}
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		uiweb.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(uiweb)
		uiweb.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0).isActive = true
		uiweb.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant : -10.0).isActive = true
		uiweb.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		uiweb.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		let config = uiweb.configuration
		config.dataDetectorTypes = []
		//uiweb.dataDetectorTypes = []
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	#if true
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		let scrollPoint = CGPoint(x: 0, y: 48.0)
		uiweb.scrollView.setContentOffset(scrollPoint, animated: true)//Set false if you doesn't want animation
	}
	#else
	func webViewDidFinishLoad(_ webView: UIWebView)	{
		let scrollPoint = CGPoint(x: 0, y: 48.0)
		uiweb.scrollView.setContentOffset(scrollPoint, animated: true)//Set false if you doesn't want animation
	}
	#endif
	
	#if true
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		var action: WKNavigationActionPolicy?
		defer {
			decisionHandler(action ?? .allow)
		}		
		guard let url = navigationAction.request.url else { return }
		if navigationAction.navigationType == .linkActivated	{
			action = .cancel                  // Stop in WebView
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
			//UIApplication.shared.openURL(url) // Open in Safari
		}
	}
	#else
	func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		switch navigationType {
		case .linkClicked:
			// Open links
			return true
		case .formSubmitted:
			return true
		case .backForward:
			return true
		case .reload:
			return true
		case .formResubmitted:
			return true
		case .other:
			return true
		}
	}
	#endif
}

