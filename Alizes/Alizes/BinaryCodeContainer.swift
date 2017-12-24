//
//  BinaryCodeContainer.swift
//  Alizes
//
//  Created by 史　翔新 on 2016/11/18.
//  Copyright © 2016年 net.crazism. All rights reserved.
//

import Foundation

public protocol BinaryCodeRepresentable {
	var binaryCodeContainer: BinaryCodeContainer { get }
}

public struct BinaryCodeContainer {
	
	public enum Code {
		case o
		case i
	}
	
	public static let empty = BinaryCodeContainer(codes: [])
	
	public let codes: [Code]
	
	public init(codes: [Code]) {
		self.codes = codes
	}
	
	public init(count: Int, repeatedCode: Code) {
		
		self.codes = (0 ..< count).map { (_) -> Code in
			return repeatedCode
		}
		
	}
	
	public init(value: UInt, digitCount: Int) {
		
		self.codes = (0 ..< digitCount).reversed().map({ (i) -> Code in
			return (value >> UInt(i)) & 0b1 == 0 ? .o : .i
		})
		
	}
	
	public var isEmpty: Bool {
		return self.codes.count == 0
	}
	
}

extension BinaryCodeContainer.Code: CustomStringConvertible {
	
	public var description: String {
		switch self {
		case .o:
			return "0"
			
		case .i:
			return "1"
		}
	}
	
}

extension BinaryCodeContainer: CustomStringConvertible {
	
	public var description: String {
		return self.codes.reduce("", { (description, code) -> String in
			return description + code.description
		})
	}
	
}

public func + (lhs: BinaryCodeContainer, rhs: BinaryCodeContainer) -> BinaryCodeContainer {
	return BinaryCodeContainer(codes: lhs.codes + rhs.codes)
}
