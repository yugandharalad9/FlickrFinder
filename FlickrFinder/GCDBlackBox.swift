//
//  GCDBlackBox.swift
//  FlickrFinder
//
//  Created by Yugandhara Lad More on 12/14/17.
//  Copyright © 2017 Yugandhara Lad. All rights reserved.
//

import Foundation
func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
