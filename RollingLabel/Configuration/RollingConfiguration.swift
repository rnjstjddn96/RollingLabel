//
//  RollingConfiguration.swift
//  RollingLabel
//
//  Created by Woody Kwon on 12/30/24.
//

import UIKit

protocol RollingConfiguration {
    var font: UIFont { get }
    var textColor: UIColor { get }
    var duration: Double { get }
    var durationOffset: Double { get }
    
    func layers(for text: String, cachedText: String) -> [CAScrollLayer]
    func animate(layers: [CAScrollLayer], text: String, ascending: Bool)
}
