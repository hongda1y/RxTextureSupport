//
//  ASButtonNode+Rx.swift
//  
//
//  Created by Dimas Prabowo on 05/06/23.

import AsyncDisplayKit
import PINRemoteImage
import RxCocoa
import RxSwift
import UIKit

/// Reference `UIControl.State`:
/// public static var normal: UIControl.State { get }
/// public static var highlighted: UIControl.State { get } // used when UIControl isHighlighted is set
/// public static var disabled: UIControl.State { get }
/// public static var selected: UIControl.State { get } // flag usable by app (see below)
 
extension Reactive where Base: ASButtonNode {
    /// Binder for attributed string on all `UIControl.State`.
    public var attributedText: ASBinder<NSAttributedString?> {
        return ASBinder(self.base) { node, attributedString in
            self.setAllAttributedTitle(node, attributedString)
        }
    }
    
    /// Apply attributed string on selected `UIControl.State`.
    ///
    /// - Parameters:
    ///     - controlState: Filter for observed `UIControl.State` types.
    public func attributedText(_ controlState: UIControl.State) -> ASBinder<NSAttributedString?> {
        return ASBinder(self.base) { node, attributedString in
            node.setAttributedTitle(attributedString, for: controlState)
        }
    }
    
    /// Apply text with attributes on selected `UIControl.State`.
    ///
    /// - Parameters:
    ///     - attributes: List of attributes for text.
    ///     - controlState: Filter for observed `UIControl.State` types.
    public func attributedText(
        _ attributes: [NSAttributedString.Key: Any]?,
        for controlState: UIControl.State
    ) -> ASBinder<String?> {
        return ASBinder(self.base) { node, text in
            guard let text = text else {
                self.setAllAttributedTitle(node, nil)
                return
            }
            
            let attributedString = NSAttributedString(string: text, attributes: attributes)
            node.setAttributedTitle(attributedString, for: controlState)
        }
    }
    
    /// Apply text with `ASControlStateType`.
    ///
    /// - Parameters:
    ///     - applyList: List of `ASControlStateType` for filtering observed types.
    public func attributedText(applyList: [ASControlStateType]) -> ASBinder<String?> {
        return ASBinder(self.base) { node, text in
            guard let text = text else {
                applyList.forEach { apply in
                    node.setAttributedTitle(nil, for: apply.state)
                }
                return
            }
            
            applyList.forEach { apply in
                let attributedString = NSAttributedString(string: text, attributes: apply.attributes)
                node.setAttributedTitle(attributedString, for: apply.state)
            }
        }
    }
    
    /// Apply text with attributes on all `UIControl.State`.
    ///
    /// - Parameters:
    ///     - attributes: List of attributes for text.
    public func text(_ attributes: [NSAttributedString.Key: Any]?) -> ASBinder<String?> {
        return ASBinder(self.base) { node, text in
            guard let text = text else {
                self.setAllAttributedTitle(node, nil)
                return
            }
            
            let attributedString = NSAttributedString(string: text, attributes: attributes)
            self.setAllAttributedTitle(node, attributedString)
        }
    }
    
    /// Binder of image for `ASButtonNode`.
    public var image: ASBinder<UIImage?> {
        return ASBinder(self.base) { node, image in
            self.setAllImage(node, image)
        }
    }
    
    /// Binder for image with `ASControlStateType`.
    ///
    /// - Parameters:
    ///     - applyList: List of `ASControlStateType` for filtering observed types.
    public func image(applyList: [ASControlStateType]) -> ASBinder<UIImage?> {
        return ASBinder(self.base) { node, image in
            guard let image = image  else {
                applyList.forEach { apply in
                    node.setImage(nil, for: apply.state)
                }
                return
            }
            
            applyList.forEach { apply in
                node.setImage(apply.image ?? image, for: apply.state)
            }
        }
    }
    
    /// Binder of background image for `ASButtonNode`.
    public var backgroundImage: ASBinder<UIImage?> {
        return ASBinder(self.base) { node, image in
            self.setAllBackgroundImage(node, image)
        }
    }
    
    /// Binder for background image with `ASControlStateType`.
    ///
    /// - Parameters:
    ///     - applyList: List of `ASControlStateType` for filtering observed types.
    public func backgroundImage(applyList: [ASControlStateType]) -> ASBinder<UIImage?> {
        return ASBinder(self.base) { node, image in
            guard let image = image  else {
                applyList.forEach { apply in
                    node.setBackgroundImage(nil, for: apply.state)
                }
                return
            }
            
            applyList.forEach { apply in
                node.setBackgroundImage(apply.image ?? image, for: apply.state)
            }
        }
    }
    
    /// States of observed `ASButtonNode`.
    public enum ASControlStateType {
        case normal(Any?)
        case highlighted(Any?)
        case selected(Any?)
        case disabled(Any?)
        
        /// Wrapper for `ASControlStateType` from `UIControl.State`.
        public var state: UIControl.State {
            switch self {
            case .normal:
                return .normal
            case .highlighted:
                return .highlighted
            case .selected:
                return .selected
            case .disabled:
                return .disabled
            }
        }
        
        /// Get `URL` from associate value. If associate value contains `URL`.
        public var url: URL? {
            switch self {
            case let .normal(value):
                return value as? URL
            case let .highlighted(value):
                return value as? URL
            case let .selected(value):
                return value as? URL
            case let .disabled(value):
                return value as? URL
            }
        }
        
        /// Get `UIImage` from associate value. If associate value contains `UIImage`.
        public var image: UIImage? {
            switch self {
            case let .normal(value):
                return value as? UIImage
            case let .highlighted(value):
                return value as? UIImage
            case let .selected(value):
                return value as? UIImage
            case let .disabled(value):
                return value as? UIImage
            }
        }
        
        /// Get text attributes from associate value. If associate value contains text attributes.
        public var attributes: [NSAttributedString.Key: Any]? {
            switch self {
            case let .normal(value):
                return value as? [NSAttributedString.Key: Any]
            case let .highlighted(value):
                return value as? [NSAttributedString.Key: Any]
            case let .selected(value):
                return value as? [NSAttributedString.Key: Any]
            case let .disabled(value):
                return value as? [NSAttributedString.Key: Any]
            }
        }
    }
    
    private func setAllAttributedTitle(
        _ node: ASButtonNode,
        _ attributedString: NSAttributedString?
    ) {
        node.setAttributedTitle(attributedString, for: .normal)
        node.setAttributedTitle(attributedString, for: .highlighted)
        node.setAttributedTitle(attributedString, for: .selected)
        node.setAttributedTitle(attributedString, for: .disabled)
    }
    
    private func setAllImage(
        _ node: ASButtonNode,
        _ image: UIImage?
    ) {
        node.setImage(image, for: .normal)
        node.setImage(image, for: .highlighted)
        node.setImage(image, for: .selected)
        node.setImage(image, for: .disabled)
    }
    
    private func setAllBackgroundImage(
        _ node: ASButtonNode,
        _ image: UIImage?
    ) {
        node.setBackgroundImage(image, for: .normal)
        node.setBackgroundImage(image, for: .highlighted)
        node.setBackgroundImage(image, for: .selected)
        node.setBackgroundImage(image, for: .disabled)
    }
}
