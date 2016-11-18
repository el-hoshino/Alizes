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
		switch character {
		case "A", "a":
			self = MorseCode.Letter(codeString: ".-")
			
		case "B", "b":
			self = MorseCode.Letter(codeString: "-...")
			
		case "C", "c":
			self = MorseCode.Letter(codeString: "-.-.")
			
		case "D", "d":
			self = MorseCode.Letter(codeString: "-..")
			
		case "E", "e":
			self = MorseCode.Letter(codeString: ".")
			
		case "F", "f":
			self = MorseCode.Letter(codeString: "..-.")
			
		case "G", "g":
			self = MorseCode.Letter(codeString: "--.")
			
		case "H", "h":
			self = MorseCode.Letter(codeString: "....")
			
		case "I", "i":
			self = MorseCode.Letter(codeString: "..")
			
		case "J", "j":
			self = MorseCode.Letter(codeString: ".---")
			
		case "K", "k":
			self = MorseCode.Letter(codeString: "-.-")
			
		case "L", "l":
			self = MorseCode.Letter(codeString: ".-..")
			
		case "M", "m":
			self = MorseCode.Letter(codeString: "--")
			
		case "N", "n":
			self = MorseCode.Letter(codeString: "-.")
			
		case "O", "o":
			self = MorseCode.Letter(codeString: "---")
			
		case "P", "p":
			self = MorseCode.Letter(codeString: ".--.")
			
		case "Q", "q":
			self = MorseCode.Letter(codeString: "--.-")
			
		case "R", "r":
			self = MorseCode.Letter(codeString: ".-.")
			
		case "S", "s":
			self = MorseCode.Letter(codeString: "...")
			
		case "T", "t":
			self = MorseCode.Letter(codeString: "-")
			
		case "U", "u":
			self = MorseCode.Letter(codeString: "..-")
			
		case "V", "v":
			self = MorseCode.Letter(codeString: "...-")
			
		case "W", "w":
			self = MorseCode.Letter(codeString: ".--")
			
		case "X", "x":
			self = MorseCode.Letter(codeString: "-..-")
			
		case "Y", "y":
			self = MorseCode.Letter(codeString: "-.--")
			
		case "Z", "z":
			self = MorseCode.Letter(codeString: "--..")
			
		case "0":
			self = MorseCode.Letter(codeString: "-----")
			
		case "1":
			self = MorseCode.Letter(codeString: ".----")
			
		case "2":
			self = MorseCode.Letter(codeString: "..---")
			
		case "3":
			self = MorseCode.Letter(codeString: "...--")
			
		case "4":
			self = MorseCode.Letter(codeString: "....-")
			
		case "5":
			self = MorseCode.Letter(codeString: ".....")
			
		case "6":	
			self = MorseCode.Letter(codeString: "-....")
			
		case "7":	
			self = MorseCode.Letter(codeString: "--...")
			
		case "8":	
			self = MorseCode.Letter(codeString: "---..")
			
		case "9":
			self = MorseCode.Letter(codeString: "----.")
			
		default:
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
