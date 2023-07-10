//
//  UserViewModel.swift
//  RxTextureSupport_Example
//
//  Created by Hong Daly on 10/07/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//


import RxTextureSupport
import Foundation
import RxSwift
import RxCocoa
import RxRelay
import RxOptional
import Foundation
import Fakery


final class RxUserViewModel {
    
    let refreshRelay = PublishRelay<Void>()
    let loadMoreRelay = PublishRelay<Void>()
    
    let users = BehaviorRelay<[User]?>(value: nil)
    let since = BehaviorRelay<String?>(value: nil)
    let sections: Observable<[UserSection]>
    
    let disposeBag = DisposeBag()
    
    init() {
        
        self.sections = self.users
            .filterNil()
            .map { [
                UserSection.friend(users: $0)
            ] }
            .asObservable()
        
        self.users.map { $0?.last?.id }
            .filterNil()
            .bind(to: since)
            .disposed(by: disposeBag)

        self.refreshRelay
            .flatMap { self.fetchFriends().catchAndReturn([]) }
            .bind(to: users)
            .disposed(by: disposeBag)

        self.loadMoreRelay
            .withLatestFrom(since)
            .filterNil()
            .distinctUntilChanged()
            .flatMap { _ in self.fetchFriends().catchAndReturn([]) }
            .withLatestFrom(users) { (new, old) -> [User] in
                var sequence = old ?? []
                sequence.append(contentsOf: new)
                return sequence
            }
            .bind(to: users)
            .disposed(by: disposeBag)
    }
    
    
    private let faker = Faker()
    
    
    func fetchFriends() -> Single<[User]>{
        var fri : [User] = []
        (0...2).forEach { _ in
            fri.append(.init(name: faker.name.name(),
                             email: faker.internet.email()))
        }
        return .just(fri)
    }
}
