//
//  Array+Extensions.swift
//  NewsfeedMVVM
//
//  Created by Ibrahim Mo Gedami on 21.01.2021.
//  Copyright © 2021 Ibrahim Mo Gedami. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    
    func unique() -> Array<Element> {
        return Array(Set(self))
    }
}
