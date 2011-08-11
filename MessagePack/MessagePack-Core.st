Eval [
    'From Squeak4.2 of 4 February 2011 [latest update: #10966] on 8 August 2011 at 10:30:19 am'
]



Object subclass: MpConstants [
    
    <category: 'MessagePack-Core'>
    <comment: nil>

    MpConstants class >> array16 [
	<category: 'typecodes'>
	^16rDC
    ]

    MpConstants class >> array32 [
	<category: 'typecodes'>
	^16rDD
    ]

    MpConstants class >> double [
	<category: 'typecodes'>
	^16rCB
    ]

    MpConstants class >> falseValue [
	<category: 'typecodes'>
	^16rC2
    ]

    MpConstants class >> float [
	<category: 'typecodes'>
	^16rCA
    ]

    MpConstants class >> int16 [
	<category: 'typecodes'>
	^16rD1
    ]

    MpConstants class >> int32 [
	<category: 'typecodes'>
	^16rD2
    ]

    MpConstants class >> int64 [
	<category: 'typecodes'>
	^16rD3
    ]

    MpConstants class >> int8 [
	<category: 'typecodes'>
	^16rD0
    ]

    MpConstants class >> map16 [
	<category: 'typecodes'>
	^16rDE
    ]

    MpConstants class >> map32 [
	<category: 'typecodes'>
	^16rDF
    ]

    MpConstants class >> nilValue [
	<category: 'typecodes'>
	^16rC0
    ]

    MpConstants class >> raw16 [
	<category: 'typecodes'>
	^16rDA
    ]

    MpConstants class >> raw32 [
	<category: 'typecodes'>
	^16rDB
    ]

    MpConstants class >> trueValue [
	<category: 'typecodes'>
	^16rC3
    ]

    MpConstants class >> uint16 [
	<category: 'typecodes'>
	^16rCD
    ]

    MpConstants class >> uint32 [
	<category: 'typecodes'>
	^16rCE
    ]

    MpConstants class >> uint64 [
	<category: 'typecodes'>
	^16rCF
    ]

    MpConstants class >> uint8 [
	<category: 'typecodes'>
	^16rCC
    ]
]



