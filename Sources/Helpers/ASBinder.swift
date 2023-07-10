//
//  ASBinder.swift
//  
//
//  Created by Dimas Prabowo on 05/06/23.

import AsyncDisplayKit
import RxCocoa
import RxSwift

public struct ASBinder<Value>: ASObserverType {
    public typealias Element = Value
    
    private let _binding: (Event<Value>, ASDisplayNode?) -> ()
    private let _directlyBinding: (Value?) -> ()
    
    public init<Target: AnyObject>(
        _ target: Target,
        scheduler: ImmediateSchedulerType = MainScheduler(),
        binding: @escaping (Target, Value) -> ()
    ) {
        weak var weakTarget = target
        
        _binding = { event, node in
            switch event {
            case let .next(element):
                _ = scheduler.schedule(element) { element in
                    if let target = weakTarget {
                        ASPerformBlockOnMainThread {
                            binding(target, element)
                        }
                    }
                    node?.rxSetNeedsLayout()
                    return Disposables.create()
                }
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
        
        _directlyBinding = { value in
            if let target = weakTarget,
               let value = value {
                binding(target, value)
            }
        }
    }
    
    public func on(_ event: Event<Value>, node: ASDisplayNode?) {
        _binding(event, node)
    }
    
    public func directlyBinding(_ element: Value?) {
        _directlyBinding(element)
    }
    
    public func on(_ event: Event<Value>) {
        _binding(event, nil)
    }
}
