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
	
	let codes: [Code]
	
}

extension BaudotCode.Code.Letters: BinaryCodeConvertible {
	
	public var binaryCode: BinaryCode {
		return BinaryCode(value: UInt(self.rawValue), digitCount: 5)
	}
	
}

extension BaudotCode.Code.Letters: CustomStringConvertible {
	
	public var description: String {
		return self.rawValue.baudotCodeString
	}
	
}

extension BaudotCode.Code.Figures: BinaryCodeConvertible {
	
	public var binaryCode: BinaryCode {
		return BinaryCode(value: UInt(self.rawValue), digitCount: 5)
	}
	
}

extension BaudotCode.Code.Figures: CustomStringConvertible {
	
	public var description: String {
		return self.rawValue.baudotCodeString
	}
	
}

extension BaudotCode.Code: BinaryCodeConvertible {
	
	public var binaryCode: BinaryCode {
		switch self {
		case .letter(let letter):
			return letter.binaryCode
			
		case .figure(let figure):
			return figure.binaryCode
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
extension BaudotCode: StringInitializable {
	
	public init(_ string: String) {
		
		let codes = string.characters.reduce([]) { (codes, character) -> [BaudotCode.Code] in
			
			let dictionary = BaudotCodeDictionary()
			var codes = codes
			let lastCode = codes.last ?? {
				let last = BaudotCode.Code.letter(.shiftToLetters)
				codes.append(last)
				return last
			}()
			
			switch lastCode {
			case .letter:
				if let code = dictionary.getCodeFromLetters(for: character) {
					codes.append(.letter(code))
					
				} else if let code = dictionary.getCodeFromFigures(for: character) {
					codes.append(.letter(.shiftToFigures))
					codes.append(.figure(code))
				}
				
			case .figure:
				if let code = dictionary.getCodeFromFigures(for: character) {
					codes.append(.figure(code))
					
				} else if let code = dictionary.getCodeFromLetters(for: character) {
					codes.append(.figure(.shiftToLetters))
					codes.append(.letter(code))
				}
			}
			
			return codes
			
		}
		
		self.codes = codes
		
	}
	
}

extension BaudotCode: BinaryCodeConvertible {
	
	public var binaryCode: BinaryCode {
		return self.codes.reduce(.empty, { (binaryCode, baudotCode) -> BinaryCode in
			return binaryCode + baudotCode.binaryCode
		})
	}
	
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

extension BaudotCode: Convertable {
	
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
