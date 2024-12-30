//
//  RollingConfiguration+.swift
//  RollingLabel
//
//  Created by Woody Kwon on 12/30/24.
//

import Foundation
import UIKit

extension RollingConfiguration {
    func attributedString(_ string: String) -> NSAttributedString {
        let text = NSMutableAttributedString()
        let att: [NSAttributedString.Key: Any] = [.font: self.font, .foregroundColor: self.textColor]
        text.append(NSAttributedString(string: string, attributes: att))
        
        return text
    }
    
    func appendScrollContents(for text: String, toLayer scrollLayer: CAScrollLayer, animated: Bool) {
        var textsForScroll: [String] = []
        if let number = Int(text), animated {
            for i in 0...9 {
                textsForScroll.append(String((number + i) % 10))
            }
        }
        
        textsForScroll.append(text)
        
        var y: CGFloat = 0
        for text in textsForScroll {
            let textLayer: CATextLayer = .init()
            textLayer.string = self.attributedString(text)
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.frame = CGRect(
                x: 0,
                y: y,
                width: scrollLayer.frame.width,
                height: scrollLayer.frame.height
            )
            
            scrollLayer.addSublayer(textLayer)
            
            y = textLayer.frame.maxY
        }
    }
    
    func scrollLayerFor(string: String, origin: CGPoint) -> CAScrollLayer {
        let scrollLayer: CAScrollLayer = .init()
        let attributedString: NSAttributedString = attributedString(string)
        let width = attributedString.width(withConstrainedHeight: .greatestFiniteMagnitude)
        let height = attributedString.height(withConstrainedWidth: .greatestFiniteMagnitude)
        
        scrollLayer.frame = .init(origin: origin, size: .init(width: width, height: height))
        
        return scrollLayer
    }
}

extension CollectionDifference.Change {
    var offset: Int {
        switch self {
        case let .insert(offset, _, _):
            return offset
        case let .remove(offset, _, _):
            return offset
        }
    }
}
