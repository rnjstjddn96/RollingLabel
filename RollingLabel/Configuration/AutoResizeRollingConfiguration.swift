//
//  AutoResizeRollingConfiguration.swift
//  RollingLabel
//
//  Created by Woody Kwon on 12/30/24.
//

import Foundation
import UIKit

struct AutoResizeRollingConfiguration: RollingConfiguration {
    let font: UIFont
    let textColor: UIColor
    let duration: Double
    let durationOffset: Double
    private let completion: (() -> Void)?
    
    init(
        font: UIFont,
        textColor: UIColor,
        duration: Double = 0.3,
        durationOffset: Double = 0.1,
        completion: (() -> Void)?
    ) {
        self.font = font
        self.textColor = textColor
        self.duration = duration
        self.durationOffset = durationOffset
        self.completion = completion
    }
    
    func layers(for text: String, cachedText: String) -> [CAScrollLayer] {
        let stringArray = text.map { String($0) }
        let changes = text.difference(from: cachedText)
        let unitChanged = text.count != cachedText.count
        
        return stringArray.enumerated().reduce([]) { layers, value in
            let (index, text) = value
            let digitChanged: Bool = index >= changes.removals.first?.offset ?? 0
            
            let animated: Bool = if unitChanged { true } else { digitChanged }
            let string: String = if animated && text.isNumber { "0" } else { text }

            let x: CGFloat = layers.last?.frame.maxX ?? .zero
            let layer = scrollLayerFor(string: string, origin: .init(x: x, y: 0))
            
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
            
            animation.delegate = AnimationCompletionDelegate(layer: scrollLayer) { layer in
                let x: CGFloat
                if let index = layers.firstIndex(of: layer), let prevLayer = layers[safe: index - 1] {
                    x = prevLayer.frame.maxX
                } else {
                    x = .zero
                }
                
                let string = self.attributedString(String(text))
                let width: CGFloat = string.width(withConstrainedHeight: .greatestFiniteMagnitude)
                let height: CGFloat = string.height(withConstrainedWidth: .greatestFiniteMagnitude)
                scrollLayer.frame = .init(x: x, y: 0, width: width, height: height)
                
                if layer == layers.last {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        self.completion?()
                    }
                }
            }
            
            scrollLayer.scrollMode = .vertically
            scrollLayer.add(animation, forKey: nil)
            scrollLayer.scroll(to: CGPoint(x: 0, y: maxY))
            offset += durationOffset
        }
    }
}

private final class AnimationCompletionDelegate: NSObject, CAAnimationDelegate {
    private let completion: (CAScrollLayer) -> Void
    private let layer: CAScrollLayer
    
    init(layer: CAScrollLayer, completion: @escaping (CAScrollLayer) -> Void) {
        self.layer = layer
        self.completion = completion
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag { completion(layer) }
    }
}

fileprivate extension String {
    var isNumber: Bool {
        Int(self) != nil
    }
}