Object subclass: MpDecoder [
    | readStream typeMapper settings |
    
    <category: 'MessagePack-Core'>
    <comment: nil>

    MpDecoder class >> decode: byteArray [
	<category: 'actions'>
	^self new decode: byteArray
    ]

    MpDecoder class >> decodeFrom: aStream [
	<category: 'actions'>
	^self new decodeFrom: aStream
    ]

    MpDecoder class >> on: aStream [
	<category: 'actions'>
	^self new readStream: aStream	"binary"
    ]

    MpDecoder class >> onBytes: byteArray [
	<category: 'actions'>
	^self on: (ReadStream on: byteArray)
    ]

    atEnd [
	<category: 'stream-like'>
	^self readStream atEnd
    ]

    next [
	<category: 'stream-like'>
	^self read
    ]

    createArray: size [
	<category: 'factory'>
	^Array new: size
    ]

    createDictionary: size [
	<category: 'factory'>
	^Dictionary new: size
    ]

    createOrderedCollection: size [
	<category: 'factory'>
	^OrderedCollection new: size
    ]

    settingsClass [
	<category: 'factory'>
	^MpSettings
    ]

    typeMapperClass [
	<category: 'factory'>
	^MpDecodeTypeMapper
    ]

    decode [
	<category: 'decoding'>
	self readStream atEnd ifTrue: [^self signalError: 'No data to read'].
	^self read
    ]

    decode: byteArray [
	<category: 'decoding'>
	^self decodeFrom: byteArray readStream
    ]

    decodeFrom: aStream [
	<category: 'decoding'>
	self readStream: aStream.	"binary"
	^self decode
    ]

    read [
	<category: 'reading'>
	^self readObject
    ]

    readArray16 [
	<category: 'reading'>
	| size |
	size := MpPortableUtil default readUint16From: self readStream.
	^self readArraySized: size
    ]

    readArray32 [
	<category: 'reading'>
	| size |
	size := MpPortableUtil default readUint32From: self readStream.
	^self readArraySized: size
    ]

    readDouble [
	"64 bit"

	<category: 'reading'>
	^MpPortableUtil default readDoubleFrom: self readStream
    ]

    readFalse [
	<category: 'reading'>
	^false
    ]

    readFixArray: firstByte [
	<category: 'reading'>
	| size |
	size := firstByte bitAnd: 15.
	^self readArraySized: size
    ]

    readFixMap: firstByte [
	<category: 'reading'>
	| size |
	size := firstByte bitAnd: 15.
	^self readMapSized: size
    ]

    readFixRaw: firstByte [
	<category: 'reading'>
	| size |
	size := firstByte bitAnd: 31.
	^self readStream next: size
    ]

    readFloat [
	"32 bit"

	<category: 'reading'>
	^MpPortableUtil default readFloatFrom: self readStream
    ]

    readMap16 [
	<category: 'reading'>
	| size |
	size := MpPortableUtil default readUint16From: self readStream.
	^self readMapSized: size
    ]

    readMap32 [
	<category: 'reading'>
	| size |
	size := MpPortableUtil default readUint32From: self readStream.
	^self readMapSized: size
    ]

    readNegativeFixNum: firstByte [
	<category: 'reading'>
	| val |
	val := firstByte bitAnd: 31.
	^val - 32
    ]

    readNil [
	<category: 'reading'>
	^nil
    ]

    readPositiveFixNum: firstByte [
	"0 - 127"

	<category: 'reading'>
	^firstByte
    ]

    readRaw16 [
	<category: 'reading'>
	| size |
	size := MpPortableUtil default readUint16From: self readStream.
	^self readStream next: size
    ]

    readRaw32 [
	<category: 'reading'>
	| size |
	size := MpPortableUtil default readUint32From: self readStream.
	^self readStream next: size
    ]

    readTrue [
	<category: 'reading'>
	^true
    ]

    readArraySized: size [
	<category: 'reading-helper'>
	| array |
	array := self createArray: size.
	1 to: size do: [:idx | array at: idx put: self readObject].
	^array
    ]

    readMapSized: size [
	<category: 'reading-helper'>
	| dic |
	dic := self createDictionary: size.
	1 to: size do: [:idx | dic at: self readObject put: self readObject].
	^dic
    ]

    readType [
	<category: 'reading-helper'>
	^self readStream next
    ]

    readInt16 [
	<category: 'reading-integer'>
	^MpPortableUtil default readInt16From: self readStream
    ]

    readInt32 [
	<category: 'reading-integer'>
	^MpPortableUtil default readInt32From: self readStream
    ]

    readInt64 [
	<category: 'reading-integer'>
	^MpPortableUtil default readInt64From: self readStream
    ]

    readInt8 [
	<category: 'reading-integer'>
	| val |
	val := self readStream next.
	val >= 128 ifTrue: [^(256 - val) negated].
	^val
    ]

    readUint16 [
	<category: 'reading-integer'>
	^MpPortableUtil default readUint16From: self readStream
    ]

    readUint32 [
	<category: 'reading-integer'>
	^MpPortableUtil default readUint32From: self readStream
    ]

    readUint64 [
	<category: 'reading-integer'>
	^MpPortableUtil default readUint64From: self readStream
    ]

    readUint8 [
	<category: 'reading-integer'>
	^self readStream next
    ]

    readObject [
	<category: 'dispatching'>
	| type |
	type := self readType.
	^self readObjectOf: type
    ]

    readObjectOf: type [
	<category: 'dispatching'>
	^self readObjectOf: type ifNotApplied: [self signalError]
    ]

    readObjectOf: type ifNotApplied: aBlock [
	<category: 'dispatching'>
	type <= 16rBF 
	    ifTrue: 
		[| fixMapOrArray |
		type <= 16r7F ifTrue: [^self readPositiveFixNum: type].
		fixMapOrArray := type bitShift: -4.
		fixMapOrArray = 2r1000 ifTrue: [^self readFixMap: type].
		fixMapOrArray = 2r1001 ifTrue: [^self readFixArray: type].
		^self readFixRaw: type].
	(type bitShift: -5) = 2r111 ifTrue: [^self readNegativeFixNum: type].
	^self typeMapper readObjectOf: type ifNotApplied: aBlock
    ]

    readStream [
	"Answer the value of readStream"

	<category: 'accessing'>
	^readStream
    ]

    readStream: anObject [
	"Set the value of readStream"

	<category: 'accessing'>
	readStream := anObject
    ]

    settings [
	<category: 'accessing'>
	^settings ifNil: [settings := self settingsClass new]
    ]

    typeMapper [
	<category: 'accessing'>
	^typeMapper ifNil: [typeMapper := self typeMapperClass on: self]
    ]

    signalError [
	<category: 'signaling error'>
	self signalError: 'Cannot decode'
    ]

    signalError: message [
	<category: 'signaling error'>
	^MpPortableUtil default 
	    signalException: (MpError decode messageText: message)
    ]
]



