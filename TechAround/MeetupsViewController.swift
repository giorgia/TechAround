//
//  MeetupsViewController.swift
//  TechAround
//
//  Created by Giorgia Marenda on 11/6/15.
//  Copyright © 2015 Giorgia Marenda. All rights reserved.
//

import UIKit

class MeetupsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if MeetupAPI.authNeeded() {
            performSegueWithIdentifier("authSegue", sender: self)
        } else {
            reloadData()
        }
    }
    
    func reloadData() {
        MeetupAPI.categories { (categories, error) -> Void in
            print(error)

            let filteredCat = categories?.filter { return $0.shortName == "Tech"}
            if let techCat = filteredCat?.first {
                MeetupAPI.openEvents(0.0, lon: 0.0, categoryId: techCat.id!, complention: { (events, error) -> Void in
                   print(events?.first)
                })
            }
        }
    }
    
}
