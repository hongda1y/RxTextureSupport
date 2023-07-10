//
//  MainViewController.swift
//  RxTextureSupport_Example
//
//  Created by Hong Daly on 10/07/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import TextureSwiftSupport
import ESPullToRefresh
import RxSwift
import RxTextureSupport

class MainViewController : ASDKViewController<ASTableNode> {
    
    private let viewModel = RxUserViewModel()
    private let disposeBag = DisposeBag()
    
    private let dataSource =  RxASTableSectionedAnimatedDataSource<UserSection>(
        configureCellBlock: { (_, _, _, num) in
            return {
                let cell = ASTextCellNode()
                cell.text = "\(num)"
                return cell
            }
    })
    
    
    override init() {
        super.init(node: ASTableNode())
        node.automaticallyManagesSubnodes = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViewModel()
        setupES()
    }
    
    var batchContext: ASBatchContext?
    
    private func setupES() {
//        node.view.es.addInfiniteScrolling {
//            [weak self] in
//            self?.viewModel.fetchNextItem()
//        }
    }
    
    private func setupViewModel () {
        
        node.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    
        viewModel
            .sections
            .asObservable()
            .do { [weak self] _ in
                self?.batchContext?.completeBatchFetching(true)
            }
            .bind(to: node.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        self.node
            .rx
            .willBeginBatchFetch
            .asObservable()
            .do(onNext: { [weak self] context in
                self?.batchContext = context
            }).map { _ in return }
            .bind(to: viewModel.loadMoreRelay)
            .disposed(by: disposeBag)
        
        
        viewModel.refreshRelay.accept(())

        
    }
        
    private func setupNavigation() {
        
        title = "RxDataSources"
        let addItem : UIBarButtonItem = .init(barButtonSystemItem: .add,
                                              target: self,
                                              action: #selector(onTapAdd))
        let sortItem : UIBarButtonItem = .init(barButtonSystemItem: .action,
                                               target: self,
                                               action: #selector(onTapSort))
        navigationItem.rightBarButtonItems = [addItem,sortItem]
        
    }
    
    @objc private func onTapSort() {
        print(#function)
    }
    
    @objc private func onTapAdd() {
        print(#function)
        //        viewModel.addSimpleContact()
    }
    
}
//
extension MainViewController : ASTableDelegate {
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        viewModel.since.value != nil
    }
}

extension MainViewController {
    
}