Object subclass: MpEncoder [
    | writeStream typeMapper settings |
    
    <category: 'MessagePack-Core'>
    <comment: nil>

    MpEncoder class >> encode: anObject [
	<category: 'actions'>
	^self new encode: anObject
    ]

    MpEncoder class >> encode: anObject on: aStream [
	<category: 'actions'>
	^self new encode: anObject on: aStream
    ]

    MpEncoder class >> on: aStream [
	<category: 'actions'>
	^(self new)
	    writeStream: aStream;
	    yourself
    ]

    MpEncoder class >> onBytes: byteArray [
	<category: 'actions'>
	^self on: (WriteStream on: byteArray)
    ]

    contents [
	<category: 'accessing'>
	^self writeStream contents
    ]

    settings [
	<category: 'accessing'>
	^settings ifNil: [settings := self settingsClass new]
    ]

    typeMapper [
	<category: 'accessing'>
	^typeMapper ifNil: [typeMapper := self typeMapperClass on: self]
    ]

    typeMapperClass [
	<category: 'accessing'>
	^MpPortableUtil default encodeTypeMapperClass
    ]

    writeStream [
	<category: 'accessing'>
	writeStream isNil 
	    ifTrue: 
		[writeStream := WriteStream 
			    on: (ByteArray new: self settings defaultStreamSize)].
	^writeStream
    ]

    writeStream: anObject [
	"Set the value of writeStream"

	<category: 'accessing'>
	writeStream := anObject
    ]

    encode: anObject [
	<category: 'encoding'>
	^self encode: anObject on: self writeStream
    ]

    encode: anObject on: aStream [
	<category: 'encoding'>
	self write: anObject on: aStream.
	^self contents
    ]

    write: anObject on: aStream [
	<category: 'encoding'>
	self writeStream: aStream.	"binary"
	self writeObject: anObject
    ]

    nextPut: anObject [
	<category: 'stream-like'>
	self writeObject: anObject
    ]

    nextPutAll: aCollection [
	<category: 'stream-like'>
	aCollection do: [:each | self nextPut: each]
    ]

    settingsClass [
	<category: 'factory'>
	^MpSettings
    ]

    signalError [
	<category: 'signaling error'>
	self signalError: 'Cannot encode'
    ]

    signalError: message [
	<category: 'signaling error'>
	^MpPortableUtil default 
	    signalException: (MpError encode messageText: message)
    ]

    writeArray: array [
	<category: 'writing'>
	| size |
	size := array size.
	self writeArraySize: size.
	array do: [:each | self writeObject: each]
    ]

    writeDouble: aFloat [
	<category: 'writing'>
	self writeStream nextPut: MpConstants double.
	MpPortableUtil default writeDouble: aFloat to: self writeStream
    ]

    writeFalse: ignore [
	<category: 'writing'>
	self writeStream nextPut: MpConstants falseValue
    ]

    writeFloat: aFloat [
	<category: 'writing'>
	self writeStream nextPut: MpConstants float.
	MpPortableUtil default writeFloat: aFloat to: self writeStream
    ]

    writeInteger: anInteger [
	<category: 'writing'>
	(anInteger between: 0 and: 127) 
	    ifTrue: [^self writePositiveFixNum: anInteger].
	(anInteger between: -32 and: -1) 
	    ifTrue: [^self writeNegativeFixNum: anInteger].
	anInteger >= 128 
	    ifTrue: 
		[anInteger <= 255 ifTrue: [^self writeUint8: anInteger].
		anInteger <= 65535 ifTrue: [^self writeUint16: anInteger].
		anInteger <= 4294967295 ifTrue: [^self writeUint32: anInteger].
		anInteger <= 18446744073709551615 ifTrue: [^self writeUint64: anInteger]].
	anInteger >= -128 ifTrue: [^self writeInt8: anInteger].
	anInteger >= -32768 ifTrue: [^self writeInt16: anInteger].
	anInteger >= -2147483648 ifTrue: [^self writeInt32: anInteger].
	anInteger >= -9223372036854775808 ifTrue: [^self writeInt64: anInteger].
	self signalError
    ]

    writeMap: aDictionary [
	<category: 'writing'>
	| size |
	size := aDictionary size.
	self writeMapSize: size.
	aDictionary keysAndValuesDo: 
		[:key :value | 
		self
		    writeObject: key;
		    writeObject: value]
    ]

    writeNil: ignore [
	<category: 'writing'>
	self writeStream nextPut: MpConstants nilValue
    ]

    writeRawBytes: bytes [
	<category: 'writing'>
	| size |
	size := bytes size.
	self writeRawBytesSize: size.
	self writeStream nextPutAll: bytes
    ]

    writeTrue: ignore [
	<category: 'writing'>
	self writeStream nextPut: MpConstants trueValue
    ]

    writeArraySize: size [
	<category: 'writing-helper'>
	size < 16r10 ifTrue: [^self writeStream nextPut: (2r10010000 bitOr: size)].
	size < 16r10000 
	    ifTrue: 
		[self writeStream nextPut: MpConstants array16.
		^MpPortableUtil default writeUint16: size to: self writeStream].
	size < 16r100000000
	    ifTrue: 
		[self writeStream nextPut: MpConstants array32.
		^MpPortableUtil default writeUint32: size to: self writeStream].
	self signalError
    ]

    writeInt16: value [
	<category: 'writing-helper'>
	self writeStream nextPut: MpConstants int16.
	MpPortableUtil default writeInt16: value to: self writeStream
    ]

    writeInt32: value [
	<category: 'writing-helper'>
	self writeStream nextPut: MpConstants int32.
	MpPortableUtil default writeInt32: value to: self writeStream
    ]

    writeInt64: value [
	<category: 'writing-helper'>
	self writeStream nextPut: MpConstants int64.
	MpPortableUtil default writeInt64: value to: self writeStream
    ]

    writeInt8: value [
	<category: 'writing-helper'>
	| val |
	self writeStream nextPut: MpConstants int8.
	val := value < 0 ifTrue: [256 + value] ifFalse: [value].
	self writeStream nextPut: val
    ]

    writeMapSize: size [
	<category: 'writing-helper'>
	size < 16r10 ifTrue: [^self writeStream nextPut: (2r10000000 bitOr: size)].
	size < 16r10000 
	    ifTrue: 
		[self writeStream nextPut: MpConstants map16.
		^MpPortableUtil default writeUint16: size to: self writeStream].
	size < 16r100000000
	    ifTrue: 
		[self writeStream nextPut: MpConstants map32.
		^MpPortableUtil default writeUint32: size to: self writeStream].
	self signalError
    ]

    writeNegativeFixNum: number [
	"-32 to -1"

	<category: 'writing-helper'>
	| val |
	val := 256 + number.
	self writeStream nextPut: val
    ]

    writePositiveFixNum: number [
	<category: 'writing-helper'>
	self writeStream nextPut: number
    ]

    writeRawBytesSize: size [
	<category: 'writing-helper'>
	size < 16r10 ifTrue: [^self writeStream nextPut: (2r10100000 bitOr: size)].
	size < 16r10000
	    ifTrue: 
		[self writeStream nextPut: MpConstants raw16.
		^MpPortableUtil default writeUint16: size to: self writeStream].
	size < 16r100000000
	    ifTrue: 
		[self writeStream nextPut: MpConstants raw32.
		^MpPortableUtil default writeUint32: size to: self writeStream].
	self signalError
    ]

    writeUint16: value [
	<category: 'writing-helper'>
	self writeStream nextPut: MpConstants uint16.
	MpPortableUtil default writeUint16: value to: self writeStream
    ]

    writeUint32: value [
	<category: 'writing-helper'>
	self writeStream nextPut: MpConstants uint32.
	MpPortableUtil default writeUint32: value to: self writeStream
    ]

    writeUint64: value [
	<category: 'writing-helper'>
	self writeStream nextPut: MpConstants uint64.
	MpPortableUtil default writeUint64: value to: self writeStream
    ]

    writeUint8: value [
	<category: 'writing-helper'>
	self writeStream nextPut: MpConstants uint8.
	self writeStream nextPut: value
    ]

    writeObject: anObject [
	<category: 'dispatching'>
	^self writeObject: anObject ifNotApplied: [self signalError]
    ]

    writeObject: anObject ifNotApplied: aBlock [
	<category: 'dispatching'>
	^self typeMapper writeObject: anObject ifNotApplied: aBlock
    ]
]



