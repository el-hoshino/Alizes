//
//  BaudotCode.swift
//  Alizes
//
//  Created by 史　翔新 on 2016/11/21.
//  Copyright © 2016年 net.crazism. All rights reserved.
//

import Foundation

public struct BaudotCode {
	
	public enum Code {
		
		public enum Letters: UInt8 {
			
			case a				= 0b11_000
			case b				= 0b10_011
			case c				= 0b01_110
			case d				= 0b10_010
			case e				= 0b10_000
			case f				= 0b10_110
			case g				= 0b01_011
			case h				= 0b00_101
			case i				= 0b01_100
			case j				= 0b11_010
			case k				= 0b11_110
			case l				= 0b01_001
			case m				= 0b00_111
			case n				= 0b00_110
			case o				= 0b00_011
			case p				= 0b01_101
			case q				= 0b11_101
			case r				= 0b01_010
			case s				= 0b10_100
			case t				= 0b00_001
			case u				= 0b11_100
			case v				= 0b01_111
			case w				= 0b11_001
			case x				= 0b10_111
			case y				= 0b10_101
			case z				= 0b10_001
			case null			= 0b00_000
			case space			= 0b00_100
			case carriageReturn	= 0b00_010
			case lineFeed		= 0b01_000
			case shiftToFigures	= 0b11_011
			case shiftToLetters	= 0b11_111
			
		}
		
		public enum Figures: UInt8 {
			
			case zero			= 0b01_101
			case one			= 0b11_101
			case two			= 0b11_001
			case three			= 0b10_000
			case four			= 0b01_010
			case five			= 0b00_001
			case six			= 0b10_101
			case seven			= 0b11_100
			case eight			= 0b01_100
			case nine			= 0b00_011
			case bracketLeft	= 0b11_110
			case bracketRight	= 0b01_001
			case slash			= 0b10_111
			case colon			= 0b01_110
			case ampersand		= 0b01_011
			case apostrophe		= 0b10_100
			case comma			= 0b00_110
			case period			= 0b00_111
			case question		= 0b10_011
			case exclamation	= 0b10_110
			case currency		= 0b00_101
			case plus			= 0b10_001
			case minus			= 0b11_000
			case equals			= 0b01_111
			case bell			= 0b11_010
			case wru			= 0b10_010
			case null			= 0b00_000
			case space			= 0b00_100
			case carriageReturn	= 0b00_010
			case lineFeed		= 0b01_000
			case shiftToFigure	= 0b11_011
			case shiftToLetters	= 0b11_111
			
		}
		
		case letter(Letters)
		case figure(Figures)
		
	}
	
	fileprivate let content: String
	let codes: [Code]
	
}

extension BaudotCode.Code.Letters: BinaryCodeConvertible {
	
	public var binaryCodeContainer: BinaryCodeContainer {
		return BinaryCodeContainer(value: UInt(self.rawValue), digitCount: 5)
	}
	
}

extension BaudotCode.Code.Letters: CustomStringConvertible {
	
	public var description: String {
		return self.rawValue.baudotCodeString
	}
	
}

extension BaudotCode.Code.Figures: BinaryCodeConvertible {
	
	public var binaryCodeContainer: BinaryCodeContainer {
		return BinaryCodeContainer(value: UInt(self.rawValue), digitCount: 5)
	}
	
}

extension BaudotCode.Code.Figures: CustomStringConvertible {
	
	public var description: String {
		return self.rawValue.baudotCodeString
	}
	
}

extension BaudotCode.Code: BinaryCodeConvertible {
	
	public var binaryCodeContainer: BinaryCodeContainer {
		switch self {
		case .letter(let letter):
			return letter.binaryCodeContainer
			
		case .figure(let figure):
			return figure.binaryCodeContainer
		}
	}
	
}

extension BaudotCode.Code: CustomStringConvertible {
	
	public var description: String {
		
		switch self {
		case .letter(let letter):
			return letter.description
			
		case .figure(let figure):
			return figure.description
		}
		
	}
	
}

extension BaudotCode.Code {
	
	var swithcerCode: BaudotCode.Code {
		switch self {
		case .letter:
			return .letter(.shiftToLetters)
			
		case .figure:
			return .figure(.shiftToFigure)
		}
	}
	
	func isTheSameType(with anotherCode: BaudotCode.Code?) -> Bool {
		
		guard let anotherCode = anotherCode else {
			return false
		}
		
		switch (self, anotherCode) {
		case (.letter, .letter),
		     (.figure, .figure):
			return true
			
		default:
			return false
		}
		
	}
	
}

extension BaudotCode: StringInitializable {
	
	public var initializedString: String {
		return self.content
	}
	
	public init(_ string: String) {
		
		let tuple = string.characters.reduce((content: "", codes: [])) { (tuples, character) -> (content: String, codes: [BaudotCode.Code]) in
			
			let dictionary = BaudotCodeDictionary()
			
			var content = tuples.content
			var codes = tuples.codes
			
			guard let nextCode = dictionary.getCode(for: character) else {
				return tuples
			}
			
			content += String(character)
			
			let lastCode = codes.last
			if nextCode.isTheSameType(with: lastCode) {
				codes.append(nextCode)
				
			} else {
				codes.append(nextCode.swithcerCode)
				codes.append(nextCode)
			}
			
			return (content, codes)
			
		}
		
		self.content = tuple.content
		self.codes = tuple.codes
		
	}
	
}

extension BaudotCode: BinaryCodeConvertible {
	
	public var binaryCodeContainer: BinaryCodeContainer {
		return self.codes.reduce(.empty, { (container, baudotCode) -> BinaryCodeContainer in
			return container + baudotCode.binaryCodeContainer
		})
	}
	
}

extension BaudotCode: Convertible {
	
}

extension BaudotCode: CustomStringConvertible {
	
	public var description: String {
		return self.codes.reduce("", { (description, code) -> String in
			if description.isEmpty {
				return code.description
				
			} else {
				return description + "\n" + code.description
			}
		})
	}
	
}

private extension UInt8 {
	
	var baudotCodeString: String {
		return (UInt8(0) ..< UInt8(5)).reversed().reduce("") { (code, i) -> String in
			let unit = ((self >> i) & 0b1) == 0 ? " " : "."
			return code + unit
		}
	}
	
}
