//
//  RxASEditableTextNode.swift
//  
//
//  Created by Dimas Agung Prabowo on 27/06/23.
//

import AsyncDisplayKit
import RxCocoa
import RxSwift

extension ASEditableTextNode: HasDelegate {
    public typealias Delegate = ASEditableTextNodeDelegate
}

open class RxASEditableTextNodeDelegateProxy: DelegateProxy<ASEditableTextNode, ASEditableTextNodeDelegate>, DelegateProxyType, ASEditableTextNodeDelegate {
    public weak private(set) var editableTextNode: ASEditableTextNode?
    
    public init(editableTextNode: ASEditableTextNode) {
        self.editableTextNode = editableTextNode
        super.init(
            parentObject: editableTextNode,
            delegateProxy: RxASEditableTextNodeDelegateProxy.self
        )
    }
    
    public static func registerKnownImplementations() {
        self.register { RxASEditableTextNodeDelegateProxy(editableTextNode: $0) }
    }
}