Error subclass: MpError [
    | type |
    
    <category: 'MessagePack-Core'>
    <comment: nil>

    MpError class >> decode [
	<category: 'instance creation'>
	^self new type: #decode
    ]

    MpError class >> encode [
	<category: 'instance creation'>
	^self new type: #encode
    ]

    type [
	"Answer the value of type"

	<category: 'accessing'>
	^type
    ]

    type: anObject [
	"Set the value of type"

	<category: 'accessing'>
	type := anObject
    ]
]



Object subclass: MpMessagePack [
    
    <category: 'MessagePack-Core'>
    <comment: nil>

    Default := nil.
    DialectSpecificClass := nil.

    MpMessagePack class >> pack: anObject [
	<category: 'utilities'>
	^MpEncoder encode: anObject
    ]

    MpMessagePack class >> packUnpack: anObject [
	<category: 'utilities'>
	^self unpack: (self pack: anObject)
    ]

    MpMessagePack class >> unpack: aByteArray [
	<category: 'utilities'>
	^MpDecoder decode: aByteArray
    ]
]



Object subclass: MpPortableUtil [
    
    <category: 'MessagePack-Core'>
    <comment: nil>

    Default := nil.
    DialectSpecificClass := nil.

    MpPortableUtil class >> default [
	<category: 'instance creation'>
	^Default ifNil: [Default := self dialectSpecificClass new]
    ]

    MpPortableUtil class >> dialectSpecificClass [
	<category: 'factory'>
	^DialectSpecificClass 
	    ifNil: [DialectSpecificClass := self subclasses at: 1]
    ]

    MpPortableUtil class >> dialectSpecificClass: aClass [
	<category: 'factory'>
	DialectSpecificClass := aClass
    ]

    MpPortableUtil class >> initialize [
	<category: 'class initialization'>
	Default := nil.
	DialectSpecificClass := nil
    ]

    collectionEquals: aCollection with: otherCollection [
	"For testing"

	<category: 'testing'>
	^aCollection = otherCollection
    ]

    encodeTypeMapperClass [
	<category: 'factory'>
	^MpEncodeTypeMapper
    ]

    newCollection: aCollectionClass sized: size withAll: elem [
	"For testing"

	<category: 'factory'>
	^aCollectionClass new: size withAll: elem
    ]

    randomClass [
	"For testing"

	<category: 'factory'>
	^Smalltalk at: #Random
    ]

    readDoubleFrom: stream [
	<category: 'actions-stream'>
	self subclassResponsibility
    ]

    readFloatFrom: stream [
	<category: 'actions-stream'>
	self subclassResponsibility
    ]

    readInt16From: stream [
	<category: 'actions-stream'>
	self subclassResponsibility
    ]

    readInt32From: stream [
	<category: 'actions-stream'>
	self subclassResponsibility
    ]

    readInt64From: stream [
	<category: 'actions-stream'>
	self subclassResponsibility
    ]

    readUint16From: stream [
	<category: 'actions-stream'>
	self subclassResponsibility
    ]

    readUint32From: stream [
	<category: 'actions-stream'>
	self subclassResponsibility
    ]

    readUint64From: stream [
	<category: 'actions-stream'>
	self subclassResponsibility
    ]

    writeDouble: value to: stream [
	<category: 'actions-stream'>
	self subclassResponsibility
    ]

    writeFloat: value to: stream [
	<category: 'actions-stream'>
	self subclassResponsibility
    ]

    writeInt16: value to: stream [
	<category: 'actions-stream'>
	self subclassResponsibility
    ]

    writeInt32: value to: stream [
	<category: 'actions-stream'>
	self subclassResponsibility
    ]

    writeInt64: value to: stream [
	<category: 'actions-stream'>
	self subclassResponsibility
    ]

    writeUint16: value to: stream [
	<category: 'actions-stream'>
	self subclassResponsibility
    ]

    writeUint32: value to: stream [
	<category: 'actions-stream'>
	self subclassResponsibility
    ]

    writeUint64: value to: stream [
	<category: 'actions-stream'>
	self subclassResponsibility
    ]

    signalException: anException [
	"Ansi"

	<category: 'actions'>
	^anException signal
    ]
]



