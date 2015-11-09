//
//  MeetupsViewController.swift
//  TechAround
//
//  Created by Giorgia Marenda on 11/6/15.
//  Copyright © 2015 Giorgia Marenda. All rights reserved.
//

import UIKit
import CoreLocation

class MeetupsViewController: UITableViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight    = 80
        tableView.rowHeight             = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if MeetupAPI.authNeeded() {
            performSegueWithIdentifier("authSegue", sender: self)
        } else {
            fetchUserLocation()
        }
    }
    
    func reloadData(coordinate: CLLocationCoordinate2D) {
        MeetupAPI.categories { (categories, error) -> Void in
            let filteredCat = categories?.filter { return $0.shortName == "Tech"}
            if let techCat = filteredCat?.first {
                MeetupAPI.openEvents(coordinate.latitude, lon: coordinate.longitude, categoryId: techCat.id!, complention: { (events, error) -> Void in
                   print(events?.first?.name)
                    self.events = events!.sort { return $0.distance < $1.distance }
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func fetchUserLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.pausesLocationUpdatesAutomatically = true
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer

            if let location = locationManager.location {
                reloadData(location.coordinate)
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        
        guard
            let cell = tableView.dequeueReusableCellWithIdentifier("cell"),
            let name = event.name,
            let time = event.time,
            let distance = event.distance else { return UITableViewCell() }
      
        let formatter       = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        let date = formatter.stringFromDate(NSDate.fromMilliseconds(time))
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = String(format:"FAR: %.2f miles", distance) + " WHEN: \(date)"
        return cell
    }
}
