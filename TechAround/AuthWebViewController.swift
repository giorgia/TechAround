//
//  AuthWebViewController.swift
//  TechAround
//
//  Created by Giorgia Marenda on 11/9/15.
//  Copyright © 2015 Giorgia Marenda. All rights reserved.
//

import UIKit

class AuthWebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(Router.Authorize().URLRequest)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(request.URL!)
        
        if let URL = request.URL where URL.host == "giorgiamarenda.com" {
            authenticateUser(URL)
            return false
        }
        return true
    }
    
    func authenticateUser(URL: NSURL) {
        if let code = getQueryStringParameter(URL.absoluteString, param: "code"){
            MeetupAPI.authenticate(code, complention: { (error) -> Void in
                if let _ = error {
                    NSURLCache.sharedURLCache().removeAllCachedResponses()
                    self.webView.loadRequest(Router.Authorize().URLRequest)
                } else {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
        else if let error = getQueryStringParameter(URL.absoluteString, param: "error") {
            print(error)
            NSURLCache.sharedURLCache().removeAllCachedResponses()
            webView.loadRequest(Router.Authorize().URLRequest)
        }
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard
            let urlComponents = NSURLComponents(string: url),
            let queryItems = urlComponents.queryItems,
            let value = queryItems.filter({ (item) in item.name == param }).first
            else { return nil }
    
        return value.value
    }
}