Object subclass: MpSettings [
    | settingsDict |
    
    <category: 'MessagePack-Core'>
    <comment: nil>

    at: key [
	<category: 'actions-dictionary'>
	^self settingsDict at: key
    ]

    at: key ifAbsent: aBlock [
	<category: 'actions-dictionary'>
	^self settingsDict at: key ifAbsent: aBlock
    ]

    at: key ifAbsentPut: aBlock [
	<category: 'actions-dictionary'>
	^self settingsDict at: key ifAbsentPut: aBlock
    ]

    at: key put: value [
	<category: 'actions-dictionary'>
	^self settingsDict at: key put: value
    ]

    includesKey: key [
	<category: 'actions-dictionary'>
	^self settingsDict includesKey: key
    ]

    keys [
	<category: 'actions-dictionary'>
	^self settingsDict keys
    ]

    defaultStreamSize [
	<category: 'accessing'>
	^self at: #defaultStreamSize ifAbsentPut: [1024]
    ]

    defaultStreamSize: anInteger [
	<category: 'accessing'>
	^self at: #defaultStreamSize put: anInteger
    ]

    initialize [
	<category: 'class initialization'>
	settingsDict := nil
    ]

    settingsDict [
	<category: 'accessing-private'>
	^settingsDict ifNil: [settingsDict := IdentityDictionary new]
    ]
]



