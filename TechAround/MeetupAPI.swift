//
//  MeetupAPI.swift
//  TechAround
//
//  Created by Giorgia Marenda on 11/6/15.
//  Copyright © 2015 Giorgia Marenda. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import Foundation

/**
 Convinience way to contruct the URLRequest
 */
enum Router: URLRequestConvertible {
    
    static let baseURLString = "https://api.meetup.com"
    static let authURLString = "https://secure.meetup.com"
    static var OAuthToken: String?

    case Authorize()
    case AccessToken(String)
    case Categories()
    case OpenEvents(Double, Double, Int)
    
    var method: Alamofire.Method {
        switch self {
        case .Authorize, .AccessToken:
            return .POST
        case .Categories, .OpenEvents:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .Authorize:
            return "/oauth2/authorize"
        case .AccessToken:
            return "/oauth2/access"
        case .Categories:
            // Rif. http://www.meetup.com/meetup_api/docs/2/categories/
            return "/2/categories"
        case .OpenEvents:
            // Rif. http://www.meetup.com/meetup_api/docs/2/open_events/
            return "/2/open_events"
        }
    }
    
    var parameters: [String: AnyObject] {
        
        switch self {
        case .Authorize():
            return ["client_id":        "lr0g15hj4229i1h9k28rt4i95b",
                    "response_type":    "code",
                    "redirect_uri":     "http://giorgiamarenda.com",
                    "set_mobile":       "on"]
        case .AccessToken(let code):
            return ["client_id":        "lr0g15hj4229i1h9k28rt4i95b",
                    "client_secret":    "n6spp503als5mgge7k93d1ajaa",
                    "grant_type":       "authorization_code",
                    "redirect_uri":     "http://giorgiamarenda.com",
                    "code":             code]
        case .OpenEvents(let lat, let lon, let category):
            return ["lat": lat, "lon": lon, "category": category]
        default:
            return [:]
        }
    }
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSMutableURLRequest {
        var URL = NSURL()
        switch self {
        case .Authorize, .AccessToken:
            URL = NSURL(string: Router.authURLString)!
        default:
            URL = NSURL(string: Router.baseURLString)!
        }
        
        let mutableURLRequest           = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod    = method.rawValue
        
        if let token = Router.OAuthToken {
            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
    }
}


class MeetupAPI {
    
    class func authNeeded() -> Bool {
        guard let _ = Router.OAuthToken
            else { return true }
        return false
    }
    
    /**
     Performs the POST request for Access Token
     */
    class func authenticate(code: String, complention: (ErrorType?) -> Void) {
        Alamofire.request(Router.AccessToken(code))
            .responseJSON { (response) -> Void in
                switch response.result {
                case .Success(let value):
                    if let token = value["access_token"] as? String {
                        Router.OAuthToken = token
                        complention(nil)
                    }
                case .Failure(let error):
                    complention(error)
                }
        }
    }
    
    /**
     Performs the GET request for Open Events from API
     */
    class func openEvents(lat: Double, lon: Double, categoryId: Int, complention: ([Event]?, ErrorType?) -> Void) {
        Alamofire.request(Router.OpenEvents(lat, lon, categoryId))
            .responseArray("results", completionHandler: complention)
    }
    
    /**
     Performs the GET request for Categories from API
     */
    class func categories(complention: ([Category]?, ErrorType?) -> Void) {
        Alamofire.request(Router.Categories())
            .responseArray("results", completionHandler: complention)
    }
}