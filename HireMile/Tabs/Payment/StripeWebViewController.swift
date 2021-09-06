//
//  DriverStripeWebUIViewController.swift
//  deliverend-driver-app
//
//  Created by Admin on 10/16/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import WebKit


class StripeWebViewController: UIViewController {
    @IBOutlet weak var objWebView: WKWebView!
    var webUrl = ""
    open var doneCompletion: (() -> ())?
    open var cancelCompletion: (() -> ())?
    @IBOutlet weak var objActivityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: webUrl) else {
            return
        }
        let urlRequest = URLRequest(url: url)
        objWebView.navigationDelegate = self
        objWebView.load(urlRequest)
        //objWebView.scrollView.contentInset = UIEdgeInsets.zero
        //objWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never;
        
    }
        
        @IBAction func didTapOnDoneButton(_ sender: UIButton) {
            if self.objActivityIndicator.isAnimating {
                self.simpleAlert(title: "", message: "Please Wait until processing complete!!")
                return
            }
            self.navigationController?.popViewController(animated: true)
            self.doneCompletion!()
        }
        
        @IBAction func didTapOnCancelButton(_ sender: UIButton) {
            self.navigationController?.popViewController(animated: true)
            self.cancelCompletion!()
        }
    }
    
    extension StripeWebViewController: WKNavigationDelegate {
        func getQueryStringParameter(url: String, param: String) -> String? {
            guard let url = URLComponents(string: url) else { return nil }
            return url.queryItems?.first(where: { $0.name == param })?.value
        }
        
        private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
            objActivityIndicator.stopAnimating()
        }
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            objActivityIndicator.startAnimating()
        }
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            objActivityIndicator.stopAnimating()
            debugPrint(webView.url)
            if let url = webView.url?.absoluteString {
                debugPrint(url)
                if let authorizationCode = getQueryStringParameter(url: url, param: "code") {
                    self.objActivityIndicator.startAnimating()
//                    DAFirebaseFunctionsManager.sharedInstance.stripeGetAccessToken(authorizationCode: authorizationCode) { (updated) in
//                        self.objActivityIndicator.stopAnimating()
//                    }
                }
            }
        }
}
