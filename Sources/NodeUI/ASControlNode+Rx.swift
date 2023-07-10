//
//  ASControlNode+Rx.swift
//  
//
//  Created by Dimas Prabowo on 05/06/23.

import AsyncDisplayKit
import RxCocoa
import RxSwift

extension Reactive where Base: ASControlNode {
    /// Reactive wrapper for target action pattern.
    ///
    /// - Parameters:
    ///     - controlEvents: Filter for observed `ASControlNodeEvent` types.
    public func controlEvent(_ controlEvents: ASControlNodeEvent) -> ControlEvent<Base> {
        let source: Observable<Base> = Observable
            .create { [weak control = self.base] observer in
                MainScheduler.ensureExecutingOnScheduler()
                
                guard let control = control else {
                    observer.on(.completed)
                    return Disposables.create()
                }
                
                let observer = ASControlTarget(control, controlEvents) { node in
                    observer.on(.next(node))
                }
                
                return observer
            }
            .take(until: deallocated)
        return ControlEvent(events: source)
    }
    
    /// Creates a `ControlProperty` that is triggered by target/action pattern value updates.
    ///
    /// - parameter controlEvents: ASControlNodeEvents that trigger value update sequence elements.
    /// - parameter getter: Property value getter.
    /// - parameter setter: Property value setter.
    public func controlProperty<T>(
        editingEvents: ASControlNodeEvent,
        getter: @escaping (Base) -> T,
        setter: @escaping (Base, T) -> ()
    ) -> ControlProperty<T> {
        let source: Observable<T> = Observable.create { [weak weakControl = base] observer in
            guard let control = weakControl else {
                observer.on(.completed)
                return Disposables.create()
            }

            observer.on(.next(getter(control)))

            let controlTarget = ASControlTarget(control, editingEvents) { _ in
                if let control = weakControl {
                    observer.on(.next(getter(control)))
                }
            }

            return Disposables.create(with: controlTarget.dispose)
        }
        .take(until: deallocated)

        let bindingObserver = ASBinder(base, binding: setter)

        return ControlProperty<T>(values: source, valueSink: bindingObserver)
    }
    
    /// Driver for tap action of `ASControlNode` object.
    public var tap: Driver<Void> {
        return self.controlEvent(.touchUpInside)
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    }
    
    /// Tap action that emit to relay.
    public func tap(to relay: PublishRelay<()>) -> Disposable {
        return self.controlEvent(.touchUpInside)
            .mapToVoid()
            .asSignalrOnErrorJustComplete()
            .emit(to: relay)
    }
    
    /// Binder of `Bool` for isHidden property of `ASControlNode`.
    public var isHidden: ASBinder<Bool> {
        return ASBinder(self.base) { node, isHidden in
            node.isHidden = isHidden
        }
    }
    
    /// Binder of `Bool` for isEnabled property of `ASControlNode`.
    public var isEnabled: ASBinder<Bool> {
        return ASBinder(self.base) { node, isEnabled in
            node.isEnabled = isEnabled
        }
    }
    
    /// Reactive wrapper for `Bool` of isHighlighted property.
    public var isHighlighted: ControlProperty<Bool> {
        return self.controlProperty(
            editingEvents: [.touchDown, .touchUpInside, .touchCancel],
            getter: { control in
                control.isHighlighted
            },
            setter: { control, isHighlighted in
                control.isHighlighted = isHighlighted
            }
        )
    }
    
    /// Binder of `Bool` for isSelected property of `ASControlNode`.
    public var isSelected: ASBinder<Bool> {
        return ASBinder(self.base) { node, isSelected in
            node.isSelected = isSelected
        }
    }
}
