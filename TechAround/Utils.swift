//
//  Utils.swift
//  TechAround
//
//  Created by Giorgia Marenda on 11/6/15.
//  Copyright © 2015 Giorgia Marenda. All rights reserved.
//

import Foundation

/**
 Merge two dictionaries.
 Note: If a key already exists on the first dictionary, the value will be overwrite with the value on the second dictionary.
 */
func + <K, V> (left: [K : V], right: [K : V]) -> [K : V] {
    var sum = left
    for (k, v) in right {
        sum.updateValue(v, forKey: k)
    }
    return sum
}