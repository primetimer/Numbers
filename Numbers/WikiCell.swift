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
import SafariServices

protocol NumberJump {
	func Jump(to: BigUInt)
	func WikiJump(wikiurl : URL)
}

class WikiTableCell: BaseNrTableCell , UIWebViewDelegate {
	private (set) var uiweb = UIWebView()
	
	private var wikiurl : String = ""
	var jumper : NumberJump? = nil
	
	func SetWikiUrl(wiki : String) {
		if wiki == wikiurl {
			return
		}
		wikiurl = wiki
		if let url = URL(string: wiki) {
			let request = URLRequest(url: url)
			uiweb.delegate = self
			uiweb.loadRequest(request)

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
		uiweb.dataDetectorTypes = []
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	#if false
	//Check redirect
	private let wikidefault = "https://en.wikipedia.org/wiki/List_of_numbers"
	private func CheckRedirectNr(webView : UIWebView) -> String? {
	
		guard let requestednr = WikiLinks.shared.ExtractLinkToNumber(url: wikiurl) else { return nil }
		guard let load = webView.request?.mainDocumentURL?.absoluteString else { return wikidefault }
		guard let loadednr = WikiLinks.shared.ExtractLinkToNumber(url: load) else { return wikidefault }
		if requestednr != loadednr { return wikidefault }
		return nil
	}
	
	private func AlternativePropertys(nr : BigUInt) -> String {
		if nr == 0 { return wikidefault }
		var possible : [String] = []
		for t in Tester.testers {
			if t.isSpecial(n: nr) {
				possible.append(t.property())
			}
		}
		if possible.count == 0 { return wikidefault }
		let r = Int(arc4random_uniform(UInt32(possible.count)))
		let ans = WikiLinks.shared.Address(key: possible[r])
		if ans.isEmpty { return wikidefault }
		return ans
	}
	
	private func CheckRedirecNotFound(webView : UIWebView) -> String? {
		guard let html = webView.stringByEvaluatingJavaScript(from: "document.body.innerHTML") else { return nil }
		if html.contains("Wikipedia does not have an article") {
			return AlternativePropertys(nr: self.nr)
		}
		return nil
	}
	#endif
	
	func webViewDidFinishLoad(_ webView: UIWebView)	{
		self.nr = WikiLinks.shared.ExtractLinkToNumber(url: wikiurl) ?? 0
		
		#if false
		if let redirect = CheckRedirectNr(webView: webView) {
			SetWikiUrl(wiki: redirect)
			return
		}
		if let redirect = CheckRedirecNotFound(webView : webView) {
			SetWikiUrl(wiki: redirect)
			return
		}
		#endif
		
		let scrollPoint = CGPoint(x: 0, y: 48.0)
		uiweb.scrollView.setContentOffset(scrollPoint, animated: true)//Set false if you doesn't want animation
	}
	
	func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		switch navigationType {
		case .linkClicked:
			// Open links
			guard let url = request.url else { return true }
			if jumper == nil { return true }
			if let nr = WikiLinks.shared.ExtractLinkToNumber(url: url.absoluteString) {
				jumper?.Jump(to: nr)

			}
			else {
				jumper?.WikiJump(wikiurl: url)
			}
							return false
		
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
}

