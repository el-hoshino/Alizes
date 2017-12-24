//
//  Converter.swift
//  Alizes
//
//  Created by 史　翔新 on 2016/11/21.
//  Copyright © 2016年 net.crazism. All rights reserved.
//

import Foundation

public protocol StringInitializable {
	var initializedString: String { get }
	init(_ string: String)
}
