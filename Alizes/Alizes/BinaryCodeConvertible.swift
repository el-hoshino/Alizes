//
//  BinaryCodeConvertible.swift
//  Alizes
//
//  Created by 史　翔新 on 2016/11/18.
//  Copyright © 2016年 net.crazism. All rights reserved.
//

import Foundation
import Eltaso


public protocol BinaryCodeConvertible {
	var binaryCode: BinaryCode { get }
}

extension BinaryCodeConvertible {
	
	public typealias BinaryCodeGroup = (code: BinaryCode.Code, length: Int)
	public var groupedBinaryCode: [BinaryCodeGroup] {
		
		let codes = self.binaryCode.codes
		let groupedCodes = codes.reduce([]) { (groupedCodes, code) -> [BinaryCodeGroup] in
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
		
		return groupedCodes
		
	}
	
}

public struct BinaryCode {
	
	public enum Code {
		case o
		case i
	}
	
	public static let empty = BinaryCode(codes: [])
	
	public let codes: [Code]
	
	public init(codes: [Code]) {
		self.codes = codes
	}
	
	public init(count: Int, repeatedCode: Code) {
		
		self.codes = (0 ..< count).map { (_) -> Code in
			return repeatedCode
		}
		
	}
	
	public var isEmpty: Bool {
		return self.codes.count == 0
	}
	
}

extension BinaryCode.Code: CustomStringConvertible {
	
	public var description: String {
		switch self {
		case .o:
			return "0"
			
		case .i:
			return "1"
		}
	}
	
}

extension BinaryCode: CustomStringConvertible {
	
	public var description: String {
		return self.codes.reduce("", { (description, code) -> String in
			return description + code.description
		})
	}
	
}

public func + (lhs: BinaryCode, rhs: BinaryCode) -> BinaryCode {
	return BinaryCode(codes: lhs.codes + rhs.codes)
}
