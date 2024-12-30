//
//  Array+.swift
//  RollingLabel
//
//  Created by Woody Kwon on 12/30/24.
//

import Foundation

extension Array {
    @inlinable subscript (safe index: Index) -> Element? {
      return indices.contains(index) ? self[index] : nil
    }
}
