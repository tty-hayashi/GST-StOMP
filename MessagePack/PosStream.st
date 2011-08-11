Eval [
    'From Squeak4.2 of 4 February 2011 [latest update: #10966] on 8 August 2011 at 3:52:48 pm'
]



PositionableStream extend [

    boolean [
	"Answer the next boolean value from this (binary) stream."

	<category: 'data get/put'>
	^self next ~= 0
    ]

    boolean: aBoolean [
	"Store the given boolean value on this (binary) stream."

	<category: 'data get/put'>
	self nextPut: (aBoolean ifTrue: [1] ifFalse: [0])
    ]

    int16 [
	"Answer the next signed, 16-bit integer from this (binary) stream."

	<category: 'data get/put'>
	| n |
	n := self next.
	n := (n bitShift: 8) + self next.
	n >= 32768 ifTrue: [n := n - 65536].
	^n
    ]

    int16: anInteger [
	"Store the given signed, 16-bit integer on this (binary) stream."

	<category: 'data get/put'>
	| n |
	anInteger < -32768 | (anInteger >= 32768) 
	    ifTrue: [self error: 'outside 16-bit integer range'].
	anInteger < 0 ifTrue: [n := 65536 + anInteger] ifFalse: [n := anInteger].
	self nextPut: (n digitAt: 2).
	self nextPut: (n digitAt: 1)
    ]

    int32 [
	"Answer the next signed, 32-bit integer from this (binary) stream."

	"Details: As a fast check for negative number, check the high bit of the first digit"

	<category: 'data get/put'>
	| n firstDigit |
	n := firstDigit := self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	firstDigit >= 128 ifTrue: [n := -4294967296 + n].	"decode negative 32-bit integer"
	^n
    ]

    int32: anInteger [
	"Store the given signed, 32-bit integer on this (binary) stream."

	<category: 'data get/put'>
	| n |
	anInteger < -2147483648 | (anInteger >= 2147483648) 
	    ifTrue: [self error: 'outside 32-bit integer range'].
	anInteger < 0 
	    ifTrue: [n := 4294967296 + anInteger]
	    ifFalse: [n := anInteger].
	self nextPut: (n digitAt: 4).
	self nextPut: (n digitAt: 3).
	self nextPut: (n digitAt: 2).
	self nextPut: (n digitAt: 1)
    ]

    string [
	"Answer the next string from this (binary) stream."

	<category: 'data get/put'>
	| size |
	size := self uint16.
	^(self next: size) asString
    ]

    string: aString [
	"Store the given string on this (binary) stream. The string must contain 65535 or fewer characters."

	<category: 'data get/put'>
	aString size > 65535 
	    ifTrue: [self error: 'string too long for this format'].
	self uint16: aString size.
	self nextPutAll: aString asByteArray
    ]

    uint16 [
	"Answer the next unsigned, 16-bit integer from this (binary) stream."

	<category: 'data get/put'>
	| n |
	n := self next.
	n := (n bitShift: 8) + self next.
	^n
    ]

    uint16: anInteger [
	"Store the given unsigned, 16-bit integer on this (binary) stream."

	<category: 'data get/put'>
	anInteger < 0 | (anInteger >= 65536) 
	    ifTrue: [self error: 'outside unsigned 16-bit integer range'].
	self nextPut: (anInteger digitAt: 2).
	self nextPut: (anInteger digitAt: 1)
    ]

    uint24 [
	"Answer the next unsigned, 24-bit integer from this (binary) stream."

	<category: 'data get/put'>
	| n |
	n := self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	^n
    ]

    uint24: anInteger [
	"Store the given unsigned, 24-bit integer on this (binary) stream."

	<category: 'data get/put'>
	anInteger < 0 | (anInteger >= 16777216) 
	    ifTrue: [self error: 'outside unsigned 24-bit integer range'].
	self nextPut: (anInteger digitAt: 3).
	self nextPut: (anInteger digitAt: 2).
	self nextPut: (anInteger digitAt: 1)
    ]

    uint32 [
	"Answer the next unsigned, 32-bit integer from this (binary) stream."

	<category: 'data get/put'>
	| n |
	n := self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	^n
    ]

    uint32: anInteger [
	"Store the given unsigned, 32-bit integer on this (binary) stream."

	<category: 'data get/put'>
	anInteger < 0 | (anInteger >= 4294967296) 
	    ifTrue: [self error: 'outside unsigned 32-bit integer range'].
	self nextPut: (anInteger digitAt: 4).
	self nextPut: (anInteger digitAt: 3).
	self nextPut: (anInteger digitAt: 2).
	self nextPut: (anInteger digitAt: 1)
    ]

]

