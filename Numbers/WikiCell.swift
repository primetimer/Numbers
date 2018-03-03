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

protocol NumberJump {
	func Jump(to: BigUInt)
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
		contentView.addSubview(uiweb)
		uiweb.translatesAutoresizingMaskIntoConstraints = false
		uiweb.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0).isActive = true
		uiweb.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant : 0.0).isActive = true
		uiweb.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		uiweb.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		uiweb.dataDetectorTypes = []
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//Check redirect
	private let wikidefault = "https://en.wikipedia.org/wiki/List_of_numbers"
	private func CheckRedirectNr(webView : UIWebView) -> String? {
		guard let requestednr = WikiLinks.shared.ExtractLinkToNumber(url: wikiurl) else { return nil }
		guard let load = webView.request?.mainDocumentURL?.absoluteString else { return wikidefault }
		guard let loadednr = WikiLinks.shared.ExtractLinkToNumber(url: load) else { return wikidefault }
		if requestednr != loadednr { return wikidefault }
		return nil
	}
	private func CheckRedirecNotFound(webView : UIWebView) -> String? {
		guard let html = webView.stringByEvaluatingJavaScript(from: "document.body.innerHTML") else { return nil }
		if html.contains("Wikipedia does not have an article") {
			return wikidefault
		}
		return nil
	}
	func webViewDidFinishLoad(_ webView: UIWebView)	{
		
		if let redirect = CheckRedirectNr(webView: webView) {
			SetWikiUrl(wiki: redirect)
			return
		}
		if let redirect = CheckRedirecNotFound(webView : webView) {
			SetWikiUrl(wiki: redirect)
			return
		}
		let scrollPoint = CGPoint(x: 0, y: 48.0)
		uiweb.scrollView.setContentOffset(scrollPoint, animated: true)//Set false if you doesn't want animation
	}
	
	func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		switch navigationType {
		case .linkClicked:
			// Open links
			guard let url = request.url else { return true }
			if let nr = WikiLinks.shared.ExtractLinkToNumber(url: url.absoluteString) {
				jumper?.Jump(to: nr)
				return false
			}
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
}

