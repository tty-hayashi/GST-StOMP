Eval [
    'From Squeak4.2 of 4 February 2011 [latest update: #10966] on 8 August 2011 at 10:30:22 am'
]



MpEncodeTypeMapper subclass: MpGSTEncodeTypeMapper [
    
    <comment: nil>
    <category: 'MessagePack-Squeak-Core'>

    MpGSTEncodeTypeMapper class >> defineDoubleActionTo: map [
	<category: 'actions for primitives'>
	map at: FloatD put: #writeDouble:
    ]

    defineFloatActionTo: map [
	"Suppose 32 bit float - Some dialect does not support it"
	map at: FloatE put: #writeFloat:
    ]
]



MpPortableUtil subclass: MpGSTPortableUtil [
    
    <comment: nil>
    <category: 'MessagePack-Squeak-Core'>

    MpGSTPortableUtil class >> initialize [
	"MpGSTPortableUtil initialize"

	<category: 'class initialization'>
	super initialize.
	MpPortableUtil dialectSpecificClass: self
    ]

    encodeTypeMapperClass [
	<category: 'factory'>
	^MpGSTEncodeTypeMapper
    ]

    readDoubleFrom: stream [
	<category: 'actions-stream'>
	^stream nextDouble
    ]

    readFloatFrom: stream [
	"32 bit"
	<category: 'actions-stream'>

	^stream nextFloat
    ]

    readInt16From: stream [
	<category: 'actions-stream'>
	^stream nextShort
    ]

    readInt32From: stream [
	<category: 'actions-stream'>
	^stream nextLong
    ]

    readInt64From: stream [
	<category: 'actions-stream'>
	^stream nextLongLong
    ]

    readUint16From: stream [
	<category: 'actions-stream'>
	^stream nextUshort
    ]

    readUint32From: stream [
	<category: 'actions-stream'>
	^stream nextUlong
    ]

    readUint64From: stream [
	<category: 'actions-stream'>
	^stream nextUint64
    ]

    writeDouble: value to: stream [
	<category: 'actions-stream'>
	stream nextPutDouble: value
    ]

    writeFloat: value to: stream [
	<category: 'actions-stream'>
	stream nextPutFloat: value
    ]

    writeInt16: value to: stream [
	<category: 'actions-stream'>
	(value < -16r8000) | (value >= 16r8000)
		ifTrue: [self error: 'outside 16-bit integer range'].

	stream nextPutShort: value
    ]

    writeUint16: value to: stream [
	<category: 'actions-stream'>
	(value < 0) | (value >= 16r10000)
		ifTrue: [self error: 'outside unsigned 16-bit integer range'].

	stream nextPutShort: value
    ]

    writeInt32: value to: stream [
	<category: 'actions-stream'>

	(value < -16r80000000) | (value >= 16r80000000)
		ifTrue: [self error: 'outside 32-bit integer range'].
	stream nextPutLong: value
    ]

    writeUint32: value to: stream [
	<category: 'actions-stream'>

	(value < 0) | (value >= 16r100000000)
		ifTrue: [self error: 'outside unsigned 32-bit integer range'].
	stream nextPutLong: value
    ]

    writeInt64: value to: stream [
	<category: 'actions-stream'>

	(value < -16r8000000000000000) | (value >= 16r8000000000000000)
		ifTrue: [self error: 'outside 64-bit integer range'].
	stream nextPutInt64: value
    ]

    writeUint64: value to: stream [
	<category: 'actions-stream'>

	(value < 0) | (value >= 16r10000000000000000)
		ifTrue: [self error: 'outside unsigned 64-bit integer range'].
	stream nextPutInt64: value
    ]
]


