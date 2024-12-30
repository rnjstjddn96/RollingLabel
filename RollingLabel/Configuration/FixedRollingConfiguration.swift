//
//  FixedRollingConfiguration.swift
//  RollingLabel
//
//  Created by Woody Kwon on 12/30/24.
//

import Foundation
import UIKit

struct FixedRollingConfiguration: RollingConfiguration {
    let font: UIFont
    let textColor: UIColor
    let duration: Double
    let durationOffset: Double
    
    init(
        font: UIFont,
        textColor: UIColor,
        duration: Double = 0.3,
        durationOffset: Double = 0.1
    ) {
        self.font = font
        self.textColor = textColor
        self.duration = duration
        self.durationOffset = durationOffset
    }
    
    func layers(for text: String, cachedText: String) -> [CAScrollLayer] {
        let stringArray = text.map { String($0) }
        let changes = text.difference(from: cachedText)
        let unitChanged: Bool = text.count != cachedText.count
        
        return stringArray.enumerated().reduce([]) { layers, value in
            let (index, text) = value
            let digitChanged: Bool = index >= changes.removals.first?.offset ?? 0
            let animated: Bool = if unitChanged { true } else { digitChanged }
            
            let x: CGFloat = layers.last?.frame.maxX ?? .zero
            let layer = scrollLayerFor(string: text, origin: .init(x: x, y: 0))
            
            appendScrollContents(for: text, toLayer: layer, animated: animated)
            
            return layers + [layer]
        }
    }
    
    func animate(layers: [CAScrollLayer], text: String, ascending: Bool) {
        var offset: CFTimeInterval = 0.0
        
        zip(layers, text).forEach { scrollLayer, text in
            let maxY = scrollLayer.sublayers?.last?.frame.origin.y ?? 0.0
            let animation = CABasicAnimation(keyPath: "sublayerTransform.translation.y")
            
            animation.duration = duration + offset
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            if ascending {
                animation.fromValue = maxY
                animation.toValue = 0
            } else {
                animation.fromValue = 0
                animation.toValue = maxY
            }
            
            scrollLayer.scrollMode = .vertically
            scrollLayer.add(animation, forKey: nil)
            scrollLayer.scroll(to: CGPoint(x: 0, y: maxY))
            offset += durationOffset
        }
    }
}

