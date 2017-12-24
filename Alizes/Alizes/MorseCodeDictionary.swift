//
//  MorseCodeDictionary.swift
//  Alizes
//
//  Created by 史　翔新 on 2016/11/21.
//  Copyright © 2016年 net.crazism. All rights reserved.
//

import Foundation

public struct MorseCodeDictionary {
	
	let alphabetDictionary: [String: String] = [
		"A": ".-",
		"B": "-...",
		"C": "-.-.",
		"D": "-..",
		"E": ".",
		"F": "..-.",
		"G": "--.",
		
		"H": "....",
		"I": "..",
		"J": ".---",
		"K": "-.-",
		"L": ".-..",
		"M": "--",
		"N": "-.",
		
		"O": "---",
		"P": ".--.",
		"Q": "--.-",
		"R": ".-.",
		"S": "...",
		"T": "-",
		
		"U": "..-",
		"V": "...-",
		"W": ".--",
		"X": "-..-",
		"Y": "-.--",
		"Z": "--..",
	]
	
	let numberDictionary: [String: String] = [
		"0": "-----",
		"1": ".----",
		"2": "..---",
		"3": "...--",
		"4": "....-",
		"5": ".....",
		"6": "-....",
		"7": "--...",
		"8": "---..",
		"9": "----.",
	]
	
	let punctuationDictionary: [String: String] = [
		".": ".-.-.-",
		",": "--..--",
		"?": "..--..",
		"'": ".----.",
		"!": "-.-.--",
		"/": "-..-.",
		"(": "-.--.",
		")": "-.--.-",
		"&": ".-...",
		":": "---...",
		";": "-.-.-.",
		"=": "-...-",
		"+": ".-.-.",
		"-": "-....-",
		"_": "..--.-",
		"\"": ".-..-.",
		"$": "...-..-",
		"@": ".--.-.",
	]
	
	public func getCode(for character: Character) -> MorseCode.Word.Letter? {
		
		let text = String(character)
		if let codeString = self.alphabetDictionary[text.uppercased()] ?? self.numberDictionary[text] ?? self.punctuationDictionary[text] {
			return MorseCode.Word.Letter(codeString: codeString)
			
		} else {
			return nil
		}
		
	}
	
}

extension MorseCode.Word.Letter {
	
	fileprivate init(codeString: String) {
		
		let codes = codeString.map { (codeCharacter) -> MorseCode.Unit.Code in
			guard let code = MorseCode.Unit.Code(codeCharacter) else {
				fatalError("Invalid code string")
			}
			return code
		}
		
		self.codes = codes
		
	}
	
}
