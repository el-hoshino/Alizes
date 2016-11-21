//
//  Converter.swift
//  Alizes
//
//  Created by 史　翔新 on 2016/11/21.
//  Copyright © 2016年 net.crazism. All rights reserved.
//

import Foundation

protocol StringInitializable {
	init(_ string: String)
}

protocol Convertable: StringInitializable, BinaryCodeConvertible {
	
}

public struct Converter {
	
	public enum Code {
		case morseCode
		case baudotCode
	}
	
	public init() {
		
	}
	
	public func convert(_ string: String, to code: Code) -> BinaryCodeConvertible {
		return code.initializer.init(string)
	}
	
	public typealias BinaryCodeGroup = (code: BinaryCode.Code, length: Int)
	public func group(code: BinaryCode) -> [BinaryCodeGroup] {
		
		return code.codes.reduce([]) { (groupedCodes, code) -> [BinaryCodeGroup] in
			var groupedCodes = groupedCodes
			if var lastCodeGroup = groupedCodes.last {
				if lastCodeGroup.code == code {
					lastCodeGroup.length.increase()
					groupedCodes.removeLast()
					groupedCodes.append(lastCodeGroup)
					
				} else {
					let newCodeGroup = (code: code, length: 1)
					groupedCodes.append(newCodeGroup)
				}
				return groupedCodes
				
			} else {
				return [(code: code, length: 1)]
			}
		}
		
	}
	
}

extension Converter.Code {
	
	var initializer: Convertable.Type {
		switch self {
		case .morseCode:
			return MorseCode.self
			
		case .baudotCode:
			return BaudotCode.self
		}
	}
	
}
