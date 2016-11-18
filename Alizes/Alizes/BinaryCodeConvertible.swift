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
	
	public init(value: Int) {
		
		var int = value
		var codes = [Code]()
		
		repeat {
			let lastBit = int & 0b1
			if lastBit == 0 {
				codes.insert(.o, at: 0)
			} else {
				codes.insert(.i, at: 0)
			}
			int >>= 1
		} while int > 0
		
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
