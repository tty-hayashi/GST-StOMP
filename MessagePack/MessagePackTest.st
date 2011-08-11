Eval [
    'From Squeak4.2 of 4 February 2011 [latest update: #10966] on 8 August 2011 at 10:30:25 am'
]



TestCase subclass: MpTestCase [
    
    <comment: nil>
    <category: 'MessagePackTest-Core'>

    atRandom: integer [
	"For portability"

	<category: 'private'>
	^(MpPortableUtil default randomClass new next * integer) truncated + 1
    ]

    collectionEquals: aCollection with: otherCollection [
	<category: 'private'>
	^MpPortableUtil default collectionEquals: aCollection with: otherCollection
    ]

    newCollection: aCollectionClass sized: size withAll: elem [
	<category: 'private'>
	^MpPortableUtil default 
	    newCollection: aCollectionClass
	    sized: size
	    withAll: elem
    ]
]



MpTestCase subclass: MpPackUnpackTestCase [
    
    <comment: nil>
    <category: 'MessagePackTest-Core'>

    complexArraysArray [
	<category: 'fixtures'>
	^self complexCollectionSizes 
	    collect: [:each | self createComplexArraySized: each]
    ]

    complexMapsArray [
	<category: 'fixtures'>
	^self complexCollectionSizes 
	    collect: [:each | self createComplexMapSized: each]
    ]

    floatsArray [
	<category: 'fixtures'>
	^#(3.14159 3.141592653589793)
    ]

    integersArray [
	<category: 'fixtures'>
	^ #(0 1 126 127 -1 -2 -31 -32 -128 -33 -32768 -129 128 32767 -2147483648 -32769 32768 2147483647 -9223372036854775808 -2147483649 2147483648 9223372036854775807 )
    ]

    rawBytesArray [
	<category: 'fixtures'>
	^self rawBytesSizes collect: [:each | self createRawBytesSized: each]
    ]

    simpleArraysArray [
	<category: 'fixtures'>
	^self simpleCollectionSizes 
	    collect: [:each | self createSimpleArraySized: each]
    ]

    simpleMapsArray [
	<category: 'fixtures'>
	^self simpleCollectionSizes 
	    collect: [:each | self createSimpleMapSized: each]
    ]

    complexCollectionSizes [
	<category: 'private'>
	^#(0 1 31 32)	"For avoiding timeout"
    ]

    createArraySized: size [
	<category: 'private'>
	| col idx |
	col := OrderedCollection withAll: #(true false nil 1 -1 3.14 -3.14).
	"col add: (ByteArray new: 100 withAll: 100).
	col add: (Array new: 200 withAll: #(2)).
	col add: (Dictionary new at: 3 put: 333; yourself)."
	idx := self atRandom: col size.
	^self newCollection: Array sized: size withAll: (col at: idx)
    ]

    createSimpleArraySized: size [
	<category: 'private'>
	| col idx |
	col := OrderedCollection withAll: #(true false nil 1 -1 3.14 -3.14).
	idx := self atRandom: col size.
	^self newCollection: Array sized: size withAll: (col at: idx)
    ]

    createComplexArraySized: size [
	<category: 'private'>
	| col dict |
	col := OrderedCollection new.
	col add: (self 
		    newCollection: ByteArray
		    sized: 100
		    withAll: 100).
	col add: (self 
		    newCollection: Array
		    sized: 200
		    withAll: #(2)).
	col add: ((Dictionary new)
		    at: 3 put: 333;
		    yourself).
	dict := Dictionary new: size.
	1 to: size
	    do: [:idx | dict at: idx printString asByteArray put: (self atRandom: col size)].
	^dict
    ]

    createSimpleMapSized: size [
	<category: 'private'>
	| values dic |
	values := #(true false nil 1 -1 3.14 -3.14).
	dic := Dictionary new: size.
	1 to: size do: [:idx | dic at: idx put: (values at: (idx - 1 \\ values size + 1))].
	^dic
    ]

    createComplexMapSized: size [
	<category: 'private'>
	| col idx |
	col := OrderedCollection new.
	col add: (self 
		    newCollection: ByteArray
		    sized: 100
		    withAll: 100).
	col add: (self 
		    newCollection: Array
		    sized: 200
		    withAll: #(2)).
	col add: ((Dictionary new)
		    at: 3 put: 333;
		    yourself).
	idx := self atRandom: col size.
	^Array new: size withAll: (col at: idx)
    ]

    createRawBytesSized: size [
	<category: 'private'>
	^self 
	    newCollection: ByteArray
	    sized: size
	    withAll: (self atRandom: 255)
    ]

    mapSizes [
	<category: 'private'>
	^#(0 1 31 32 65535 65536)
    ]

    rawBytesSizes [
	<category: 'private'>
	^#(0 1 31 32 65535 65536)
    ]

    simpleCollectionSizes [
	<category: 'private'>
	^#(0 1 31 32 65535 65536)
    ]

    testPackUnpackArray [
	"self debug: #testPackUnpackArray"

	<category: 'testing'>
	self simpleArraysArray do: 
		[:each | 
		| packed unpacked e p u|
		packed := each messagePacked.
		self should: [packed isMemberOf: ByteArray].
		unpacked := Object fromMessagePack: packed.
		self should: [self collectionEquals: unpacked with: each]]
    ]

    testPackUnpackComplexArray [
	"self debug: #testPackUnpackComplexArray"

	<category: 'testing'>
	self complexArraysArray do: 
		[:each | 
		| packed unpacked |
		packed := each messagePacked.
		self should: [packed isMemberOf: ByteArray].
		unpacked := Object fromMessagePack: packed.
		self should: [self collectionEquals: unpacked with: each]]
    ]

    testPackUnpackComplexMap [
	"self debug: #testPackUnpackComplexMap"

	<category: 'testing'>
	self simpleMapsArray do: 
		[:each | 
		| packed unpacked |
		packed := each messagePacked.
		self should: [packed isMemberOf: ByteArray].
		unpacked := Object fromMessagePack: packed.
		self should: [self collectionEquals: unpacked with: each]]
    ]

    testPackUnpackFalse [
	"self debug: #testPackUnpackFalse"

	<category: 'testing'>
	| packed unpacked |
	packed := false messagePacked.
	self should: [packed isMemberOf: ByteArray].
	self should: [packed = (ByteArray with: MpConstants falseValue)].
	unpacked := Object fromMessagePack: packed.
	self should: [unpacked = false]
    ]

    testPackUnpackFloatingPoint [
	"self debug: #testPackUnpackFloatingPoint"

	<category: 'testing'>
	self floatsArray do: 
		[:each | 
		| packed unpacked |
		packed := each messagePacked.
		self should: [packed isMemberOf: ByteArray].
		unpacked := Object fromMessagePack: packed.
		self should: [unpacked = each]]
    ]

    testPackUnpackInteger [
	"self debug: #testPackUnpackInteger"

	<category: 'testing'>
	self integersArray do: 
		[:each | 
		| packed unpacked |
		packed := each messagePacked.
		self should: [packed isMemberOf: ByteArray].
		unpacked := Object fromMessagePack: packed.
		self should: [unpacked = each]]
    ]

    testPackUnpackMap [
	"self debug: #testPackUnpackMap"

	<category: 'testing'>
	self simpleMapsArray do: 
		[:each | 
		| packed unpacked |
		packed := each messagePacked.
		self should: [packed isMemberOf: ByteArray].
		unpacked := Object fromMessagePack: packed.
		self should: [self collectionEquals: unpacked with: each]]
    ]

    testPackUnpackNil [
	"self debug: #testPackUnpackNil"

	<category: 'testing'>
	| packed unpacked |
	packed := nil messagePacked.
	self should: [packed isMemberOf: ByteArray].
	self should: [packed = (ByteArray with: MpConstants nilValue)].
	unpacked := Object fromMessagePack: packed.
	self should: [unpacked = nil]
    ]

    testPackUnpackRawBytes [
	"self debug: #testPackUnpackRawBytes"

	<category: 'testing'>
	self rawBytesArray do: 
		[:each | 
		| packed unpacked |
		packed := each messagePacked.
		self should: [packed isMemberOf: ByteArray].
		unpacked := Object fromMessagePack: packed.
		self should: [self collectionEquals: unpacked with: each]]
    ]

    testPackUnpackTrue [
	"self debug: #testPackUnpackTrue"

	<category: 'testing'>
	| packed unpacked |
	packed := true messagePacked.
	self should: [packed isMemberOf: ByteArray].
	self should: [packed = (ByteArray with: MpConstants trueValue)].
	unpacked := Object fromMessagePack: packed.
	self should: [unpacked = true]
    ]
]

