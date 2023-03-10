//
//  Reactive+Extensions.swift
//  NewsfeedMVVM
//
//  Created by Ibrahim Mo Gedami on 21.01.2021.
//  Copyright © 2021 Ibrahim Mo Gedami. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    
    var viewWillAppear: ControlEvent<Void> {
        // Reload data after 8 seconds on appear
        let source = self.methodInvoked(#selector(Base.viewWillAppear(_:))).delay(.seconds(8), scheduler: ConcurrentDispatchQueueScheduler(qos: .default)).map { _ in }
        return ControlEvent(events: source)
    }
}

extension Reactive where Base: UIScrollView {
    
    var reachedBottom: ControlEvent<Void> {
        
        let observable = contentOffset
            .flatMap { [weak base] contentOffset -> Observable<Void> in
                guard let scrollView = base else { return Observable.empty() }

                let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
                let y = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)

                return y > threshold ? Observable.just(()) : Observable.empty()
        }
        return ControlEvent(events: observable)
    }
}