Object subclass: MpTypeMapper [
    | actionMap |
    
    <category: 'MessagePack-Core'>
    <comment: nil>

    MpTypeMapper class [
	| actionMap |
	
    ]

    MpTypeMapper class >> actionMap [
	<category: 'accessing'>
	^actionMap ifNil: [actionMap := self createActionMap]
    ]

    MpTypeMapper class >> createActionMap [
	<category: 'factory'>
	| map |
	map := IdentityDictionary new.
	self definePrimitivesActionsTo: map.
	self defineCompoundsActionsTo: map.
	^map
    ]

    MpTypeMapper class >> defineCompoundsActionsTo: map [
	"override"

	<category: 'actions for compounds'>
	
    ]

    MpTypeMapper class >> definePrimitivesActionsTo: map [
	"override"

	<category: 'actions for primitives'>
	
    ]

    MpTypeMapper class >> initialize [
	"self initialize"

	<category: 'class initialization'>
	actionMap := nil.
	self actionMap
    ]

    MpTypeMapper class >> initializeAll [
	"self initializeAll"

	<category: 'class initialization'>
	self allSubclasses do: [:each | each initialize]
    ]

    actionMap [
	<category: 'accessing'>
	^actionMap ifNil: [actionMap := IdentityDictionary new]
    ]

    defaultActionMap [
	<category: 'accessing'>
	^self class actionMap
    ]

    initActionMaps [
	"override for custom mapping"

	<category: 'initialization'>
	actionMap := nil
    ]
]



