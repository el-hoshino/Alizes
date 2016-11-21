//
//  BaudotCodeDictionary.swift
//  Alizes
//
//  Created by 史　翔新 on 2016/11/21.
//  Copyright © 2016年 net.crazism. All rights reserved.
//

import Foundation

struct BaudotCodeDictionary {
	
	let lettersDictionary: [String: BaudotCode.Code.Letters] = [
		"A": .a,
		"B": .b,
		"C": .c,
		"D": .d,
		"E": .e,
		"F": .f,
		"G": .g,
		
		"H": .h,
		"I": .i,
		"J": .j,
		"K": .k,
		"L": .l,
		"M": .m,
		"N": .n,
		
		"O": .o,
		"P": .p,
		"Q": .q,
		"R": .r,
		"S": .s,
		"T": .t,
		
		"U": .u,
		"V": .v,
		"W": .w,
		"X": .x,
		"Y": .y,
		"Z": .z,
		
		" ": .space,
	]
	
	let figuresDictionary: [String: BaudotCode.Code.Figures] = [
		"0": .zero,
		"1": .one,
		"2": .two,
		"3": .three,
		"4": .four,
		"5": .five,
		"6": .six,
		"7": .seven,
		"8": .eight,
		"9": .nine,
		
		"(": .bracketLeft,
		")": .bracketRight,
		"/": .slash,
		":": .colon,
		"&": .ampersand,
		"'": .apostrophe,
		
		",": .comma,
		".": .period,
		"?": .question,
		"!": .exclamation,
		
		"£": .currency,
		"+": .plus,
		"-": .minus,
		"=": .equals,
		" ": .space,
	]
	
	public func getCodeFromLetters(for character: Character) -> BaudotCode.Code.Letters? {
		
		let text = String(character).uppercased()
		return self.lettersDictionary[text]
		
	}
	
	public func getCodeFromFigures(for character: Character) -> BaudotCode.Code.Figures? {
		
		let text = String(character)
		return self.figuresDictionary[text]
		
	}
	
}
