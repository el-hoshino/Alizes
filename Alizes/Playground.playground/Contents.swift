//: Playground - noun: a place where people can play

import UIKit
import Alizes

let str = "Hello, World!"

let morse = MorseCode(str)
let baudot = BaudotCode(str)

print(morse)
print(morse.initializedString)
print(morse.binaryCodeContainer)

print()

print(baudot)
print(baudot.binaryCodeContainer)
print(baudot.initializedString)
