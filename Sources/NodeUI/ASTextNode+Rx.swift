//
//  ASTextNode+Rx.swift
//
//
//  Created by Dimas Prabowo on 05/06/23.

import AsyncDisplayKit
import RxSwift
import RxCocoa

extension Reactive where Base: ASTextNode {
    /// Binder of `NSAttributedString` for attributedText property of `ASTextNode`.
    public var attributedText: ASBinder<NSAttributedString?> {
        return ASBinder(self.base) { node, attributedText in
            node.attributedText = attributedText
        }
    }
    
    /// Apply text with attributes.
    ///
    /// - Parameters:
    ///     - attributes: List of attributes for text.
    public func text(_ attributes: [NSAttributedString.Key: Any]?) -> ASBinder<String?> {
        return ASBinder(self.base) { node, text in
            guard let text = text else {
                node.attributedText = nil
                return
            }
            
            node.attributedText = NSAttributedString(string: text, attributes: attributes)
        }
    }
}
