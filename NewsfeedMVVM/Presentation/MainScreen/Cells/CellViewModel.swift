//
//  CellViewModel.swift
//  NewsfeedMVVM
//
//  Created by Ibrahim Mo Gedami on 30.07.2020.
//  Copyright © 2020 Ibrahim Mo Gedami. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources
import Swinject

let imageCache = NSCache<NSString, UIImage>()

protocol CellViewModelType {
    
    var identity: String { get }
    var publishedAt: Date { get }
    var title: Driver<String?> { get }
    var author: Driver<String?> { get }
    var content: Driver<String?> { get }
    var image: Driver<UIImage?> { get }
}

final class CellViewModel: CellViewModelType, IdentifiableType {
    
    private let networkManager: NetworkManagerType?
    
    let identity: String
    let publishedAt: Date
    let title: Driver<String?>
    let author: Driver<String?>
    let content: Driver<String?>
    private let urlToImage: String
    private let defaultImage: UIImage?
    
    var image: Driver<UIImage?> {
        
        if let cachedImage = imageCache.object(forKey: NSString(string: urlToImage)) {
            return Driver<UIImage?>.just(cachedImage)
        }
        
        guard let networkManager = networkManager else { return Driver<UIImage?>.just(UIImage()) }
        
        return networkManager.getNewsImage(from: urlToImage)
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .map { imageData in
                if let downloadedImage = UIImage(data: imageData) {
                    imageCache.setObject(downloadedImage, forKey: NSString(string: self.urlToImage))
                    return downloadedImage
                } else {
                    return self.defaultImage
                }
            }.asDriver(onErrorJustReturn: defaultImage)
    }
    
    init(for news: NewsEntity, dependencies: Container?) {
        
        let date = NewsEntity.dateFormatter.string(from: news.publishedAt ?? Date())
        
        identity = (news.title ?? "") + news.description.prefix(10) + date
        publishedAt = news.publishedAt ?? Date()
        title = Driver.of(news.title).asDriver(onErrorJustReturn: nil)
        author = Driver.of((news.author ?? "Noname") + " at " + date)
        content = Driver.of(news.content)
        urlToImage = news.urlToImage ?? ""
        defaultImage = UIImage(named: "defaultImage")
        networkManager = dependencies?.resolve(NetworkManager.self)
    }
}

extension CellViewModel: Equatable {
    static func == (lhs: CellViewModel, rhs: CellViewModel) -> Bool {
        return lhs.identity == rhs.identity
    }
}

extension CellViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identity)
    }
}
