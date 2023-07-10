//
//  ASNetworkImageNode+Rx.swift
//  
//
//  Created by Dimas Prabowo on 05/06/23.

import AsyncDisplayKit
import RxSwift
import RxCocoa

extension Reactive where Base: ASNetworkImageNode {
    /// Binder of `URL` for url property of `ASNetworkImageNode`.
    public var url: ASBinder<URL?> {
        return ASBinder(self.base) { node, url in
            node.setURL(url, resetToDefault: true)
        }
    }
    
    /// Directly set images to the image property will be cleared out and replaced by the placeholder () image while loading and the final image after the new image data was downloaded and processed.
    ///
    /// - Parameters:
    ///     - resetToDefault: Decide to reset image to placeholder.
    public func url(resetToDefault: Bool) -> ASBinder<URL?> {
        return ASBinder(self.base) { node, url in
            node.setURL(url, resetToDefault: resetToDefault)
        }
    }
}
