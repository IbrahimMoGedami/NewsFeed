//
//  MainCoordinator.swift
//  NewsfeedMVVM
//
//  Created by Ibrahim Mo Gedami on 03.02.2021.
//  Copyright © 2021 Ibrahim Mo Gedami. All rights reserved.
//

import UIKit
import Swinject

protocol DetailFlow: class {
    func coordinateToDetail(cellViewModel: CellViewModelType)
}

class MainCoordinator: CoordinatorType, DetailFlow {
    
    let container: Container
    let navigationController: UINavigationController
    
    func start() {
        
        guard let mainViewController = container.resolve(MainViewController.self) else { return }
        mainViewController.coordinator = self
        
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
    func coordinateToDetail(cellViewModel: CellViewModelType) {
        
        let detailCoordinator = DetailCoordinator(navigationController: navigationController, cellViewModel: cellViewModel)
        coordinate(to: detailCoordinator)
    }

    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }
}
