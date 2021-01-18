//
//  GCDBlackBox.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 3/2/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
  DispatchQueue.main.async {
    updates()
  }
}

