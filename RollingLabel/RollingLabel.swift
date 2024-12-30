//
//  RollingLabel.swift
//  RollingLabel
//
//  Created by Woody Kwon on 12/30/24.
//

import Foundation
import UIKit

public final class RollingLabel: UIView {
    private var cachedText: String = ""
    private var scrollLayers: [CAScrollLayer] = []
    private var configuration: RollingConfiguration!
    
    public override var intrinsicContentSize: CGSize {
        let totalWidth = scrollLayers.map(\.frame.width).reduce(0, +)
        let maxHeight = scrollLayers.map(\.frame.height).max() ?? .zero
        return CGSize(width: totalWidth, height: maxHeight)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // top, bottom gradient effect
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.white.cgColor,
            UIColor.white.cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0.0, 0.2, 0.8, 1.0]
        
        self.layer.mask = gradientLayer
    }
    
    public init(frame: CGRect = .zero, font: UIFont, color: UIColor, style: Style) {
        super.init(frame: frame)
        self.setConfiguration(font: font, color: color, style: style)
        
        self.backgroundColor = .white
    }
    
    private func setConfiguration(font: UIFont, color: UIColor, style: Style) {
        switch style {
        case .autoResize:
            self.configuration = AutoResizeRollingConfiguration(
                font: font,
                textColor: color,
                completion: { [weak self] in
                    self?.invalidateIntrinsicContentSize()
                })
        case .fixed:
            self.configuration = FixedRollingConfiguration(font: font, textColor: color)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - public
extension RollingLabel {
    public func setText(_ text: String) {
        if cachedText == text { return }
        
        let _cachedText = cachedText
        cachedText = text
        
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let scrollLayers = configuration.layers(for: text, cachedText: _cachedText)
        self.scrollLayers = scrollLayers
        self.invalidateIntrinsicContentSize()
        scrollLayers.forEach { self.layer.addSublayer($0) }
        
        let number = text.mapToNumber
        let cachedNumber = _cachedText.mapToNumber
        
        if _cachedText.isEmpty, number == 0 {
            return
        }
        
        configuration.animate(layers: scrollLayers, text: text, ascending: number > cachedNumber)
    }
}

fileprivate extension String {
    var mapToNumber: UInt {
        let str = self.filter { $0.isNumber }
        return UInt(str, radix: 10) ?? UInt.min
    }
}

extension RollingLabel {
    public enum Style {
        case autoResize
        case fixed
    }
}
