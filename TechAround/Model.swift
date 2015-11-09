//
//  Model.swift
//  TechAround
//
//  Created by Giorgia Marenda on 11/6/15.
//  Copyright © 2015 Giorgia Marenda. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

class Event: Mappable  {
    
    var id:             String?
    var urlname:        String?
    var name:           String?
    var distance:       Double?
    var utcOffset:      Int?
    var desc:           String?
    var eventUrl:       String?
    var time:           Int?
    var status:         String?
    var yesRsvpCount:   Int?
    var venue:          Venue?
    var group:          Group?
    
    func mapping(map: Map) {
        id              <- map["id"]
        urlname         <- map["urlname"]
        name            <- map["name"]
        distance        <- map["distance"]
        utcOffset       <- map["utc_offset"]
        desc            <- map["description"]
        eventUrl        <- map["event_url"]
        time            <- map["time"]
        status          <- map["status"]
        yesRsvpCount    <- map["yes_rsvp_count"]
        venue           <- map["venue"]
        group           <- map["group"]
    }
    
    required init?(_ map: Map){}
}

class Venue: Mappable  {
    
    var id:             String?
    var name:           String?
    var address1:       String?
    var lat:            Double?
    var lon:            Double?
    var zip:            String?
    var country:        String?
    var city:           String?
    var state:          String?
    var repinned:       Bool?
    
    func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        address1    <- map["address_1"]
        lat         <- map["lat"]
        lon         <- map["lat"]
        zip         <- map["zip"]
        country     <- map["country"]
        city        <- map["city"]
        state       <- map["state"]
        repinned    <- map["repinned"]
    }
    
    required init?(_ map: Map){}
}

class Group: Mappable  {
    
    var id:             String?
    var name:           String?
    var urlname:        String?
    var groupLon:       Double?
    var groupLat:       Double?
    var who:            String?
    
    func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        urlname     <- map["urlname"]
        groupLon    <- map["group_lon"]
        groupLat    <- map["group_lat"]
        who         <- map["who"]
    }
    
    required init?(_ map: Map){}
}

class Category: Mappable {
    
    var id:             Int?
    var name:           String?
    var sortName:       String?
    var shortName:      String?

    func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        sortName    <- map["sort_name"]
        shortName   <- map["shortname"]
    }
    
    required init?(_ map: Map){}
}
    