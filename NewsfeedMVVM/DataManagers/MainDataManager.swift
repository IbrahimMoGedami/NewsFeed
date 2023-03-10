//
//  DataManager.swift
//  NewsfeedMVVM
//
//  Created by Ibrahim Mo Gedami on 30.07.2020.
//  Copyright © 2020 Ibrahim Mo Gedami. All rights reserved.
//

import RxSwift

protocol DataManagerType {
    
    var fetchNewDataTrigger: PublishSubject<Int> { get }
    var dataObservable: PublishSubject<[NewsEntity]> { get }
    var errorsObservable: PublishSubject<Error> { get }
}

class MainDataManager: DataManagerType {
    
    private let networkManager: NetworkManagerType
    private let coreDataManager: CoreDataManager
    
    // MARK: - Input
    private(set) var fetchNewDataTrigger = PublishSubject<Int>()
    
    // MARK: - Output
    private(set) var dataObservable = PublishSubject<[NewsEntity]>()
    private(set) var errorsObservable = PublishSubject<Error>()
    
    private let disposeBag = DisposeBag()
    
    private func bindTrigger() {

        fetchNewDataTrigger
            .subscribe(onNext: { page in
                self.fetchNewData(page: page)
            })
            .disposed(by: disposeBag)
        
        coreDataManager.coreDataObservable
            .bind(to: dataObservable)
            .disposed(by: disposeBag)
        
        coreDataManager.errorsObservable
            .bind(to: errorsObservable)
            .disposed(by: disposeBag)
    }

    public func fetchNewData(page: Int) {
        
        if page == 0 {
            coreDataManager.fetchSavedData()
            return
        }
        
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        networkManager.getHeadlines(page: page)
            .observeOn(scheduler)
            /// simulate slow network connection
            .delay(.seconds(1), scheduler: scheduler)
            .catchError({ [unowned self] error -> Observable<[News]> in
                if error.localizedDescription != "Response status code was unacceptable: 426." {
                    self.errorsObservable.onNext(error)
                }
                self.coreDataManager.fetchSavedData()
                return Observable.empty()
            })
            .subscribe(onNext: { [unowned self] data in
                self.coreDataManager.syncData(dataNews: data, erase: page == 1)
            })
            .disposed(by: self.disposeBag)
    }
    
     init(coreDataManager: CoreDataManager, networkManager: NetworkManagerType) {

        self.coreDataManager = coreDataManager
        self.networkManager = networkManager

        bindTrigger()
    }
}
