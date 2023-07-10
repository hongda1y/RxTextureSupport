//
//  Observable+Ext.swift
//  
//
//  Created by Dimas Prabowo on 14/06/23.

import RxCocoa
import RxSwift

extension ObservableType {
    internal func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
    internal func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in Driver.empty() }
    }
    
    internal func asSignalrOnErrorJustComplete() -> Signal<Element> {
        return asSignal { _ in Signal.empty() }
    }
}

extension SharedSequenceConvertibleType {
    internal func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}
