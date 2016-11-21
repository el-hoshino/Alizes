//
//  MorseCode.swift
//  Alizes
//
//  Created by 史　翔新 on 2016/11/18.
//  Copyright © 2016年 net.crazism. All rights reserved.
//

import Foundation

public struct MorseCode {
	
	public enum Unit {
		
		public enum Code {
			
			case dot
			case dash
			
		}
		
		public enum Gap {
			
			case interElement
			case short
			case medium
			
		}
		
		case code(Code)
		case gap(Gap)
		
	}
	
	
	public struct Word {
		
		public struct Letter {
			
			public let codes: [Unit.Code]
			
		}
		
		fileprivate let content: String
		public let letters: [Letter]
		
	}
	
	fileprivate let content: String
	let words: [Word]
	
}

extension MorseCode.Unit.Code {
	
	init?(_ code: Character) {
		switch code {
		case ".":
			self = .dot
			
		case "-":
			self = .dash
			
		default:
			return nil
		}
	}
	
}

extension MorseCode.Unit.Code: BinaryCodeConvertible {
	
	public var binaryCode: BinaryCode {
		switch self {
		case .dot:
			return BinaryCode(count: 1, repeatedCode: .i)
			
		case .dash:
			return BinaryCode(count: 3, repeatedCode: .i)
		}
	}
	
}

extension MorseCode.Unit.Code: CustomStringConvertible {
	
	public var description: String {
		switch self {
		case .dot:
			return "."
			
		case .dash:
			return "-"
		}
	}
	
}

extension MorseCode.Unit.Gap: BinaryCodeConvertible {
	
	public var binaryCode: BinaryCode {
		switch self {
		case .interElement:
			return BinaryCode(count: 1, repeatedCode: .o)
			
		case .short:
			return BinaryCode(count: 3, repeatedCode: .o)
			
		case .medium:
			return BinaryCode(count: 7, repeatedCode: .o)
		}
	}
	
}

extension MorseCode.Unit.Gap: CustomStringConvertible {
	
	public var description: String {
		switch self {
		case .interElement:
			return " "
			
		case .short:
			return "   "
			
		case .medium:
			return "       "
		}
	}
	
}

extension MorseCode.Unit: CustomStringConvertible {
	
	public var description: String {
		switch self {
		case .code(let code):
			return code.description
			
		case .gap(let gap):
			return gap.description
		}
	}
	
}

extension MorseCode.Word.Letter: BinaryCodeConvertible {
	
	public var binaryCode: BinaryCode {
		return self.codes.reduce(.empty) { (binaryCode, unitCode) -> BinaryCode in
			if binaryCode.isEmpty {
				return unitCode.binaryCode
			} else {
				return binaryCode + MorseCode.Unit.Gap.interElement.binaryCode + unitCode.binaryCode
			}
		}
	}
	
}

extension MorseCode.Word.Letter: CustomStringConvertible {
	
	public var description: String {
		return self.codes.reduce("", { (description, code) -> String in
			if description.isEmpty {
				return code.description
			} else {
				return description + code.description
			}
		})
	}
	
}

extension MorseCode.Word {
	
	public init(_ string: String) {
		
		let dictionary = MorseCodeDictionary()
		let tuples = string.characters.flatMap { (character) -> (character: Character, code: MorseCode.Word.Letter)? in
			if let code = dictionary.getCode(for: character) {
				return (character, code)
			} else {
				return nil
			}
		}
		self.content = tuples.reduce("", { (content, tuple) -> String in
			return content + String(tuple.character)
		})
		self.letters = tuples.map({ (tuple) -> MorseCode.Word.Letter in
			return tuple.code
		})
		
	}
	
}

extension MorseCode.Word: BinaryCodeConvertible {
	
	public var binaryCode: BinaryCode {
		return self.letters.reduce(.empty) { (binaryCode, letter) -> BinaryCode in
			if binaryCode.isEmpty {
				return letter.binaryCode
			} else {
				return binaryCode + MorseCode.Unit.Gap.short.binaryCode + letter.binaryCode
			}
		}
	}
	
}

extension MorseCode.Word: CustomStringConvertible {
	
	public var description: String {
		return self.letters.reduce("", { (description, letter) -> String in
			if description.isEmpty {
				return letter.description
			} else {
				return description + " " + letter.description
			}
		})
	}
	
}

extension MorseCode: StringInitializable {
	
	public var initializedString: String {
		return self.content
	}
	
	public init (_ string: String) {
		
		let words = string.components(separatedBy: .whitespaces).map { (word) -> MorseCode.Word in
			return MorseCode.Word(word)
		}
		
		self.content = words.reduce("", { (content, word) -> String in
			if content.isEmpty {
				return word.content
			} else {
				return content + " " + word.content
			}
		})
		self.words = words
		
	}
	
}

extension MorseCode: BinaryCodeConvertible {
	
	public var binaryCode: BinaryCode {
		return self.words.reduce(.empty, { (binaryCode, word) -> BinaryCode in
			if binaryCode.isEmpty {
				return word.binaryCode
			} else {
				return binaryCode + Unit.Gap.medium.binaryCode + word.binaryCode
			}
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

extension MorseCode: Convertible {
	
}

extension MorseCode: CustomStringConvertible {
	
	public var description: String {
		return self.words.reduce("", { (description, word) -> String in
			if description.isEmpty {
				return word.description
			} else {
				return description + "   " + word.description
			}
		})
	}
	
}
