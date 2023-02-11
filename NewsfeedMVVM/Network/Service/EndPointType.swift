//
//  EndPointType.swift
//  NewsfeedMVVM
//
//  Created by Ibrahim Mo Gedami on 01.02.2021.
//  Copyright © 2021 Ibrahim Mo Gedami. All rights reserved.
//

import Alamofire

protocol EndPointType {
    var url: URL? { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
}
