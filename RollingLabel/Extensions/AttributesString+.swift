//
//  AttributesString+.swift
//  RollingLabel
//
//  Created by Woody Kwon on 12/30/24.
//

import UIKit

extension NSAttributedString {
    public func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            context: nil
        )

        return ceil(boundingBox.height)
    }

    public func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            context: nil
        )

        return ceil(boundingBox.width)
    }
}
