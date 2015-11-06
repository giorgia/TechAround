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
    
    case Categories()
    case OpenEvents(Double, Double, Int)
    
    var method: Alamofire.Method {
        switch self {
        case .Categories, .OpenEvents:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .Categories:
            // Rif. http://www.meetup.com/meetup_api/docs/2/categories/
            return "/2/categories"
        case .OpenEvents:
            // Rif. http://www.meetup.com/meetup_api/docs/2/open_events/
            return "/2/open_events"
        }
    }
    
    var parameters: [String: AnyObject] {
        
        var apiKey: [String : AnyObject] {
            return ["sig" : "991a941178a8c865450c172dbe643bef1c38f0a7"]
        }
        
        switch self {
        case .OpenEvents(let lat, let lon, let category):
            return ["lat": lat, "lon": lon, "category": category] + apiKey
        default:
            return apiKey
        }
    }
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSMutableURLRequest {
        let URL                         = NSURL(string: Router.baseURLString)!
        let mutableURLRequest           = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod    = method.rawValue
        
        return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
    }
}


class MeetupAPI {
    /**
     Performs the GET request for Open Events from API
     */
    class func openEvents(lat: Double, lon: Double, categoryId: Int, complention: ([Event]?, ErrorType?) -> Void) {
        Alamofire.request(Router.OpenEvents(lat, lon, categoryId))
            .responseArray("results", completionHandler: complention)
    }
}