SmallInteger extend [

    digitAt: n [
	"Answer the value of an indexable field in the receiver.  LargePositiveInteger uses bytes of base two number, and each is a 'digit' base 256.  Fail if the argument (the index) is not an Integer or is out of bounds."
	<category: 'built-ins'>
	n>8 ifTrue: [^ 0].
	self < 0
		ifTrue: [self = SmallInteger smallest ifTrue:
			    ["Can't negate minVal -- treat specially"
			     ^ #(0 0 0 0 0 0 0 64) at: n].
			 ^ ((0-self) bitShift: (1-n)*8) bitAnd: 16rFF]
		ifFalse: [^ (self bitShift: (1-n)*8) bitAnd: 16rFF]
    ]
]


Stream extend [
    nextByte [
	"It's a clone code from FileDiscreptor class."
	"Return the next byte in the stream, or nil at end"

	<category: 'basic'>
	| a |
	a := self next.
	^a isNil ifTrue: [a] ifFalse: [a asInteger]
    ]

    nextDouble [
	"It's a clone code from FileDiscreptor class."
	"Return the next 64-bit float in the byte array"

	<category: 'binary I/O'>

	| newValue |
	newValue := (FloatD new: 8).
	1 to: 8 do: [:n | newValue at: n put: self next].
	^newValue
    ]

    nextFloat [
	"It's a clone code from FileDiscreptor class."
	"Return the next 32-bit float in the byte array"

	<category: 'binary I/O'>
	| newValue |
	newValue := (FloatE new: 4).
	1 to: 4 do: [:n |newValue at: n put: self nextByte].
	^newValue
    ]

    nextBytes: n signed: signed [
	"It's a clone code from FileDiscreptor class."
	"Private - Get an integer out of the next anInteger bytes in the stream"

	<category: 'private'>
	| int msb |
	int := 0.
	0 to: n * 8 - 16
	    by: 8
	    do: [:i | int := int + (self nextByte bitShift: i)].
	msb := self nextByte.
	(signed and: [msb > 127]) ifTrue: [msb := msb - 256].
	^int + (msb bitShift: n * 8 - 8)
    ]

    nextShort [
	"It's a clone code from FileDiscreptor class."
	"Return the next 2 bytes in the byte array, interpreted as a 16 bit signed int"

	<category: 'binary I/O'>
	^self nextBytes: 2 signed: true
    ]

    nextLong [
	"It's a clone code from FileDiscreptor class."
	"Return the next 4 bytes in the byte array, interpreted as a 32 bit signed int"

	<category: 'binary I/O'>
	^self nextBytes: 4 signed: true
    ]

    nextLongLong [
	"It's a clone code from FileDiscreptor class."
	"Return the next 8 bytes in the byte array, interpreted as a 64 bit signed int"

	<category: 'binary I/O'>
	^self nextBytes: 8 signed: true
    ]

    nextUshort [
	"It's a clone code from FileDiscreptor class."
	"Return the next 2 bytes in the byte array, interpreted as a 16 bit unsigned int"

	<category: 'binary I/O'>
	^self nextBytes: 2 signed: false
    ]

    nextUlong [
	"It's a clone code from FileDiscreptor class."
	"Return the next 4 bytes in the byte array, interpreted as a 32 bit unsigned int"

	<category: 'binary I/O'>
	^self nextBytes: 4 signed: false
    ]

    nextUint64 [
	"It's a clone code from FileDiscreptor class."
	"Return the next 8 bytes in the byte array, interpreted as a 64 bit unsigned int"

	<category: 'binary I/O'>
	^self nextBytes: 8 signed: false
    ]

    nextPutDouble: aDouble [
	"It's a clone code from FileDiscreptor class."
	"Store aDouble as a 64-bit float in the byte array"

	<category: 'binary I/O'>
	| d |
	d := aDouble asFloatD.
	self nextPutByte: (d at: 1).
	self nextPutByte: (d at: 2).
	self nextPutByte: (d at: 3).
	self nextPutByte: (d at: 4).
	self nextPutByte: (d at: 5).
	self nextPutByte: (d at: 6).
	self nextPutByte: (d at: 7).
	self nextPutByte: (d at: 8)
    ]

    nextPutFloat: aFloat [
	"It's a clone code from FileDiscreptor class."
	"Return the next 32-bit float in the byte array"

	<category: 'binary I/O'>
	| f |
	f := aFloat asFloatE.
	self nextPutByte: (f at: 1).
	self nextPutByte: (f at: 2).
	self nextPutByte: (f at: 3).
	self nextPutByte: (f at: 4)
    ]

    nextPutByte: anInteger [
	"It's a clone code from FileDiscreptor class."
	"Store anInteger (range: -128..255) on the byte array"

	<category: 'binary I/O'>
	| int |
	int := anInteger.
	int := anInteger < 0 
		    ifTrue: [anInteger negated - 1 bitXor: 255]
		    ifFalse: [anInteger].
	^self nextPut: (int bitAnd: 255)
    ]

    nextPutBytes: n of: anInteger [
	"It's a clone code from FileDiscreptor class."
	"Private - Store the n least significant bytes of int in little-endian format"

	<category: 'private'>
	| int |
	int := anInteger.
	n timesRepeat: 
		[self nextPutByte: (int bitAnd: 255).
		int := int bitShift: -8.
		(int = 0 and: [anInteger < 0]) ifTrue: [int := 255]]
    ]

    nextPutInt64: anInteger [
	"It's a clone code from FileDiscreptor class."
	"Store anInteger (range: -2^63..2^64-1) on the byte array as 4 bytes"

	<category: 'binary I/O'>
	self nextPutBytes: 8 of: anInteger
    ]

    nextPutLong: anInteger [
	"It's a clone code from FileDiscreptor class."
	"Store anInteger (range: -2^31..2^32-1) on the byte array as 4 bytes"

	<category: 'binary I/O'>
	self nextPutBytes: 4 of: anInteger
    ]

    nextPutShort: anInteger [
	"It's a clone code from FileDiscreptor class."
	"Store anInteger (range: -32768..65535) on the byte array as 2 bytes"

	<category: 'binary I/O'>
	self nextPutBytes: 2 of: anInteger
    ]

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

    string [
	"Answer the next string from this (binary) stream."

	<category: 'data get/put'>
	| size |
	size := self nextUshort.
	^(self next: size) asString
    ]

    string: aString [
	"Store the given string on this (binary) stream. The string must contain 65535 or fewer characters."

	<category: 'data get/put'>
	aString size > 65535 
	    ifTrue: [self error: 'string too long for this format'].
	self nextPutShort: aString size.
	self nextPutAll: aString asByteArray
    ]

]


Eval [
    MpGSTPortableUtil initialize
]