MpTypeMapper subclass: MpDecodeTypeMapper [
    | decoder |
    
    <category: 'MessagePack-Core'>
    <comment: nil>

    MpDecodeTypeMapper class >> defineArrayActionTo: map [
	<category: 'actions for compounds'>
	map at: MpConstants array16 put: #readArray16.
	map at: MpConstants array32 put: #readArray32
    ]

    MpDecodeTypeMapper class >> defineCompoundsActionsTo: map [
	<category: 'actions for compounds'>
	self defineArrayActionTo: map.
	self defineMapActionTo: map
    ]

    MpDecodeTypeMapper class >> defineMapActionTo: map [
	<category: 'actions for compounds'>
	map at: MpConstants map16 put: #readMap16.
	map at: MpConstants map32 put: #readMap32
    ]

    MpDecodeTypeMapper class >> defineDoubleActionTo: map [
	<category: 'actions for primitives'>
	map at: MpConstants double put: #readDouble
    ]

    MpDecodeTypeMapper class >> defineFalseActionTo: map [
	<category: 'actions for primitives'>
	map at: MpConstants falseValue put: #readFalse
    ]

    MpDecodeTypeMapper class >> defineFloatActionTo: map [
	<category: 'actions for primitives'>
	map at: MpConstants float put: #readFloat
    ]

    MpDecodeTypeMapper class >> defineIntegerActionTo: map [
	<category: 'actions for primitives'>
	map at: MpConstants int8 put: #readInt8.
	map at: MpConstants int16 put: #readInt16.
	map at: MpConstants int32 put: #readInt32.
	map at: MpConstants int64 put: #readInt64
    ]

    MpDecodeTypeMapper class >> defineNilActionTo: map [
	<category: 'actions for primitives'>
	map at: MpConstants nilValue put: #readNil
    ]

    MpDecodeTypeMapper class >> definePrimitivesActionsTo: map [
	<category: 'actions for primitives'>
	self defineNilActionTo: map.
	self defineFalseActionTo: map.
	self defineTrueActionTo: map.
	self defineFloatActionTo: map.
	self defineDoubleActionTo: map.
	self defineUnsignedIntegerActionTo: map.
	self defineIntegerActionTo: map.
	self defineRawBytesActionTo: map
    ]

    MpDecodeTypeMapper class >> defineRawBytesActionTo: map [
	<category: 'actions for primitives'>
	map at: MpConstants raw16 put: #readRaw16.
	map at: MpConstants raw32 put: #readRaw32
    ]

    MpDecodeTypeMapper class >> defineTrueActionTo: map [
	<category: 'actions for primitives'>
	map at: MpConstants trueValue put: #readTrue
    ]

    MpDecodeTypeMapper class >> defineUnsignedIntegerActionTo: map [
	<category: 'actions for primitives'>
	map at: MpConstants uint8 put: #readUint8.
	map at: MpConstants uint16 put: #readUint16.
	map at: MpConstants uint32 put: #readUint32.
	map at: MpConstants uint64 put: #readUint64
    ]

    MpDecodeTypeMapper class >> on: bertDecoder [
	<category: 'instance creation'>
	^(self new)
	    decoder: bertDecoder;
	    initActionMaps;
	    yourself
    ]

    decoder [
	"Answer the value of decoder"

	<category: 'accessing'>
	^decoder
    ]

    decoder: anObject [
	"Set the value of decoder"

	<category: 'accessing'>
	decoder := anObject
    ]

    readObjectOf: typeCode ifNotApplied: aBlock [
	<category: 'actions'>
	| actionSelector |
	actionMap ifNotNil: 
		[:foo | 
		actionSelector := self actionMap at: typeCode ifAbsent: [].
		actionSelector ifNotNil: [^self decoder perform: actionSelector]].
	actionSelector := self defaultActionMap at: typeCode
		    ifAbsent: [^aBlock value].
	^self decoder perform: actionSelector
    ]
]



