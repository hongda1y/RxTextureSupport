//
//  ASObserverType.swift
//  
//
//  Created by Dimas Prabowo on 05/06/23.

import AsyncDisplayKit
import RxCocoa
import RxSwift

public protocol ASObserverType: ObserverType {
    associatedtype Element
    
    func on(_ event: Event<Element>, node: ASDisplayNode?)
    func directlyBinding(_ element: Element?)
}

extension ObservableType {
    public func bind<Observer>(
        to observer: Observer,
        directlyBind: Bool = false,
        setNeedsLayout node: ASDisplayNode? = nil
    ) -> Disposable where Observer: ASObserverType, Self.Element == Observer.Element {
        weak var weakNode = node
        
        if directlyBind, let value = (self as? BehaviorRelay<Self.Element>)?.value {
            observer.directlyBinding(value)
        }
        
        return subscribe { event in
            switch event {
            case .next:
                observer.on(event, node: weakNode)
            case let .error(error):
                #if DEBUG
                    fatalError(error.localizedDescription)
                #else
                    print(error)
                #endif
            case .completed:
                break
            }
        }
    }
    
    public func bind<Observer>(
        to observer: Observer,
        directlyBind: Bool = false,
        setNeedsLayout node: ASDisplayNode? = nil
    ) -> Disposable where Observer: ASObserverType, Observer.Element == Element? {
        weak var weakNode = node
        
        if directlyBind, let value = (self as? BehaviorRelay<Self.Element>)?.value {
            observer.directlyBinding(value)
        }
        
        return self.map { $0 }.subscribe { observerEvent in
            switch observerEvent {
            case .next:
                observer.on(
                    observerEvent.map { Optional<Self.Element>($0) },
                    node: weakNode
                )
            case .error(let error):
                #if DEBUG
                    fatalError(error.localizedDescription)
                #else
                    print(error)
                #endif
            case .completed:
                break
            }
        }
    }
    
    public func bind(
        to relay: PublishRelay<Element>,
        setNeedsLayout node: ASDisplayNode? = nil
    ) -> Disposable {
        weak var weakNode = node
        return subscribe { event in
            switch event {
            case let .next(element):
                relay.accept(element)
                weakNode?.setNeedsLayout()
            case let .error(error):
                let log = "Binding error to publish relay: \(error)"
                #if DEBUG
                    fatalError(log)
                #else
                    print(log)
                #endif
            case .completed:
                break
            }
        }
    }
    
    public func bind(
        to relay: PublishRelay<Element?>,
        setNeedsLayout node: ASDisplayNode? = nil
    ) -> Disposable {
        weak var weakNode = node
        return self.map { $0 as Element? }
            .bind(to: relay, setNeedsLayout: weakNode)
    }
    
    public func bind(
        to relay: BehaviorRelay<Element>,
        setNeedsLayout node: ASDisplayNode? = nil
    ) -> Disposable {
        weak var weakNode = node
        return subscribe { event in
            switch event {
            case let .next(element):
                relay.accept(element)
                weakNode?.setNeedsLayout()
            case let .error(error):
                let log = "Binding error to behavior relay: \(error)"
                #if DEBUG
                    fatalError(log)
                #else
                    print(log)
                #endif
            case .completed:
                break
            }
        }
    }
    
    public func bind(
        to relay: BehaviorRelay<Element?>,
        setNeedsLayout node: ASDisplayNode? = nil
    ) -> Disposable {
        weak var weakNode = node
        return self.map { $0 as Element? }
            .bind(to: relay, setNeedsLayout: weakNode)
    }
}
