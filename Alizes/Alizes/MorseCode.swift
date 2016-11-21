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
		
		public enum Code: BinaryCodeConvertible {
			
			case dot
			case dash
			
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
			
			public var binaryCode: BinaryCode {
				switch self {
				case .dot:
					return BinaryCode(count: 1, repeatedCode: .i)
					
				case .dash:
					return BinaryCode(count: 3, repeatedCode: .i)
				}
			}
			
		}
		
		public enum Gap: BinaryCodeConvertible {
			
			case interElement
			case short
			case medium
			
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
		
		case code(Code)
		case gap(Gap)
		
	}
	
	
	public struct Letter: BinaryCodeConvertible {
		
		public let codes: [Unit.Code]
		
		public var binaryCode: BinaryCode {
			return self.codes.reduce(.empty) { (binaryCode, unitCode) -> BinaryCode in
				if binaryCode.isEmpty {
					return unitCode.binaryCode
				} else {
					return binaryCode + Unit.Gap.interElement.binaryCode + unitCode.binaryCode
				}
			}
		}
		
	}
	
	public struct Word: BinaryCodeConvertible {
		
		public let letters: [Letter]
		
		public var binaryCode: BinaryCode {
			return self.letters.reduce(.empty) { (binaryCode, letter) -> BinaryCode in
				if binaryCode.isEmpty {
					return letter.binaryCode
				} else {
					return binaryCode + Unit.Gap.short.binaryCode + letter.binaryCode
				}
			}
		}
		
	}
	
	public struct Sentence: BinaryCodeConvertible {
		
		public let words: [Word]
		
		public var binaryCode: BinaryCode {
			return self.words.reduce(.empty) { (binaryCode, word) -> BinaryCode in
				if binaryCode.isEmpty {
					return word.binaryCode
				} else {
					return binaryCode + Unit.Gap.medium.binaryCode + word.binaryCode
				}
			}
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

extension MorseCode.Letter {
	
	private init(codeString: String) {
		
		let codes = codeString.characters.map { (codeCharacter) -> MorseCode.Unit.Code in
			guard let code = MorseCode.Unit.Code(codeCharacter) else {
				fatalError("Invalid code string")
			}
			return code
		}
		
		self.codes = codes
		
	}
	
	public init?(_ character: Character) {
		let dictionary = MorseCodeDictionary()
		if let code = dictionary.getCode(forCharacter: character) {
			self = MorseCode.Letter(codeString: code)
			
		} else {
			return nil
		}
	}
	
}

extension MorseCode.Letter: CustomStringConvertible {
	
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

extension MorseCode.Word: CustomStringConvertible {
	
	public var description: String {
		return self.letters.reduce("", { (description, letter) -> String in
			if description.isEmpty {
				return letter.description
			} else {
				return description + "/" + letter.description
			}
		})
	}
	
}

extension MorseCode.Sentence: CustomStringConvertible {
	
	public var description: String {
		return self.words.reduce("", { (description, word) -> String in
			if description.isEmpty {
				return word.description
			} else {
				return description + "///" + word.description
			}
		})
	}
	
}

extension MorseCode.Word {
	
	public init(_ string: String) {
		
		let letters = string.characters.flatMap { (character) -> MorseCode.Letter? in
			return MorseCode.Letter(character)
		}
		self.letters = letters
		
	}
	
}

extension MorseCode.Sentence {
	
	public init (_ string: String) {
		
		let words = string.components(separatedBy: .whitespaces).map { (word) -> MorseCode.Word in
			return MorseCode.Word(word)
		}
		self.words = words
		
	}
	
}
