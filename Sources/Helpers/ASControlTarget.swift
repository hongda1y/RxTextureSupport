//
//  ASControlTarget.swift
//  
//
//  Created by Dimas Prabowo on 05/06/23.

import AsyncDisplayKit
import RxCocoa
import RxSwift

internal final class ASControlTarget<Control: ASControlNode>: _RXKVOObserver, Disposable {
    typealias CallBack = (Control) -> ()
    
    internal let selector = #selector(eventHandler(_:))
    
    internal weak var controlNode: Control?
    
    internal var callback: CallBack?
    
    internal init(
        _ controlNode: Control,
        _ eventType: ASControlNodeEvent,
        callback: @escaping CallBack
    ) {
        self.controlNode = controlNode
        self.callback = callback
        super.init()
        controlNode.addTarget(self, action: selector, forControlEvents: eventType)
        if method(for: selector) == nil {
            fatalError("Can't find method")
        }
    }
    
    @objc internal func eventHandler(_ sender: UIGestureRecognizer) {
        if let callback = callback, let controlNode = controlNode {
            callback(controlNode)
        }
    }
    
    override internal func dispose() {
        super.dispose()
        controlNode?.removeTarget(self, action: selector, forControlEvents: .allEvents)
        self.callback = nil
    }
}
