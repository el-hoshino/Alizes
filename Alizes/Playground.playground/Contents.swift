//: Playground - noun: a place where people can play

import UIKit
import Alizes

let str = "Hello playground"

let morse = MorseCode(str)
let baudot = BaudotCode(str)

print(morse)
print(baudot)