MpTypeMapper subclass: MpEncodeTypeMapper [
    | encoder |
    
    <category: 'MessagePack-Core'>
    <comment: nil>

    MpEncodeTypeMapper class >> defineArrayActionTo: map [
	<category: 'actions for compounds'>
	map at: Array put: #writeArray:
    ]

    MpEncodeTypeMapper class >> defineCompoundsActionsTo: map [
	<category: 'actions for compounds'>
	self defineArrayActionTo: map.
	self defineMapActionTo: map
    ]

    MpEncodeTypeMapper class >> defineMapActionTo: map [
	<category: 'actions for compounds'>
	map at: Dictionary put: #writeMap:
	"map at: IdentityDictionary put: #writeDictionary:"
    ]

    MpEncodeTypeMapper class >> defineDoubleActionTo: map [
	"Some dialect does not support Double"

	"map at: Double put: #writeDouble:"

	<category: 'actions for primitives'>
	
    ]

    MpEncodeTypeMapper class >> defineFalseActionTo: map [
	<category: 'actions for primitives'>
	map at: False put: #writeFalse:
    ]

    MpEncodeTypeMapper class >> defineFloatActionTo: map [
	"Suppose 32 bit float - Some dialect does not support it"

	"map at: Float put: #writeFloat:"

	<category: 'actions for primitives'>
	
    ]

    MpEncodeTypeMapper class >> defineIntegerActionTo: map [
	<category: 'actions for primitives'>
	Integer allSubclasses do: [:each | map at: each put: #writeInteger:]
    ]

    MpEncodeTypeMapper class >> defineNilActionTo: map [
	<category: 'actions for primitives'>
	map at: UndefinedObject put: #writeNil:
    ]

    MpEncodeTypeMapper class >> definePrimitivesActionsTo: map [
	<category: 'actions for primitives'>
	self defineRawBytesActionTo: map.
	self defineIntegerActionTo: map.
	self defineFloatActionTo: map.
	self defineDoubleActionTo: map.
	self defineNilActionTo: map.
	self defineTrueActionTo: map.
	self defineFalseActionTo: map
    ]

    MpEncodeTypeMapper class >> defineRawBytesActionTo: map [
	<category: 'actions for primitives'>
	map at: ByteArray put: #writeRawBytes:
    ]

    MpEncodeTypeMapper class >> defineTrueActionTo: map [
	<category: 'actions for primitives'>
	map at: True put: #writeTrue:
    ]

    MpEncodeTypeMapper class >> on: bertEncoder [
	<category: 'instance creation'>
	^(self new)
	    encoder: bertEncoder;
	    initActionMaps;
	    yourself
    ]

    encoder [
	"Answer the value of encoder"

	<category: 'accessing'>
	^encoder
    ]

    encoder: anObject [
	"Set the value of encoder"

	<category: 'accessing'>
	encoder := anObject
    ]

    writeObject: anObject ifNotApplied: aBlock [
	<category: 'actions'>
	| actionSelector |
	actionMap ifNotNil: 
		[:foo | 
		actionSelector := self actionMap at: anObject class ifAbsent: [].
		actionSelector 
		    ifNotNil: [^self encoder perform: actionSelector with: anObject]].
	actionSelector := self defaultActionMap at: anObject class
		    ifAbsent: [^aBlock value].
	^self encoder perform: actionSelector with: anObject
    ]
]



Object extend [

    messagePacked [
	<category: '*MessagePack-Core-packing'>
	^MpEncoder encode: self
    ]

]



Behavior extend [

    fromMessagePack: bytes [
	<category: '*MessagePack-Core-unpacking'>
	^MpDecoder decode: bytes
    ]

]



Eval [
    MpTypeMapper initialize.
    MpPortableUtil initialize
]

