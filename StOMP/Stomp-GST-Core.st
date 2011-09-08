StompPopularClassMap subclass: StompGstPopularClassMap [
    
    <comment: nil>
    <category: 'Stomp-GST-Core'>

    fixedPointClass [
	<category: 'factory'>
	^self classNamed: #ScaledDecimal
    ]

    timestampClass [
	<category: 'factory'>
	^self classNamed: #DateTime
    ]

    uint16ArrayClass [
	<category: 'factory'>
	^self classNamed: #WordArray
    ]

    uint32ArrayClass [
	<category: 'factory'>
	^self classNamed: #WordArray
    ]

    isUsingUnicode [
	<category: 'private'>

	(Smalltalk at: #UnicodeCharacter ifAbsent: [nil]) ifNil: [^false].
	^true
    ]

    prepareClassToCodeMap: classToCodeMap [
	"By default, just create counter-map"

	<category: 'preparing'>

	super prepareClassToCodeMap: classToCodeMap.
	self isUsingUnicode ifTrue: [classToCodeMap at: UnicodeCharacter put: 3]

    ]

    prepareCodeToClassMap: codeToClassMap [
	<category: 'preparing'>

	super prepareCodeToClassMap: codeToClassMap.
	"self isUsingUnicode ifTrue: [codeToClassMap at: 3 put: UnicodeCharacter]."
    ]

]



StompPortableUtil subclass: StompGstPortableUtil [
    
    <comment: nil>
    <category: 'Stomp-GST-Core'>

    StompGstPortableUtil class >> initialize [
	"StompGstPortableUtil initialize"

	<category: 'class initialization'>
	| klsName |
	super initialize.
	klsName := self name.
	Smalltalk at: klsName
	    ifPresent: [:p | StompPortableUtil dialectSpecificClass: p]
	    "もしかしたらこの辺りに Extra に関する手続きを入れる？
	     まだ不明"
    ]

    bytes: rawBytes intoOf: bitsClass [
	"override"

	<category: 'actions'>

	^ rawBytes changeClassTo: bitsClass
    ]

    classNamed: localClassName in: environmentQualifier  [
	"override"
	<category: 'actions'>

	| bindingReference binding env |
	environmentQualifier ifNil: [^ self classNamed: localClassName].

	bindingReference := BindingReference pathString: environmentQualifier.
	binding := bindingReference bindingOrNil ifNil: [^nil].
	env :=  binding value.
	^ env
		at: localClassName
		ifAbsent: []
    ]

    environmentNameOf: anObject [
	^anObject class environment name	
    ]

    instVarIndexOf: aClass for: varName [
	<category: 'actions'>
	^aClass indexOfInstVar: varName asString ifAbsent: [0]
    ]

    instVarNamed: varName put: value in: anObject [
	"Note that when varName is invalid, just silently ignore"

	<category: 'actions'>
	| index |
	index := anObject class indexOfInstVar: varName asString ifAbsent: [^self].
	anObject instVarAt: index put: value
    ]


    shouldWriteEnvironmentNameOf: anObject [
	<category: 'actions'>

	| kls nonMeta |
	kls := anObject class.
	nonMeta := kls isMeta ifTrue: [kls soleInstance] ifFalse: [kls].
	(Smalltalk at: nonMeta name ifAbsent: [^true]).
	^false
    ]

    characterFromUnicode: anInteger [
	<category: 'converting'>
	anInteger <= 16rFF ifTrue: [^Character value: anInteger].
	^UnicodeCharacter value: anInteger
    ]

    colorFromRgbArray: rgbArray [
	<category: 'converting'>
	^Color 
	    r: rgbArray first asNumber
	    g: rgbArray second asNumber
	    b: rgbArray third asNumber
    ]

    dateAndTimeFromNanoseconds: nanoseconds [
	<category: 'converting'>
	^DateTime epoch + (Duration nanoSeconds: nanoseconds)
    ]

    durationFromNanoseconds: nanoseconds [
	<category: 'converting'>
	^Duration nanoSeconds: nanoseconds
    ]

    nanosecondsFromDateAndTime: dateAndTime [
	"Answer the number of nanoseconds since January 1, 1901."

	<category: 'converting'>

	^dateAndTime asSeconds * 1000000000
    ]

    nanosecondsFromDuration: duration [
	<category: 'converting'>
	^duration asNanoSeconds
    ]

    stringFromBytes: aByteArray [
	<category: 'converting'>
	| str |
	str := aByteArray asString.
	^str
    ]

    timestampFromNanoseconds: nanoseconds [
	"^ Timestamp fromNanoseconds: nanoseconds"

	<category: 'converting'>
	| seconds |
	seconds := nanoseconds / 1000000000.
	^DateTime date: (Date fromSeconds: seconds) time: (Time fromSeconds: seconds)
    ]

    unicodeFromCharacter: aCharacter [
	<category: 'converting'>
	^aCharacter value
    ]

    isWideString: aString [
	<category: 'testing'>
	"ToDo: マルチバイト文字列はどのように導入するのか？"
	^aString isUnicode
    ]

    isWideSymbol: aSymbol [
	<category: 'testing'>
	"ToDo: GSTのマルチバイトシンボルはあるのか？"
	^aSymbol isUnicode
    ]

    popularClassMap [
	"override"

	<category: 'factory'>
	^StompGstPopularClassMap default
    ]

]




CompiledMethod class extend [

    stompFromBytes: rawBytes [
	<category: '*Stomp-Squeak-Core-instance creation'>
	| inst |
	inst := super basicNew: rawBytes size.
	inst 
	    replaceFrom: 1
	    to: inst size
	    with: rawBytes
	    startingAt: 1.
	^inst
    ]

]





Number extend [
    seconds [
	^Duration fromSeconds: self.
    ]
]


ScaledDecimal class extend [

    stompCreateInstanceFrom: stompReader [
	<category: '*Stomp-Squeak-Core-instance creation'>
	| array |
	array := stompReader readPrimitiveValues.
	^self newFromNumber: (array at: 1) scale: (array at: 2)
    ]

]



DateTime extend [

    stompWriteContentTo: stompWriter [
	<category: '*Stomp-Squeak-Core-writing'>
	stompWriter 
	    writeObject: (StompPortableUtil default nanosecondsFromDateAndTime: self)
    ]

]



DateTime class extend [
    stompCreateInstanceFrom: stompReader [
	<category: '*Stomp-Squeak-Core-instance creation'>
	^StompPortableUtil default 
	    timestampFromNanoseconds: stompReader readObject
    ]
]

DateTime extend [
    nanoSecond [
	^self second * 1000000000
    ]
]

Duration class extend [
    nanoSeconds: nanoSeconds [
	^self seconds: nanoSeconds / 1000000000
    ]
]

Duration extend [
    asNanoSeconds [
	^self asSeconds * 1000000000
    ]
]

RunArray class extend [
    runs: newRuns values: newValues [
	| newMap newRunArray |
	newMap := OrderedCollection new.
	newRuns with: newValues do: [:r :v | newMap add: (r->v)].
	newRunArray := self new.
	newRunArray map: newMap.
	^newRunArray
    ]
]

RunArray extend [
    runs [
	^self map collect: [:e | e key]
    ]

    values [
	^self map collect: [:e | e value]
    ]
]


Set extend [
    stompAt: index put: aValue [
	^self stompAdd: aValue at: index
    ]
]

OrderedCollection extend [
    stompAt: index put: aValue [
	^self stompAdd: aValue at: index
    ]
]


Eval [
    StompGstPortableUtil initialize
]

