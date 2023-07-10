//
//  ASDisplayNode+Rx.swift
//  
//
//  Created by Dimas Prabowo on 05/06/23.

import AsyncDisplayKit
import RxCocoa
import RxSwift

// MARK: - Dimension

extension Reactive where Base: ASDisplayNode {
    /// Binder of `ASDimension` for width property of `ASDisplayNode`.
    public var width: ASBinder<ASDimension> {
        return ASBinder(self.base) { node, width in
            node.style.width = width
        }
    }
    
    /// Binder of `ASDimension` for minWidth property of `ASDisplayNode`.
    public var minWidth: ASBinder<ASDimension> {
        return ASBinder(self.base) { node, minWidth in
            node.style.minWidth = minWidth
        }
    }
    
    /// Binder of `ASDimension` for maxWidth property of `ASDisplayNode`.
    public var maxWidth: ASBinder<ASDimension> {
        return ASBinder(self.base) { node, maxWidth in
            node.style.maxWidth = maxWidth
        }
    }
    
    /// Binder of `ASDimension` for height property of `ASDisplayNode`.
    public var height: ASBinder<ASDimension> {
        return ASBinder(self.base) { node, height in
            node.style.height = height
        }
    }
    
    /// Binder of `ASDimension` for minHeight property of `ASDisplayNode`.
    public var minHeight: ASBinder<ASDimension> {
        return ASBinder(self.base) { node, minHeight in
            node.style.minHeight = minHeight
        }
    }
    
    /// Binder of `ASDimension` for maxHeight property of `ASDisplayNode`.
    public var maxHeight: ASBinder<ASDimension> {
        return ASBinder(self.base) { node, maxHeight in
            node.style.maxHeight = maxHeight
        }
    }
    
    /// Binder of `ASDimension` for preferredSize property of `ASDisplayNode`.
    public var preferredSize: ASBinder<CGSize> {
        return ASBinder(self.base) { node, preferredSize in
            node.style.preferredSize = preferredSize
        }
    }
    
    /// Binder of `ASDimension` for minSize property of `ASDisplayNode`.
    public var minSize: ASBinder<CGSize> {
        return ASBinder(self.base) { node, minSize in
            node.style.minSize = minSize
        }
    }
    
    /// Binder of `ASDimension` for maxSize property of `ASDisplayNode`.
    public var maxSize: ASBinder<CGSize> {
        return ASBinder(self.base) { node, maxSize in
            node.style.maxSize = maxSize
        }
    }
}

// MARK: - Attributes

extension Reactive where Base: ASDisplayNode {
    /// Binder of `CGFloat` for alpha property of `ASDisplayNode`.
    public var alpha: ASBinder<CGFloat> {
        return ASBinder(self.base) { node, alpha in
            node.alpha = alpha
        }
    }

    /// Binder of `UIColor` for backgroundColor property of `ASDisplayNode`.
    public var backgroundColor: ASBinder<UIColor?> {
        return ASBinder(self.base) { node, backgroundColor in
            node.backgroundColor = backgroundColor
        }
    }
    
    /// Binder of `Bool` for isHidden property of `ASDisplayNode`.
    public var isHidden: ASBinder<Bool> {
        return ASBinder(self.base) { node, isHidden in
            node.isHidden = isHidden
        }
    }
    
    /// Binder of `Bool` for isUserInteractionEnabled property of `ASDisplayNode`.
    public var isUserInteractionEnabled: ASBinder<Bool> {
        return ASBinder(self.base) { node, isUserInteractionEnabled in
            node.isUserInteractionEnabled = isUserInteractionEnabled
        }
    }
    
    /// Binder setNeedsLayout method of `ASDisplayNode`.
    public var setNeedsLayout: Binder<Void> {
        return Binder(self.base) { node, _ in
            node.rxSetNeedsLayout()
        }
    }
}

// MARK: - Lifecycles

extension Reactive where Base: ASDisplayNode {
    /// Reactive wrapper to observe when didLoad is called.
    public var didLoad: Observable<Void> {
        return methodInvoked(#selector(Base.didLoad))
            .map { _ in return }
            .asObservable()
    }
    
    /// Reactive wrapper to observe when didEnterPreloadState is called.
    public var didEnterPreloadState: Observable<Void> {
        return self.methodInvoked(#selector(Base.didEnterPreloadState))
            .map { _ in return }
            .asObservable()
    }
    
    /// Reactive wrapper to observe when didEnterDisplayState is called.
    public var didEnterDisplayState: Observable<Void> {
        return self.methodInvoked(#selector(Base.didEnterDisplayState))
            .map { _ in return }
            .asObservable()
    }
    
    /// Reactive wrapper to observe when didEnterVisibleState is called.
    public var didEnterVisibleState: Observable<Void> {
        return self.methodInvoked(#selector(Base.didEnterVisibleState))
            .map { _ in return }
            .asObservable()
    }
    
    /// Reactive wrapper to observe when didExitVisibleState is called.
    public var didExitVisibleState: Observable<Void> {
        return self.methodInvoked(#selector(Base.didExitVisibleState))
            .map { _ in return }
            .asObservable()
    }
    
    /// Reactive wrapper to observe when didExitDisplayState is called.
    public var didExitDisplayState: Observable<Void> {
        return self.methodInvoked(#selector(Base.didExitDisplayState))
            .map { _ in return }
            .asObservable()
    }
    
    /// Reactive wrapper to observe when didExitPreloadState is called.
    public var didExitPreloadState: Observable<Void> {
        return self.methodInvoked(#selector(Base.didExitPreloadState))
            .map { _ in return }
            .asObservable()
    }
}

extension ASDisplayNode {
    /// setNeedsLayout with avoid block layout measure passing before node loaded
    /// - important: block layout measure passing from rx.
    /// - returns: void
    public func rxSetNeedsLayout() {
        if self.isNodeLoaded {
            self.setNeedsLayout()
        } else {
            self.layoutIfNeeded()
            self.invalidateCalculatedLayout()
        }
    }
}
