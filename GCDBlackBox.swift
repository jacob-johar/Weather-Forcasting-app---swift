//
//  GCDBlackBox.swift
//  WeatherForcasting
//
//  Created by jacob n johar on 02/01/17.
//  Copyright © 2017 jacob  johar. All rights reserved.
//

//taken from udacity course code

import Foundation

func performUIUpdatesOnMain(updates: @escaping () -> Void)
{
    DispatchQueue.main.async {
        updates()
    }
}

