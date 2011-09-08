Eval [
    'From Squeak4.2 of 4 February 2011 [latest update: #10966] on 8 August 2011 at 10:30:33 am'
]



Object subclass: StompConstants [
    
    <category: 'Stomp-Core'>
    <comment: nil>

    StompConstants class [
	| tupleTags |
	
    ]

    StompConstants class >> byteString [
	<category: 'tuple tags'>
	^4
    ]

    StompConstants class >> byteSymbol [
	<category: 'tuple tags'>
	^5
    ]

    StompConstants class >> reference [
	<category: 'tuple tags'>
	^3
    ]

    StompConstants class >> value [
	<category: 'tuple tags'>
	^2
    ]

    StompConstants class >> wideString [
	<category: 'tuple tags'>
	^6
    ]

    StompConstants class >> wideSymbol [
	<category: 'tuple tags'>
	^7
    ]

    StompConstants class >> classCode [
	<category: 'attribute-tags'>
	^21
    ]

    StompConstants class >> classId [
	<category: 'attribute-tags'>
	^18
    ]

    StompConstants class >> environmentId [
	<category: 'attribute-tags'>
	^20
    ]

    StompConstants class >> environmentName [
	<category: 'attribute-tags'>
	^19
    ]

    StompConstants class >> klassName [
	<category: 'attribute-tags'>
	^17
    ]

    StompConstants class >> header [
	<category: 'accessing'>
	^'SP' asByteArray
    ]

    StompConstants class >> tupleTags [
	<category: 'accessing'>
	^tupleTags
    ]

    StompConstants class >> initTupleTags [
	"self initTupleTags"

	<category: 'class initialization'>
	tupleTags := Set new.
	tupleTags add: self value.
	tupleTags add: self reference.
	tupleTags add: self byteString.
	tupleTags add: self byteSymbol.
	tupleTags add: self wideString.
	tupleTags add: self wideSymbol
    ]

    StompConstants class >> initialize [
	"self initialize"

	<category: 'class initialization'>
	self initTupleTags
    ]

    StompConstants class >> isTupleTag: tag [
	<category: 'actions'>
	^tag isInteger and: [self tupleTags includes: tag]
    ]
]



Object subclass: StompContext [
    | requestor objectsDictionary |
    
    <category: 'Stomp-Core'>
    <comment: nil>

    StompContext class >> on: requestor [
	<category: 'instance creation'>
	^(self new)
	    requestor: requestor;
	    yourself
    ]

    at: key [
	<category: 'actions'>
	^self objectsDictionary at: key
    ]

    at: key ifAbsent: block [
	<category: 'actions'>
	^self objectsDictionary at: key ifAbsent: block
    ]

    at: key ifAbsentPut: value [
	<category: 'actions'>
	^self objectsDictionary at: key ifAbsentPut: value
    ]

    at: key put: value [
	<category: 'actions'>
	^self objectsDictionary at: key put: value
    ]

    includesKey: key [
	<category: 'actions'>
	^self objectsDictionary includesKey: key
    ]

    keys [
	<category: 'actions'>
	^self objectsDictionary keys
    ]

    keysAndValuesDo: block [
	<category: 'actions'>
	^self objectsDictionary keysAndValuesDo: block
    ]

    removeKey: key [
	<category: 'actions'>
	^self objectsDictionary removeKey: key
    ]

    removeKey: key ifAbsent: block [
	<category: 'actions'>
	^self objectsDictionary removeKey: key ifAbsent: block
    ]

    size [
	<category: 'actions'>
	^self objectsDictionary size
    ]

    values [
	<category: 'actions'>
	^self objectsDictionary values
    ]

    objectDictionaryClass [
	<category: 'defaults'>
	^IdentityDictionary
    ]

    objectsDictionary [
	"Answer the value of objectsDictionary"

	<category: 'accessing'>
	^objectsDictionary 
	    ifNil: [objectsDictionary := self objectDictionaryClass new]
    ]

    objectsDictionary: anObject [
	"Set the value of objectsDictionary"

	<category: 'accessing'>
	objectsDictionary := anObject
    ]

    requestor [
	<category: 'accessing'>
	^requestor
    ]

    requestor: anObject [
	"Set the value of requestor"

	<category: 'accessing'>
	requestor := anObject
    ]

    settings [
	<category: 'accessing'>
	^self requestor settings
    ]

    printOn: aStream [
	<category: 'printing'>
	aStream nextPutAll: self class name.
	aStream nextPutAll: '('.
	aStream cr.
	self objectsDictionary associationsDo: 
		[:assoc | 
		assoc printOn: aStream.
		aStream cr].
	aStream nextPutAll: ')'
    ]
]



Error subclass: StompError [
    
    <category: 'Stomp-Core'>
    <comment: nil>

    StompError class >> signal: aString [
	<category: 'instance creation'>
	| inst |
	inst := self new.
	inst messageText: aString.
	^MpPortableUtil default signalException: inst
    ]
]



Object subclass: StompFieldsInfo [
    | type indexFieldSize |
    
    <category: 'Stomp-Core'>
    <comment: nil>

    StompFieldsInfo class >> mixedFields [
	<category: 'instance creation'>
	^self type: #mixedFields
    ]

    StompFieldsInfo class >> pureIndexFields [
	<category: 'instance creation'>
	^self type: #pureIndexFields
    ]

    StompFieldsInfo class >> pureIndexFieldsSized: numOfFields [
	<category: 'instance creation'>
	^self pureIndexFields indexFieldSize: numOfFields
    ]

    StompFieldsInfo class >> type: typeSymbol [
	<category: 'instance creation'>
	^(self new)
	    type: typeSymbol;
	    yourself
    ]

    indexFieldSize [
	"Answer the value of indexFieldSize"

	<category: 'accessing'>
	^indexFieldSize
    ]

    indexFieldSize: anObject [
	"Set the value of indexFieldSize"

	<category: 'accessing'>
	indexFieldSize := anObject
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

    isMixedFields [
	<category: 'testing'>
	^self type == #mixedFields
    ]

    isPureIndexFields [
	<category: 'testing'>
	^self type == #pureIndexFields
    ]
]



Object subclass: StompPopularClassMap [
    | classToCode codeToClass |
    
    <category: 'Stomp-Core'>
    <comment: nil>

    StompPopularClassMap class [
	| default |
	
    ]

    StompPopularClassMap class >> default [
	"Answer the value of default"

	<category: 'accessing'>
	^default ifNil: [default := super new initialize]
    ]

    StompPopularClassMap class >> initialize [
	"self initialize"

	<category: 'class initialization'>
	self class = StompPopularClassMap ifTrue: [^self initializeAll].
	default := nil
    ]

    StompPopularClassMap class >> initializeAll [
	"self initializeAll"

	<category: 'class initialization'>
	self allSubclasses do: [:each | each initialize]
    ]

    associationClass [
	<category: 'factory'>
	^self classNamed: #Association
    ]

    bagClass [
	<category: 'factory'>
	^self classNamed: #Bag
    ]

    byteStringClass [
	<category: 'factory'>
	^self classNamed: #ByteString
    ]

    byteSymbolClass [
	<category: 'factory'>
	^self classNamed: #ByteSymbol
    ]

    characterClass [
	<category: 'factory'>
	^self classNamed: #Character
    ]

    colorClass [
	<category: 'factory'>
	^self classNamed: #Color
    ]

    compactDictionaryClass [
	<category: 'factory'>
	^self classNamed: #CompactDictionary
    ]

    compiledMethodClass [
	<category: 'factory'>
	^self classNamed: #CompiledMethod
    ]

    dateAndTimeClass [
	<category: 'factory'>
	^self classNamed: #DateAndTime
    ]

    dateClass [
	<category: 'factory'>
	^self classNamed: #Date
    ]

    durationClass [
	<category: 'factory'>
	^self classNamed: #Duration
    ]

    fixedPointClass [
	<category: 'factory'>
	^self classNamed: #FixedPoint
    ]

    fractionClass [
	<category: 'factory'>
	^self classNamed: #Fraction
    ]

    identityDictionaryClass [
	<category: 'factory'>
	^self classNamed: #IdentityDictionary
    ]

    identitySetClass [
	<category: 'factory'>
	^self classNamed: #IdentitySet
    ]

    intervalClass [
	<category: 'factory'>
	^self classNamed: #Interval
    ]

    matrixClass [
	<category: 'factory'>
	^self classNamed: #Matrix
    ]

    orderedCollectionClass [
	<category: 'factory'>
	^self classNamed: #OrderedCollection
    ]

    orderedSetClass [
	<category: 'factory'>
	^self classNamed: #OrderedSet
    ]

    pointClass [
	<category: 'factory'>
	^self classNamed: #Point
    ]

    rectangleClass [
	<category: 'factory'>
	^self classNamed: #Rectangle
    ]

    runArrayClass [
	<category: 'factory'>
	^self classNamed: #RunArray
    ]

    setClass [
	<category: 'factory'>
	^self classNamed: #Set
    ]

    sortedCollectionClass [
	<category: 'factory'>
	^self classNamed: #SortedCollection
    ]

    timeClass [
	<category: 'factory'>
	^self classNamed: #Time
    ]

    timestampClass [
	<category: 'factory'>
	^self classNamed: #Timestamp
    ]

    uint16ArrayClass [
	<category: 'factory'>
	^self classNamed: #WordArray
    ]

    uint32ArrayClass [
	<category: 'factory'>
	^self classNamed: #DwordArray
    ]

    uuidClass [
	<category: 'factory'>
	^self classNamed: #UUID
    ]

    classAt: code [
	<category: 'actions'>
	^self codeToClass at: code ifAbsent: []
    ]

    codeAt: aClass ifPresent: aBlock [
	<category: 'actions'>
	| code |
	code := self classToCode at: aClass ifAbsent: [].
	code ifNotNil: [:foo | aBlock value: code]
    ]

    classNamed: localClassName [
	<category: 'private'>
	^Smalltalk at: localClassName ifAbsent: []
    ]

    classToCode [
	"Answer the value of classToCode"

	<category: 'accessing'>
	^classToCode
    ]

    classToCode: anObject [
	"Set the value of classToCode"

	<category: 'accessing'>
	classToCode := anObject
    ]

    codeToClass [
	"Answer the value of codeToClass"

	<category: 'accessing'>
	^codeToClass
    ]

    codeToClass: anObject [
	"Set the value of codeToClass"

	<category: 'accessing'>
	codeToClass := anObject
    ]

    initialize [
	<category: 'initialize-release'>
	classToCode := IdentityDictionary new.
	codeToClass := IdentityDictionary new.
	self prepareMaps
    ]

    prepareMaps [
	<category: 'initialize-release'>
	self prepareCodeToClassMap: self codeToClass.
	self prepareClassToCodeMap: self classToCode
    ]

    popularClassSelectors [
	"Reserved popular classes - if you extend class map, the array should only be appended."

	"^(self class organization listAtCategoryNamed: #factory) asSortedCollection."

	<category: 'constants'>
	^#(#bagClass #compactDictionaryClass #characterClass #colorClass #dateAndTimeClass #dateClass #fractionClass #identityDictionaryClass #identitySetClass #intervalClass #orderedCollectionClass #pointClass #rectangleClass #setClass #sortedCollectionClass #matrixClass #durationClass #timeClass #timestampClass #runArrayClass #orderedSetClass #uuidClass #fixedPointClass #associationClass #compiledMethodClass #uint16ArrayClass #uint32ArrayClass)
    ]

    prepareClassToCodeMap: classToCodeMap [
	"By default, just create counter-map"

	<category: 'preparing'>
	self codeToClass 
	    keysAndValuesDo: [:key :value | classToCodeMap at: value put: key]
    ]

    prepareCodeToClassMap: codeToClassMap [
	<category: 'preparing'>
	| selectors |
	selectors := self popularClassSelectors.
	1 to: selectors size
	    do: 
		[:idx | 
		| kls |
		kls := self perform: (selectors at: idx).
		kls ifNotNil: [:foo | codeToClassMap at: idx put: kls]]
    ]
]



Object subclass: StompPortableUtil [
    
    <category: 'Stomp-Core'>
    <comment: nil>

    Default := nil.
    DialectSpecificClass := nil.

    StompPortableUtil class >> default [
	<category: 'instance creation'>
	^Default ifNil: [Default := self dialectSpecificClass new]
    ]

    StompPortableUtil class >> dialectSpecificClass [
	<category: 'factory'>
	^DialectSpecificClass 
	    ifNil: [DialectSpecificClass := self subclasses at: 1]
    ]

    StompPortableUtil class >> dialectSpecificClass: aClass [
	<category: 'factory'>
	DialectSpecificClass := aClass
    ]

    StompPortableUtil class >> initialize [
	<category: 'class initialization'>
	Default := nil.
	DialectSpecificClass := nil
    ]

    bytes: rawBytes intoOf: bitsClass [
	"override"

	<category: 'actions'>
	^bitsClass new: rawBytes size
    ]

    bytesFrom: bitsObject [
	"override"

	<category: 'actions'>
	^bitsObject
    ]

    classNamed: localClassName [
	"override"

	<category: 'actions'>
	^Smalltalk at: localClassName ifAbsent: []
    ]

    classNamed: localClassName in: environmentQualifier [
	"override"

	<category: 'actions'>
	| env |
	environmentQualifier ifNil: [^self classNamed: localClassName].

	"Suppose namespace is not supported, so just use Smalltalk"
	env := Smalltalk.
	^env at: localClassName ifAbsent: []
    ]

    environmentNameOf: anObject [
	<category: 'actions'>
	^#Smalltalk
    ]

    instVarIndexOf: aClass for: varName [
	"override"

	<category: 'actions'>
	self subclassResponsibility.
	^0
    ]

    instVarIndicesOf: aClass from: instVarNames [
	<category: 'actions'>
	^instVarNames collect: [:each | self instVarIndexOf: aClass for: each]
    ]

    instVarNamed: varName put: value in: anObject [
	"Note that when varName is invalid, just silently ignore"

	<category: 'actions'>
	| index |
	index := self instVarIndexOf: anObject class for: varName.
	index = 0 ifTrue: [^self].
	anObject instVarAt: index put: value
    ]

    nextAvailable: size from: stream [
	"even reached at end, just return contents as-is"

	<category: 'actions'>
	^stream nextAvailable: size
    ]

    shouldWriteEnvironmentNameOf: anObject [
	<category: 'actions'>
	^(self environmentNameOf: anObject) ~~ #Smalltalk
    ]

    useEnvironmentByDefault [
	<category: 'actions'>
	^true
    ]

    bytesFromString: aString [
	<category: 'converting'>
	^aString asByteArray
    ]

    characterFromUnicode: anInteger [
	<category: 'converting'>
	^Character value: anInteger
    ]

    colorFromRgbArray: rgbArray [
	<category: 'converting'>
	^nil
    ]

    dateAndTimeFromNanoseconds: nanoseconds [
	<category: 'converting'>
	^self timestampFromNanoseconds: nanoseconds
    ]

    dateFromSeconds: seconds [
	<category: 'converting'>
	^Date fromSeconds: seconds
    ]

    durationFromNanoseconds: nanoseconds [
	"^Duration fromNanoseconds: nanoseconds"

	<category: 'converting'>
	self subclassResponsibility
    ]

    nanosecondsFromDateAndTime: timestamp [
	"Answer the number of nanoseconds since January 1, 1901."

	"^timestamp asNanoseconds"

	<category: 'converting'>
	self subclassResponsibility
    ]

    nanosecondsFromDuration: duration [
	<category: 'converting'>
	self subclassResponsibility
    ]

    stringFromBytes: aByteArray [
	<category: 'converting'>
	^aByteArray asString
    ]

    timestampFromNanoseconds: nanoseconds [
	"^ Timestamp fromNanoseconds: nanoseconds"

	<category: 'converting'>
	self subclassResponsibility
    ]

    unicodeFromCharacter: aCharacter [
	<category: 'converting'>
	^UnicodeCharacter value: aCharacter asciiValue
    ]

    encodeTypeMapperClass [
	<category: 'factory'>
	^MpEncodeTypeMapper
    ]

    popularClassMap [
	"override"

	<category: 'factory'>
	^StompPopularClassMap default
    ]

    soleInstanceOf: aMetaclass [
	<category: 'factory'>
	^aMetaclass soleInstance
    ]

    isMeta: aBehavior [
	<category: 'testing'>
	^aBehavior isMeta
    ]

    isWideString: aString [
	"override"

	<category: 'testing'>
	^false
    ]

    isWideSymbol: aSymbol [
	"override"

	<category: 'testing'>
	^false
    ]
]



StompContext subclass: StompReadContext [
    | classIdsDictionary environmentNamesDictionary instVarNamesWithIndicesDictionary classAliasesDictionary shapeChangersDictionary fieldsInfo |
    
    <category: 'Stomp-Core'>
    <comment: nil>

    classAliasesDictionary [
	<category: 'accessing'>
	^classAliasesDictionary 
	    ifNil: [classAliasesDictionary := IdentityDictionary new]
    ]

    classAliasesDictionary: anObject [
	"Set the value of classAliasesDictionary"

	<category: 'accessing'>
	classAliasesDictionary := anObject
    ]

    classIdsDictionary [
	<category: 'accessing'>
	^classIdsDictionary ifNil: [classIdsDictionary := Dictionary new]
    ]

    classIdsDictionary: anObject [
	"Set the value of classIdsDictionary"

	<category: 'accessing'>
	classIdsDictionary := anObject
    ]

    environmentNamesDictionary [
	<category: 'accessing'>
	^environmentNamesDictionary 
	    ifNil: [environmentNamesDictionary := Dictionary new]
    ]

    environmentNamesDictionary: anObject [
	"Set the value of environmentNamesDictionary"

	<category: 'accessing'>
	environmentNamesDictionary := anObject
    ]

    fieldsInfo [
	"Answer the value of mixedFieldHint"

	<category: 'accessing'>
	^fieldsInfo
    ]

    fieldsInfo: anObject [
	"Set the value of mixedFieldHint"

	<category: 'accessing'>
	fieldsInfo := anObject
    ]

    instVarNamesWithIndicesDictionary [
	<category: 'accessing'>
	^instVarNamesWithIndicesDictionary 
	    ifNil: [instVarNamesWithIndicesDictionary := IdentityDictionary new]
    ]

    instVarNamesWithIndicesDictionary: anObject [
	"Set the value of instVarNamesWithIndicesDictionary"

	<category: 'accessing'>
	instVarNamesWithIndicesDictionary := anObject
    ]

    shapeChangersDictionary [
	<category: 'accessing'>
	^shapeChangersDictionary 
	    ifNil: [shapeChangersDictionary := IdentityDictionary new]
    ]

    shapeChangersDictionary: anObject [
	"Set the value of shapeChangersDictionary"

	<category: 'accessing'>
	shapeChangersDictionary := anObject
    ]

    classAt: classId [
	<category: 'actions'>
	^self classIdsDictionary at: classId ifAbsent: []
    ]

    classNamed: localClassName in: environmentQualifier [
	<category: 'actions'>
	| qualifier isClassClass localClassNameSize className foundClass |
	qualifier := self settings useEnvironment ifTrue: [environmentQualifier].
	isClassClass := false.
	localClassNameSize := localClassName size.
	className := (localClassName at: localClassNameSize) = $$ 
		    ifTrue: 
			[isClassClass := true.
			localClassName copyFrom: 1 to: localClassNameSize - 1]
		    ifFalse: [localClassName].
	foundClass := self mappedClassAt: className asSymbol in: qualifier.
	isClassClass ifTrue: [foundClass := foundClass class].
	^foundClass
    ]

    environmentNameAt: envId [
	<category: 'actions'>
	^self environmentNamesDictionary at: envId ifAbsent: []
    ]

    instVarNamesWithIndicesAt: classId [
	<category: 'actions'>
	| klass |
	klass := self classAt: classId.
	^self instVarNamesWithIndicesDictionary at: klass ifAbsent: [#()]
    ]

    rememberClass: aClass [
	<category: 'actions'>
	^self classIdsDictionary at: self classIdsDictionary size put: aClass
    ]

    rememberEnvironmentName: aString [
	<category: 'actions'>
	^self environmentNamesDictionary at: self environmentNamesDictionary size
	    put: aString
    ]

    rememberInstVarNames: instVarNames indices: instVarIndices of: aClass [
	<category: 'actions'>
	| ord |
	ord := OrderedCollection new: instVarNames size.
	instVarNames with: instVarIndices
	    do: [:name :idx | ord add: (Array with: name with: idx)].
	self instVarNamesWithIndicesDictionary at: aClass put: ord.
	^ord
    ]

    clearFieldsInfo [
	<category: 'initialize-release'>
	fieldsInfo := nil
    ]

    mappedClassAt: classNameSymbol in: environmentQualifier [
	<category: 'private'>
	| classNameSymbolOrNewClass |
	classNameSymbolOrNewClass := self 
		    mappedClassNameAt: classNameSymbol asSymbol
		    in: environmentQualifier.
	^classNameSymbolOrNewClass isBehavior 
	    ifTrue: [classNameSymbolOrNewClass]
	    ifFalse: 
		[StompPortableUtil default classNamed: classNameSymbolOrNewClass
		    in: environmentQualifier]
    ]

    mappedClassNameAt: classNameSymbol in: environmentQualifier [
	<category: 'private'>
	| key |
	key := environmentQualifier isNil 
		    ifTrue: [classNameSymbol]
		    ifFalse: [Array with: environmentQualifier with: classNameSymbol].
	^self classAliasesDictionary at: key ifAbsent: [classNameSymbol]
    ]

    objectDictionaryClass [
	<category: 'defaults'>
	^Dictionary
    ]

    registerClassOldName: oldClassNameSymbol for: existingClass [
	<category: 'renaming'>
	^self 
	    registerClassOldName: oldClassNameSymbol
	    in: nil
	    for: existingClass
    ]

    registerClassOldName: oldClassNameSymbol in: oldEnvironmentQualifier for: existingClass [
	<category: 'renaming'>
	| key |
	key := oldEnvironmentQualifier isNil 
		    ifTrue: [oldClassNameSymbol]
		    ifFalse: [Array with: oldEnvironmentQualifier with: oldClassNameSymbol].
	^self classAliasesDictionary at: key put: existingClass
    ]

    registerClassOldName: oldClassNameSymbol in: oldEnvironmentQualifier shapeChanger: shapeChangerClass for: existingClass [
	<category: 'renaming'>
	self 
	    registerClassOldName: oldClassNameSymbol
	    in: oldEnvironmentQualifier
	    for: existingClass.
	self registerShapeChanger: shapeChangerClass for: existingClass
    ]

    registerClassOldName: oldClassNameSymbol shapeChanger: shapeChangerClass for: existingClass [
	<category: 'renaming'>
	self registerClassOldName: oldClassNameSymbol for: existingClass.
	self registerShapeChanger: shapeChangerClass for: existingClass
    ]

    registerShapeChanger: shapeChangerObject for: existingClass [
	<category: 'shape changing'>
	^self shapeChangersDictionary at: existingClass put: shapeChangerObject
    ]

    registerShapeChangerRenameBy: loadInstVarsBlock for: existingClass [
	<category: 'shape changing'>
	^self 
	    registerShapeChangerRenameBy: loadInstVarsBlock
	    initializeBy: nil
	    for: existingClass
    ]

    registerShapeChangerRenameBy: loadInstVarsBlock initializeBy: loadAdditionsBlock for: existingClass [
	<category: 'shape changing'>
	| changer |
	changer := StompBlockShapeChanger loadInstVarsBlock: loadInstVarsBlock
		    loadAdditionsBlock: loadAdditionsBlock.
	^self shapeChangersDictionary at: existingClass put: changer
    ]

    shapeChangerFor: existingClass [
	<category: 'shape changing'>
	shapeChangersDictionary ifNil: [^nil].
	^self shapeChangersDictionary at: existingClass ifAbsent: []
    ]
]



MpDecoder subclass: StompReader [
    | context version |
    
    <comment: nil>
    <category: 'Stomp-Core'>

    basicReadObject [
	"Never remembering"

	<category: 'private'>
	^(MpDecoder on: self readStream) readObject
    ]

    identifierStringFromBytes: byteArray [
	<category: 'private'>
	byteArray ifNil: [^nil].
	^self settings supportsMultibyteIdentifiers 
	    ifTrue: [self portableUtil stringFromBytes: byteArray]
	    ifFalse: [byteArray asString]
    ]

    initializeInstance: instance [
	<category: 'private'>
	| shapeChangerClass |
	instance stompInitialize.
	shapeChangerClass := self context shapeChangerFor: instance class.
	shapeChangerClass 
	    ifNotNil: [:foo | (shapeChangerClass on: instance) loadAdditions]
    ]

    readIdentifierString [
	<category: 'private'>
	| type sz |
	type := self readType.
	(sz := type bitAnd: 95 <= 31) 
	    ifTrue: [^self identifierStringFromBytes: (self readStream next: sz)].
	type = MpConstants raw16 
	    ifTrue: [^self identifierStringFromBytes: super readRaw16].
	type = MpConstants raw32 
	    ifTrue: [^self identifierStringFromBytes: super readRaw32]
    ]

    context [
	"Answer the value of context"

	<category: 'accessing'>
	^context ifNil: [context := StompReadContext on: self]
    ]

    context: anObject [
	"Set the value of context"

	<category: 'accessing'>
	context := anObject
    ]

    portableUtil [
	<category: 'accessing'>
	^MpPortableUtil stomp
    ]

    version [
	"Answer the value of version"

	<category: 'accessing'>
	^version
    ]

    version: anObject [
	"Set the value of version"

	<category: 'accessing'>
	version := anObject
    ]

    createDictionary: size [
	<category: 'factory'>
	| dic |
	dic := super createDictionary: size.
	self remember: dic.
	^dic
    ]

    settingsClass [
	<category: 'factory'>
	^StompSettings
    ]

    decodeFrom: aStream [
	<category: 'decoding'>
	| pos |
	self readStream: aStream.	"binary"
	pos := aStream position.
	(self portableUtil nextAvailable: 2 from: aStream) = StompConstants header 
	    ifTrue: [self version: aStream next asInteger].
	aStream position: pos.
	^self decode
    ]

    next [
	<category: 'stream-like'>
	^self readObject
    ]

    readArraySized: size [
	<category: 'dispatching'>
	size = 0 
	    ifTrue: 
		[| arr |
		self remember: (arr := self createArray: 0).
		^arr].
	^self readArraySized: size atFirstTyped: self readType
    ]

    readArraySized: size atFirst: firstElem [
	<category: 'dispatching'>
	| array |
	array := self createArray: size.
	self remember: array.
	array at: 1 put: firstElem.
	2 to: size do: [:idx | array at: idx put: self readObject].
	^array
    ]

    readArraySized: size atFirstTyped: firstType [
	<category: 'dispatching'>
	| array firstElem |
	array := self createArray: size.
	self remember: array.
	firstElem := self readObjectOf: firstType.
	array at: 1 put: firstElem.
	2 to: size do: [:idx | array at: idx put: self readObject].
	^array
    ]

    readObjectOf: type ifNotApplied: aBlock [
	<category: 'dispatching'>
	(type between: 144 and: 159) ifTrue: [^self readFixArray: type].
	^super readObjectOf: type ifNotApplied: aBlock
    ]

    readSmallArraySized: size [
	<category: 'dispatching'>
	| firstType |
	size = 0 
	    ifTrue: 
		[| arr |
		self remember: (arr := self createArray: 0).
		^arr].
	firstType := self readType.
	firstType = 161 
	    ifTrue: 
		[| firstByte |
		firstByte := self readStream next.
		^(StompConstants isTupleTag: firstByte) 
		    ifTrue: [self readTupleBy: firstByte]
		    ifFalse: [self readArraySized: size atFirst: (ByteArray with: firstByte)]].
	^self readArraySized: size atFirstTyped: firstType
    ]

    readTupleBy: tag [
	<category: 'dispatching'>
	tag = StompConstants value ifTrue: [^self readValue].
	tag = StompConstants reference ifTrue: [^self readReference].
	tag = StompConstants byteString ifTrue: [^self readByteString].
	tag = StompConstants byteSymbol ifTrue: [^self readByteSymbol].
	tag = StompConstants wideString ifTrue: [^self readWideString].
	tag = StompConstants wideSymbol ifTrue: [^self readWideString]
    ]

    readBitsOf: aClass [
	<category: 'reading-helper'>
	^aClass stompFromBytes: self basicReadObject
    ]

    readCollectionFieldsInto: anInstance [
	<category: 'reading-helper'>
	| size |
	size := self readSizeOfArray.
	^self readCollectionFieldsInto: anInstance sized: size
    ]

    readCollectionFieldsInto: anInstance sized: size [
	<category: 'reading-helper'>
	anInstance class isVariable 
	    ifTrue: [^self readIndexFieldsInto: anInstance sized: size].
	1 to: size do: [:idx | anInstance stompAdd: self readObject at: idx].
	^anInstance
    ]

    readIndexFieldsInto: anInstance sized: size [
	<category: 'reading-helper'>
	1 to: size do: [:idx | anInstance stompAt: idx put: self readObject].
	^anInstance
    ]

    readInstVarsInto: anInstance [
	<category: 'reading-helper'>
	| type arraySize varNames varIndices valueSize namesWithIndices values |
	type := self readType.
	arraySize := (type bitShift: -4) = 9 
		    ifTrue: [type bitAnd: 15]
		    ifFalse: 
			[type = 220 
			    ifTrue: [MpPortableUtil default readUint16From: self readStream]].
	arraySize ifNotNil: 
		[:foo | 
		^self readInstVarsInto: anInstance
		    fromInstVarReferenceArraySized: arraySize].
	varNames := self basicReadObject 
		    collect: [:each | self identifierStringFromBytes: each].
	varIndices := self portableUtil instVarIndicesOf: anInstance class
		    from: varNames.
	namesWithIndices := self context 
		    rememberInstVarNames: varNames
		    indices: varIndices
		    of: anInstance class.
	valueSize := self readSizeOfArray.
	values := OrderedCollection new: valueSize.
	valueSize timesRepeat: [values add: self readObject].
	^self 
	    readInstVarsInto: anInstance
	    namesWithIndices: namesWithIndices
	    values: values
    ]

    readInstanceContentAt: classId [
	<category: 'reading-helper'>
	| actualClass |
	actualClass := self context classAt: classId.
	^self readInstanceContentOf: actualClass
    ]

    readInstanceContentClassCoded: clsCode [
	<category: 'reading-helper'>
	| actualClass |
	actualClass := self portableUtil popularClassMap classAt: clsCode.
	actualClass ifNil: 
		[actualClass := StompClassNotFound signal: clsCode printString
			    context: self context].
	^self readInstanceContentOf: actualClass
    ]

    readInstanceContentClassNamed: clsName in: envName [
	<category: 'reading-helper'>
	| actualClass |
	actualClass := self context classNamed: clsName in: envName.
	actualClass ifNil: 
		[actualClass := StompClassNotFound 
			    signal: clsName
			    environment: envName
			    context: self context].
	self context rememberClass: actualClass.
	^self readInstanceContentOf: actualClass
    ]

    readInstanceContentOf: aClass [
	<category: 'reading-helper'>
	| inst newInst newKey |
	inst := aClass stompCreateInstanceFrom: self.
	newKey := self remember: inst.
	aClass stompLoadContentsOnCreation 
	    ifFalse: [inst stompReadContentFrom: self].
	self initializeInstance: inst.
	newInst := inst stompReadValue.
	newKey ifNotNil: [:foo | self remember: newInst at: newKey].
	^newInst
    ]

    readSizeOfArray [
	<category: 'reading-helper'>
	^self readSizeOfArrayIfMatched: self readType
    ]

    readSizeOfArrayIfMatched: type [
	<category: 'reading-helper'>
	(type bitShift: -4) = 9 ifTrue: [^type bitAnd: 15].
	type = MpConstants array16 
	    ifTrue: [^MpPortableUtil default readUint16From: self readStream].
	type = MpConstants array32 
	    ifTrue: [^MpPortableUtil default readUint32From: self readStream].
	^-1
    ]

    readUIntIfMatched: type [
	<category: 'reading-helper'>
	type <= 127 ifTrue: [^self readPositiveFixNum: type].
	type = MpConstants uint8 ifTrue: [^self readUint8].
	type = MpConstants uint16 ifTrue: [^self readUint16].
	type = MpConstants uint32 ifTrue: [^self readUint32].
	type = MpConstants uint64 ifTrue: [^self readUint64].
	^-1
    ]

    readByteString [
	<category: 'reading-dispatched'>
	^self basicReadObject asString
    ]

    readByteSymbol [
	<category: 'reading-dispatched'>
	^self readByteString asSymbol
    ]

    readReference [
	<category: 'reading-dispatched'>
	| refId |
	refId := self readObject.
	^(self context at: refId) yourself
    ]

    readValue [
	<category: 'reading-dispatched'>
	| type attributesSize attribDict newInst |
	type := self readType.
	(type bitShift: -4) = 8 
	    ifFalse: 
		[| id |
		id := self readObjectOf: type.
		^id < 0 
		    ifTrue: [self readInstanceContentClassCoded: id negated]
		    ifFalse: [self readInstanceContentAt: id]].
	attributesSize := type bitAnd: 15.
	attributesSize = 1 
	    ifTrue: 
		[| key value |
		key := self readPositiveFixNum: self readStream next.
		value := self basicReadObject.
		key = StompConstants klassName 
		    ifTrue: 
			[^self 
			    readInstanceContentClassNamed: (self identifierStringFromBytes: value)
			    in: nil]].
	attribDict := Dictionary new: attributesSize.
	1 to: attributesSize
	    do: 
		[:idx | 
		attribDict at: (self readPositiveFixNum: self readStream next)
		    put: self basicReadObject].
	newInst := self readValueWithAttributes: attribDict.
	^newInst
    ]

    readWideString [
	<category: 'reading-dispatched'>
	^self portableUtil stringFromBytes: self basicReadObject
    ]

    readWideSymbol [
	<category: 'reading-dispatched'>
	^self readWideString asSymbol
    ]

    readFixArray: firstByte [
	<category: 'reading-primitives'>
	| size |
	size := firstByte bitAnd: 15.
	^self readSmallArraySized: size
    ]

    readFixRaw: type [
	<category: 'reading-primitives'>
	| bytes |
	bytes := super readFixRaw: type.
	self remember: bytes.
	^bytes
    ]

    readRaw16 [
	<category: 'reading-primitives'>
	| bytes |
	bytes := super readRaw16.
	self remember: bytes.
	^bytes
    ]

    readRaw32 [
	<category: 'reading-primitives'>
	| bytes |
	bytes := super readRaw32.
	self remember: bytes.
	^bytes
    ]

    readInstVarsInto: anInstance fromInstVarReferenceArraySized: arraySize [
	<category: 'reading-instance variables'>
	| id namesWithIndices values |
	id := self basicReadObject.
	namesWithIndices := self context instVarNamesWithIndicesAt: id.
	values := Array new: namesWithIndices size.
	1 to: values size do: [:idx | values at: idx put: self readObject].
	self 
	    readInstVarsInto: anInstance
	    namesWithIndices: namesWithIndices
	    values: values
    ]

    readInstVarsInto: anInstance namesWithIndices: varNamesWithIndices values: varValues [
	<category: 'reading-instance variables'>
	| shapeChangerClass |
	shapeChangerClass := self context shapeChangerFor: anInstance class.
	shapeChangerClass ifNil: 
		[varNamesWithIndices with: varValues
		    do: 
			[:nameWithIndex :value | 
			anInstance 
			    stompInstVarAt: (nameWithIndex at: 2)
			    named: (nameWithIndex at: 1)
			    put: value]]
	    ifNotNil: 
		[:foo | 
		| shapeChanger |
		shapeChanger := shapeChangerClass on: anInstance.
		varNamesWithIndices with: varValues
		    do: 
			[:nameWithIndex :value | 
			shapeChanger 
			    loadInstVarAt: (nameWithIndex at: 2)
			    named: (nameWithIndex at: 1)
			    put: value]].
	^anInstance
    ]

    readPrimitiveValues [
	"Assuming <= 15 fields"

	<category: 'reading-custom'>
	| inst size |
	size := self readStream next bitAnd: 15.
	inst := self createArray: size.
	size = 0 ifTrue: [^inst].
	^super readArraySized: size
    ]

    readValueWithAttributes: attribDict [
	<category: 'reading-attributes'>
	| clsName envName |
	clsName := self 
		    identifierStringFromBytes: (attribDict at: StompConstants klassName
			    ifAbsent: []).
	envName := self 
		    identifierStringFromBytes: (attribDict at: StompConstants environmentName
			    ifAbsent: []).
	envName ifNil: 
		[envName := self context 
			    environmentNameAt: (attribDict at: StompConstants environmentId ifAbsent: [])]
	    ifNotNil: [:foo | self context rememberEnvironmentName: envName].
	^self readInstanceContentClassNamed: clsName in: envName
    ]

    remember: anObject [
	<category: 'remembering'>
	^self remember: anObject at: self context size
    ]

    remember: anObject at: key [
	<category: 'remembering'>
	anObject class = StompClassNotFound 
	    ifTrue: 
		[self context at: key put: nil.
		^key].
	(self supportsReferenceFor: anObject) ifFalse: [^nil].
	self context at: key put: anObject.
	^key
    ]

    supportsReferenceFor: anObject [
	<category: 'testing'>
	^anObject stompSupportsReference: self context
    ]
]



MpSettings subclass: StompSettings [
    
    <comment: nil>
    <category: 'Stomp-Core'>

    supportsMultibyteIdentifiers [
	<category: 'accessing'>
	^self at: #supportsMultibyteIdentifiers ifAbsentPut: [false]
    ]

    supportsMultibyteIdentifiers: aBoolean [
	<category: 'accessing'>
	^self at: #supportsMultibyteIdentifiers put: aBoolean
    ]

    suppressNilWrite [
	<category: 'accessing'>
	^self writeVariableDefinitionsAsReference not
    ]

    suppressNilWrite: aBoolean [
	<category: 'accessing'>
	^self writeVariableDefinitionsAsReference: (aBoolean == true) not
    ]

    useEnvironment [
	<category: 'accessing'>
	^self at: #useEnvironment
	    ifAbsentPut: [StompPortableUtil default useEnvironmentByDefault]
    ]

    useEnvironment: aBoolean [
	<category: 'accessing'>
	^self at: #useEnvironment put: aBoolean
    ]

    withHeader [
	<category: 'accessing'>
	^self at: #withHeader ifAbsentPut: [false]
    ]

    withHeader: aBoolean [
	<category: 'accessing'>
	^self at: #withHeader put: aBoolean
    ]

    writeVariableDefinitionsAsReference [
	<category: 'accessing'>
	^self at: #writeVariableDefinitionsAsReference ifAbsentPut: [true]
    ]

    writeVariableDefinitionsAsReference: aBoolean [
	<category: 'accessing'>
	^self at: #writeVariableDefinitionsAsReference put: aBoolean
    ]
]



Object subclass: StompShapeChanger [
    | targetInstance |
    
    <category: 'Stomp-Core'>
    <comment: nil>

    StompShapeChanger class >> on: anInstance [
	<category: 'instance creation'>
	^(self new)
	    on: anInstance;
	    yourself
    ]

    loadAdditions [
	"override"

	<category: 'actions'>
	
    ]

    loadInstVarAt: varIndex named: varName put: varValue [
	"override"

	<category: 'actions'>
	self targetInstance 
	    stompInstVarAt: varIndex
	    named: varName
	    put: varValue
    ]

    on: anInstance [
	<category: 'initialize-release'>
	self targetInstance: anInstance
    ]

    targetInstance [
	"Answer the value of targetInstance"

	<category: 'accessing'>
	^targetInstance
    ]

    targetInstance: anObject [
	"Set the value of targetInstance"

	<category: 'accessing'>
	targetInstance := anObject
    ]
]



StompShapeChanger subclass: StompBlockShapeChanger [
    | loadInstVarsBlock loadAdditionsBlock |
    
    <category: 'Stomp-Core'>
    <comment: nil>

    StompBlockShapeChanger class >> loadInstVarsBlock: loadInstVarsBlock loadAdditionsBlock: loadAdditionsBlock [
	<category: 'instance creation'>
	| inst |
	inst := self new.
	inst loadInstVarsBlock: loadInstVarsBlock.
	inst loadAdditionsBlock: loadAdditionsBlock.
	^inst
    ]

    loadAdditions [
	<category: 'actions'>
	loadAdditionsBlock 
	    ifNotNil: [:foo | loadAdditionsBlock value: self targetInstance]
    ]

    loadInstVarAt: varIndex named: varName put: varValue [
	<category: 'actions'>
	loadInstVarsBlock ifNotNil: 
		[:foo | 
		loadInstVarsBlock 
		    value: self targetInstance
		    value: varName
		    value: varValue].
	super 
	    loadInstVarAt: varIndex
	    named: varName
	    put: varValue
    ]

    loadAdditionsBlock [
	"Answer the value of loadAdditionsBlock"

	<category: 'accessing'>
	^loadAdditionsBlock
    ]

    loadAdditionsBlock: anObject [
	"Set the value of loadAdditionsBlock"

	<category: 'accessing'>
	loadAdditionsBlock := anObject
    ]

    loadInstVarsBlock [
	"Answer the value of loadInstVarsBlock"

	<category: 'accessing'>
	^loadInstVarsBlock
    ]

    loadInstVarsBlock: anObject [
	"Set the value of loadInstVarsBlock"

	<category: 'accessing'>
	loadInstVarsBlock := anObject
    ]
]



Warning subclass: StompWarning [
    | className element context |
    
    <category: 'Stomp-Core'>
    <comment: nil>

    StompWarning class [
	| suppressTranscriptLogging suppressSignaling |
	
    ]

    StompWarning class >> initialize [
	"StompWarning initialize"

	<category: 'class initialization'>
	suppressSignaling := nil.
	suppressTranscriptLogging := nil
    ]

    StompWarning class >> signal: className [
	<category: 'instance creation'>
	^self signal: className context: nil
    ]

    StompWarning class >> signal: className context: dictionary [
	<category: 'instance creation'>
	^self new signal: className context: dictionary
    ]

    StompWarning class >> suppressSignaling [
	<category: 'accessing'>
	^suppressSignaling ifNil: [suppressSignaling := false]
    ]

    StompWarning class >> suppressSignaling: anObject [
	"Set the value of suppressSignaling"

	<category: 'accessing'>
	suppressSignaling := anObject
    ]

    StompWarning class >> suppressTranscriptLogging [
	<category: 'accessing'>
	^suppressTranscriptLogging ifNil: [suppressTranscriptLogging := false]
    ]

    StompWarning class >> suppressTranscriptLogging: anObject [
	"Set the value of suppressTranscriptLogging"

	<category: 'accessing'>
	suppressTranscriptLogging := anObject
    ]

    className [
	<category: 'accessing'>
	className ifNil: [^className].
	^className asSymbol
    ]

    className: aValue [
	<category: 'accessing'>
	className := aValue
    ]

    context [
	<category: 'accessing'>
	^context
    ]

    context: aValue [
	<category: 'accessing'>
	context := aValue
    ]

    element [
	<category: 'accessing'>
	^element
    ]

    element: aValue [
	<category: 'accessing'>
	element := aValue
    ]

    defaultAction [
	<category: 'exceptionDescription'>
	self class suppressTranscriptLogging 
	    ifFalse: 
		[Transcript
		    cr;
		    show: '#warning# ' , self description].
	self resume
    ]

    signal: aClassName context: dictionary [
	<category: 'signaling'>
	self class suppressSignaling ifTrue: [^self].
	self className: aClassName.
	self context: dictionary.
	^MpPortableUtil default signalException: self
    ]
]



StompWarning subclass: StompClassNotFound [
    | environmentName |
    
    <category: 'Stomp-Core'>
    <comment: nil>

    StompClassNotFound class >> signal: className environment: envName context: dictionary [
	<category: 'instance creation'>
	| inst |
	inst := self new.
	inst environmentName: envName.
	^inst signal: className context: dictionary
    ]

    berstReadValue [
	<category: 'factory'>
	^nil
    ]

    stompReadValue [
	<category: 'factory'>
	^nil
    ]

    unresolvedClass [
	"By default my class act as an unresolved class, which instantiate nil"

	<category: 'factory'>
	^self class
    ]

    defaultAction [
	<category: 'exceptionDescription'>
	Transcript
	    cr;
	    show: '#warning# ' , self description.
	^self unresolvedClass
    ]

    description [
	<category: 'exceptionDescription'>
	^super description , ': ' , self className printString
    ]

    environmentName [
	"Answer the value of environmentName"

	<category: 'accessing'>
	environmentName ifNil: [^environmentName].
	^environmentName
    ]

    environmentName: anObject [
	"Set the value of environmentName"

	<category: 'accessing'>
	environmentName := anObject
    ]
]



StompWarning subclass: StompInvalidDeserialization [
    
    <category: 'Stomp-Core'>
    <comment: nil>

    description [
	<category: 'exceptionDescription'>
	^super description , ': ' , self className printString
    ]
]



StompWarning subclass: StompInvalidSerialization [
    
    <category: 'Stomp-Core'>
    <comment: nil>

    description [
	<category: 'exceptionDescription'>
	^super description , ': ' , self className printString
    ]
]



StompWarning subclass: StompNewFailed [
    
    <category: 'Stomp-Core'>
    <comment: nil>
]



StompContext subclass: StompWriteContext [
    | classesDictionary environmentsDictionary instVarNamesWithIndicesDictionary |
    
    <category: 'Stomp-Core'>
    <comment: nil>

    classIdOf: aClass [
	<category: 'actions'>
	^self classesDictionary at: aClass
    ]

    environmentIdOf: aClass [
	<category: 'actions'>
	^self environmentsDictionary at: aClass
    ]

    includesClass: aClass [
	<category: 'actions'>
	^self classesDictionary includesKey: aClass
    ]

    includesEnvironment: anEnvironment [
	<category: 'actions'>
	self settings useEnvironment ifFalse: [^false].
	^self environmentsDictionary includesKey: anEnvironment
    ]

    instVarNamesWithIndicesOf: aClass [
	<category: 'actions'>
	^self instVarNamesWithIndicesDictionary at: aClass ifAbsent: []
    ]

    rememberClass: aClass [
	<category: 'actions'>
	^self classesDictionary at: aClass put: self classesDictionary size
    ]

    rememberEnvironment: anEnvironment [
	<category: 'actions'>
	self settings useEnvironment ifFalse: [^self].
	anEnvironment name == #Smalltalk ifTrue: [^self].
	^self environmentsDictionary at: anEnvironment
	    put: self environmentsDictionary size
    ]

    rememberInstVarNames: instVarNames indices: instVarIndices of: aClass [
	<category: 'actions'>
	| ord |
	ord := OrderedCollection new: instVarNames size.
	instVarNames with: instVarIndices
	    do: [:name :idx | ord add: (Array with: name with: idx)].
	self instVarNamesWithIndicesDictionary at: aClass put: ord.
	^ord
    ]

    rememberReferenceOf: originalObject [
	<category: 'actions'>
	self at: originalObject put: self size
    ]

    classesDictionary [
	<category: 'accessing'>
	^classesDictionary ifNil: [classesDictionary := IdentityDictionary new]
    ]

    classesDictionary: anObject [
	"Set the value of classesDictionary"

	<category: 'accessing'>
	classesDictionary := anObject
    ]

    environmentsDictionary [
	<category: 'accessing'>
	^environmentsDictionary 
	    ifNil: [environmentsDictionary := IdentityDictionary new]
    ]

    environmentsDictionary: anObject [
	"Set the value of environmentsDictionary"

	<category: 'accessing'>
	environmentsDictionary := anObject
    ]

    instVarNamesWithIndicesDictionary [
	<category: 'accessing'>
	^instVarNamesWithIndicesDictionary 
	    ifNil: [instVarNamesWithIndicesDictionary := IdentityDictionary new]
    ]

    instVarNamesWithIndicesDictionary: anObject [
	"Set the value of instVarNamesWithIndicesDictionary"

	<category: 'accessing'>
	instVarNamesWithIndicesDictionary := anObject
    ]
]



MpEncoder subclass: StompWriter [
    | context |
    
    <comment: nil>
    <category: 'Stomp-Core'>

    addClassNameAttributeTo: attributes for: writeObject [
	<category: 'writing-attributes'>
	^attributes add: StompConstants klassName 
		    -> (self bytesFromIdentifierString: (self classNameOf: writeObject))
    ]

    addClassSpecifierAttributesTo: attributes for: writeObject [
	<category: 'writing-attributes'>
	| writeObjectClass |
	writeObjectClass := writeObject class.
	self addClassNameAttributeTo: attributes for: writeObject.
	self context rememberClass: writeObjectClass.
	(self context includesEnvironment: writeObjectClass environment) 
	    ifTrue: 
		[| envId |
		envId := self context environmentIdOf: writeObjectClass environment.
		self addEnvironmentIdAttributeTo: attributes id: envId]
	    ifFalse: 
		[self addEnvironmentNameAttributeTo: attributes for: writeObject.
		self context rememberEnvironment: writeObjectClass environment]
    ]

    addEnvironmentIdAttributeTo: attributes id: envId [
	<category: 'writing-attributes'>
	^attributes add: StompConstants environmentId -> envId
    ]

    addEnvironmentNameAttributeTo: attributes for: writeObject [
	<category: 'writing-attributes'>
	| env |
	self settings useEnvironment ifFalse: [^self].
	(self portableUtil shouldWriteEnvironmentNameOf: writeObject) 
	    ifFalse: [^self].
	env := self portableUtil environmentNameOf: writeObject.
	^attributes add: StompConstants environmentName 
		    -> (self bytesFromIdentifierString: env)
    ]

    classNameOf: anObject [
	<category: 'writing-attributes'>
	| kls |
	kls := anObject class.
	^(self portableUtil isMeta: kls) 
	    ifTrue: [(self portableUtil soleInstanceOf: kls) name , '$']
	    ifFalse: [kls name]
    ]

    basicWriteInstVarsOf: writeObject [
	<category: 'writing-helper'>
	| instVarNamesWithIndices |
	instVarNamesWithIndices := self 
		    writtenInstVarNamesWithIndicesOf: writeObject.
	self writeMapSize: 1.
	self writeArraySize: instVarNamesWithIndices size.
	instVarNamesWithIndices 
	    do: [:each | super writeObject: (self bytesFromIdentifierString: (each at: 1))].
	self writeArraySize: instVarNamesWithIndices size.
	instVarNamesWithIndices do: 
		[:nmAndIndex | 
		| nm idx val |
		nm := nmAndIndex at: 1.
		idx := nmAndIndex at: 2.
		val := writeObject stompInstVarNamed: nm
			    writtenAs: (writeObject instVarAt: idx).
		self writeObject: val]
    ]

    writeAll: collObject [
	<category: 'writing-helper'>
	| sz |
	sz := collObject size.
	self writeArraySize: sz.
	collObject stompDo: [:each | self nextPut: each]
    ]

    writeBitsOf: writeObject [
	<category: 'writing-helper'>
	self writeRawBytes: writeObject stompBytes
    ]

    writeContent: writeObject [
	<category: 'writing-helper'>
	writeObject stompWriteContentTo: self
    ]

    writeContent: object tag: tag attributes: attribs [
	<category: 'writing-helper'>
	| sz |
	sz := 2 + object stompValueContentSize.
	self writeArraySize: sz.
	self writeTag: tag.
	self writeMapSize: attribs size.
	attribs do: 
		[:assoc | 
		self writePositiveFixNum: assoc key.
		super writeObject: assoc value].
	self writeContent: object
    ]

    writeIndexFieldsOf: writeObject [
	<category: 'writing-helper'>
	self writeAll: writeObject
    ]

    writeInstVarsOf: writeObject [
	<category: 'writing-helper'>
	| cachedNamesWithIndices |
	self settings suppressNilWrite 
	    ifTrue: [^self writeNotNilInstVarsOf: writeObject].

	(cachedNamesWithIndices := self context 
		    instVarNamesWithIndicesOf: writeObject class) 
		ifNotNil: [:foo | ^self writeInstVarsOf: writeObject using: cachedNamesWithIndices].

	self basicWriteInstVarsOf: writeObject
    ]

    writeInstVarsOf: writeObject using: cachedNamesWithIndices [
	<category: 'writing-helper'>
	| classId |
	classId := self context classIdOf: writeObject class.
	classId ifNil: [^self basicWriteInstVarsOf: writeObject].
	self writeArraySize: cachedNamesWithIndices size + 1.
	self writeObject: classId.
	cachedNamesWithIndices do: 
		[:nmAndIndex | 
		| nm idx val |
		nm := nmAndIndex at: 1.
		idx := nmAndIndex at: 2.
		val := writeObject stompInstVarNamed: nm
			    writtenAs: (writeObject instVarAt: idx).
		self writeObject: val]
    ]

    writeMixedFieldsOf: writeObject [
	<category: 'writing-helper'>
	| shouldWriteInstanceVariables |
	writeObject class instSize = 0 
	    ifTrue: [^self writeIndexFieldsOf: writeObject].
	shouldWriteInstanceVariables := writeObject 
		    stompShouldWriteInstanceVariables.
	shouldWriteInstanceVariables 
	    ifTrue: 
		[self writeObject: writeObject size.
		self writeInstVarsOf: writeObject].
	self writeIndexFieldsOf: writeObject
    ]

    writeNotNilInstVarsOf: writeObject [
	<category: 'writing-helper'>
	| instVarNamesWithIndices nameAndValues |
	instVarNamesWithIndices := self 
		    writtenInstVarNamesWithIndicesOf: writeObject.
	nameAndValues := OrderedCollection new.
	instVarNamesWithIndices do: 
		[:nmAndIndex | 
		| nm idx val |
		nm := nmAndIndex at: 1.
		idx := nmAndIndex at: 2.
		val := writeObject stompInstVarNamed: nm
			    writtenAs: (writeObject instVarAt: idx).
		val ifNotNil: 
			[:foo | 
			nameAndValues 
			    add: (Array with: (self bytesFromIdentifierString: nm) with: val)]].
	self writeMapSize: 1.
	self writeArraySize: nameAndValues size.
	nameAndValues do: [:each | super writeObject: (each at: 1)].
	self writeArraySize: nameAndValues size.
	nameAndValues do: [:each | self writeObject: (each at: 2)]
    ]

    writeTag: tagInt [
	"tagInt should be 0-255"

	<category: 'writing-helper'>
	self writeStream nextPut: 161.
	self writeStream nextPut: tagInt
    ]

    writeVersion [
	<category: 'writing-helper'>
	self writeStream nextPutAll: StompConstants header.
	self writeStream nextPut: self defaultVersion	"1-255"
    ]

    writtenInstVarNamesWithIndicesOf: writeObject [
	<category: 'writing-helper'>
	| writeObjectClass cachedNamesIndices instVarNames transientInstVarNames instVarIndices |
	writeObjectClass := writeObject class.
	(cachedNamesIndices := self context 
		    instVarNamesWithIndicesOf: writeObjectClass) 
		ifNotNil: [:foo | ^cachedNamesIndices].

	instVarNames := (writeObjectClass allInstVarNames collect:[:e | e asString] )asOrderedCollection.
	transientInstVarNames := writeObject stompTransientInstVarNames.
	transientInstVarNames := transientInstVarNames 
		    collect: [:each | each asString].
	transientInstVarNames do: [:each | instVarNames remove: each ifAbsent: []].
	instVarIndices := self portableUtil instVarIndicesOf: writeObjectClass
		    from: instVarNames.
	^self context 
	    rememberInstVarNames: instVarNames
	    indices: instVarIndices
	    of: writeObjectClass
    ]

    bytesFromIdentifierString: aString [
	"Usually class & variable names are single bytes"

	<category: 'private'>
	^self settings supportsMultibyteIdentifiers 
	    ifTrue: [self portableUtil bytesFromString: aString]
	    ifFalse: [aString asByteArray]
    ]

    rememberReferenceOf: originalObject [
	<category: 'private'>
	^self context rememberReferenceOf: originalObject
    ]

    context [
	"Answer the value of context"

	<category: 'accessing'>
	^context ifNil: [context := StompWriteContext on: self]
    ]

    context: anObject [
	"Set the value of context"

	<category: 'accessing'>
	context := anObject
    ]

    portableUtil [
	<category: 'accessing'>
	^MpPortableUtil stomp
    ]

    debugEncode: bytes [
	<category: 'debugging'>
	| encoded counterDic decoder |
	encoded := self encode: bytes.
	self context objectsDictionary.
	counterDic := Dictionary new.
	self context objectsDictionary 
	    keysAndValuesDo: [:k :v | counterDic at: v put: k].
	counterDic inspect.
	decoder := StompReader new.
	decoder decode: encoded.
	decoder context objectsDictionary inspect.
	^encoded
    ]

    defaultVersion [
	"Stomp version 1"

	<category: 'constants'>
	^1
    ]

    nextPut: anObject [
	<category: 'stream-like'>
	self writeStompFrom: anObject
    ]

    nextPutAll: aCollectionOfObject [
	<category: 'stream-like'>
	aCollectionOfObject do: [:each | self nextPut: each]
    ]

    putReferenceOf: anObject ifExists: aBlock [
	<category: 'testing'>
	| refId |
	refId := self context at: anObject ifAbsent: [].
	refId notNil ifTrue: [^aBlock value: refId].
	self rememberReferenceOf: anObject
    ]

    supportsReferenceFor: anObject [
	<category: 'testing'>
	^anObject stompSupportsReference: self context
    ]

    settingsClass [
	<category: 'factory'>
	^StompSettings
    ]

    writeByteString: aString [
	<category: 'writing'>
	self writeArraySize: 2.
	self writeTag: StompConstants byteString.
	self writeRawBytes: aString asByteArray
    ]

    writeByteSymbol: aSymbol [
	<category: 'writing'>
	self writeArraySize: 2.
	self writeTag: StompConstants byteSymbol.
	self writeRawBytes: aSymbol asByteArray
    ]

    writeEmbeddedValue: writeObject ifNotApplied: aBlock [
	<category: 'writing'>
	writeObject isSymbol ifTrue: [^self writeSymbol: writeObject].
	writeObject isString ifTrue: [^self writeString: writeObject].
	^aBlock value
    ]

    writeReference: refId [
	<category: 'writing'>
	self writeArraySize: 2.
	self writeTag: StompConstants reference.
	self writeInteger: refId
    ]

    writeStandardValue: writeObject [
	<category: 'writing'>
	| sz writeObjectClass attributes |
	sz := 2 + writeObject stompValueContentSize.
	self writeArraySize: sz.
	self writeTag: StompConstants value.
	writeObjectClass := writeObject class.

	self portableUtil popularClassMap codeAt: writeObjectClass
	    ifPresent: 
		[:code | 
		self writeInteger: code negated.
		^self writeContent: writeObject].

	(self context includesClass: writeObjectClass) 
	    ifTrue: 
		[| classId |
		classId := self context classIdOf: writeObjectClass.
		self writeInteger: classId.
		^self writeContent: writeObject].
	attributes := OrderedCollection new.

	self addClassSpecifierAttributesTo: attributes for: writeObject.
	self writeMapSize: attributes size.
	attributes do: 
		[:assoc | 
		self writePositiveFixNum: assoc key.
		super writeObject: assoc value].
	self writeContent: writeObject
    ]

    writeString: aString [
	<category: 'writing'>
	(self portableUtil isWideString: aString) 
	    ifTrue: [^self writeWideString: aString].
	self writeByteString: aString
    ]

    writeSymbol: aSymbol [
	<category: 'writing'>
	(self portableUtil isWideSymbol: aSymbol) 
	    ifTrue: [^self writeWideSymbol: aSymbol].
	self writeByteSymbol: aSymbol
    ]

    writeValue: writeObject [
	<category: 'writing'>
	^self writeEmbeddedValue: writeObject
	    ifNotApplied: [self writeObject: writeObject
	      ifNotApplied: [self writeStandardValue: writeObject]]
    ]

    writeWideString: aString [
	<category: 'writing'>
	self writeArraySize: 2.
	self writeTag: StompConstants wideString.
	self writeRawBytes: (self portableUtil bytesFromString: aString)
    ]

    writeWideSymbol: aSymbol [
	<category: 'writing'>
	self writeArraySize: 2.
	self writeTag: StompConstants wideSymbol.
	self writeRawBytes: (self portableUtil bytesFromString: aSymbol)
    ]

    writeObject: anObject [
	"Main dispatching method"

	<category: 'dispatching'>
	| writeObject |
	anObject stompPrepareWrite.
	(self supportsReferenceFor: anObject) 
	    ifTrue: 
		[self putReferenceOf: anObject
		    ifExists: [:refId | ^self writeReference: refId]].
	writeObject := anObject stompWriteValue.
	self writeValue: writeObject.
	anObject stompAfterWrite
    ]

    writeStompFrom: anObject [
	<category: 'dispatching'>
	(self settings withHeader and: [self writeStream position = 0]) 
	    ifTrue: [self writeVersion].
	self writeObject: anObject
    ]

    writePrimitiveValues: anArray [
	"MessagePack types only"

	"Never store object refs"

	<category: 'writing-custom'>
	^super writeObject: anArray
    ]
]



Object extend [

    stompAfterWrite [
	<category: '*Stomp-Core-writing'>
	
    ]

    stompBytes [
	"For bytes, words object"

	"override"

	<category: '*Stomp-Core-writing'>
	^StompPortableUtil default bytesFrom: self
    ]

    stompDo: aBlock [
	<category: '*Stomp-Core-writing'>
	self class isFixed 
	    ifTrue: 
		["I'm not an Collection - so just write myself"

		^aBlock value: self].
	self size = 0 ifTrue: [^aBlock value: self].
	1 to: self size do: [:idx | aBlock value: (self at: idx)]
    ]

    stompInstVarNamed: varName writtenAs: writtenValue [
	"override"

	<category: '*Stomp-Core-writing'>
	^writtenValue
    ]

    stompPrepareWrite [
	<category: '*Stomp-Core-writing'>
	
    ]

    stompTransientInstVarNames [
	"override"

	<category: '*Stomp-Core-writing'>
	^#()
    ]

    stompValueContentSize [
	"For Mixed class which would like to write instance variables"

	<category: '*Stomp-Core-writing'>
	((self stompShouldWriteInstanceVariables and: [self class isVariable]) 
	    and: [self class instSize > 0]) ifTrue: [^3].
	^1
    ]

    stompWriteContentTo: stompWriter [
	"Override as you wish"

	"Provides basic dispatch to stompWriter"

	<category: '*Stomp-Core-writing'>
	| cls |
	cls := self class.
	cls isBits ifTrue: [^stompWriter writeBitsOf: self].
	cls isVariable ifTrue: [^stompWriter writeMixedFieldsOf: self].
	^stompWriter writeInstVarsOf: self
    ]

    stompWriteValue [
	<category: '*Stomp-Core-writing'>
	^self
    ]

    toStomp [
	<category: '*Stomp-Core-writing'>
	^StompWriter encode: self
    ]

    stompAt: index put: aValue [
	"override if you like"

	<category: '*Stomp-Core-reading'>
	self at: index put: aValue
    ]

    stompBasicReadContentFrom: stompReader [
	<category: '*Stomp-Core-reading'>
	| fieldsInfo |
	self class isFixed ifTrue: [^stompReader readInstVarsInto: self].
	fieldsInfo := stompReader context fieldsInfo.
	fieldsInfo isPureIndexFields 
	    ifTrue: 
		[^stompReader readIndexFieldsInto: self sized: fieldsInfo indexFieldSize].
	fieldsInfo isMixedFields 
	    ifTrue: 
		[self stompShouldWriteInstanceVariables 
		    ifTrue: [stompReader readInstVarsInto: self].
		stompReader readIndexFieldsInto: self sized: stompReader readSizeOfArray].
	^self
    ]

    stompInitialize [
	"override if you like"

	<category: '*Stomp-Core-reading'>
	
    ]

    stompInstVarAt: instVarIndex named: varName put: aValue [
	<category: '*Stomp-Core-reading'>
	instVarIndex = 0 
	    ifTrue: 
		[^StompPortableUtil default 
		    instVarNamed: varName
		    put: aValue
		    in: self].
	self instVarAt: instVarIndex put: aValue
    ]

    stompReadContentFrom: stompReader [
	"override"

	<category: '*Stomp-Core-reading'>
	^self stompBasicReadContentFrom: stompReader
    ]

    stompReadValue [
	"override if you like"

	<category: '*Stomp-Core-reading'>
	^self
    ]

    stompShouldWriteInstanceVariables [
	<category: '*Stomp-Core-testing'>
	^true
    ]

    stompSupportsReference: stompContext [
	"override"

	<category: '*Stomp-Core-testing'>
	^true
    ]

]



Behavior extend [

    fromStomp: bytes [
	<category: '*Stomp-Core-reading'>
	^StompReader decode: bytes
    ]

    fromStomp: bytes setting: aBlock [
	<category: '*Stomp-Core-reading'>
	| context reader |
	reader := StompReader new.
	context := reader context.
	aBlock value: context.
	^reader decode: bytes
    ]

    stompCreateBitsInstanceFrom: stompReader [
	<category: '*Stomp-Core-instance creation-helper'>
	^stompReader readBitsOf: self
    ]

    stompCreateFixedInstanceFrom: stompReader [
	<category: '*Stomp-Core-instance creation-helper'>
	^self stompCreateInstance
    ]

    stompCreateMixedInstanceFrom: stompReader [
	<category: '*Stomp-Core-instance creation-helper'>
	| type size indexFieldSize |
	type := stompReader readType.
	size := stompReader readSizeOfArrayIfMatched: type.
	size = 0 ifTrue: [^self stompCreateInstance].
	size >= 1 
	    ifTrue: 
		[stompReader context 
		    fieldsInfo: (StompFieldsInfo pureIndexFieldsSized: size).
		^self stompCreateInstance: size].

	"Otherwise, mixed fields"
	indexFieldSize := stompReader readUIntIfMatched: type.
	stompReader context fieldsInfo: StompFieldsInfo mixedFields.
	^self stompCreateInstance: indexFieldSize
    ]

    stompCreateInstance [
	<category: '*Stomp-Core-instance creation'>
	^[self new] on: Error
	    do: 
		[:ex | 
		| alterClass |
		alterClass := StompNewFailed signal: self name.
		alterClass isNil ifTrue: [self basicNew] ifFalse: [alterClass basicNew]]
    ]

    stompCreateInstance: size [
	<category: '*Stomp-Core-instance creation'>
	^[self new: size] on: Error
	    do: 
		[:ex | 
		| alterClass |
		alterClass := StompNewFailed signal: self name.
		alterClass isNil 
		    ifTrue: [[self basicNew: size] on: Error do: [self stompCreateInstance]]
		    ifFalse: [alterClass basicNew: size]]
    ]

    stompCreateInstanceFrom: stompReader [
	<category: '*Stomp-Core-instance creation'>
	| cls |
	stompReader context clearFieldsInfo.
	cls := self.
	cls isBits ifTrue: [^self stompCreateBitsInstanceFrom: stompReader].
	cls isVariable ifTrue: [^self stompCreateMixedInstanceFrom: stompReader].
	^self stompCreateFixedInstanceFrom: stompReader
    ]

    stompFromBytes: rawBytes [
	"For bits object"

	"override - if nessesary"

	<category: '*Stomp-Core-instance creation'>
	^StompPortableUtil default bytes: rawBytes intoOf: self
    ]

]



BlockClosure extend [

    stompWriteContentTo: stompWriter [
	<category: '*Stomp-Core-writing'>
	StompInvalidSerialization signal: self class name.
	stompWriter writeObject: self printString
    ]

]



Boolean extend [

    stompShouldWriteInstanceVariables [
	<category: '*Stomp-Core-testing'>
	^false
    ]

    stompSupportsReference: stompContext [
	<category: '*Stomp-Core-testing'>
	^false
    ]

]



Character extend [

    stompWriteContentTo: stompWriter [
	<category: '*Stomp-Core-writing'>

	stompWriter 
	    writeObject: (StompPortableUtil default unicodeFromCharacter: self)
    ]

]



ClassDescription extend [

    stompLoadContentsOnCreation [
	"override"

	<category: '*Stomp-Core-testing'>
	self isBits ifTrue: [^true].
	^self class includesSelector: #stompCreateInstanceFrom:	"Typically"
    ]

    stompTransientInstVarNames [
	<category: '*Stomp-Core-writing'>
	^Object class allInstVarNames
    ]

]



BlockClosure class extend [

    stompCreateInstanceFrom: stompReader [
	<category: '*Stomp-Core-instance creation'>
	StompInvalidDeserialization signal: stompReader readObject.
	^nil
    ]

]



Character class extend [

    stompCreateInstanceFrom: stompReader [
	<category: '*Stomp-Core-instance creation'>
	^StompPortableUtil default characterFromUnicode: stompReader readObject
    ]

]



Collection extend [

    stompAdd: elem at: idx [
	"override"

	<category: '*Stomp-Core-writing'>
	self add: elem
    ]

    stompDo: aBlock [
	"override"

	<category: '*Stomp-Core-writing'>
	self do: aBlock
    ]

    stompWriteContentTo: stompWriter [
	"Override as you wish"

	"Provides basic dispatch to stompWriter"

	<category: '*Stomp-Core-writing'>
	| cls |
	cls := self class.
	cls isBits ifTrue: [^stompWriter writeBitsOf: self].
	^stompWriter writeMixedFieldsOf: self
    ]

    stompReadContentFrom: stompReader [
	<category: '*Stomp-Core-reading'>
	| fieldsInfo |
	fieldsInfo := stompReader context fieldsInfo.
	fieldsInfo isNil ifTrue: [^self].
	fieldsInfo isPureIndexFields 
	    ifTrue: 
		[^stompReader readCollectionFieldsInto: self
		    sized: fieldsInfo indexFieldSize].
	fieldsInfo isMixedFields 
	    ifTrue: 
		[self stompShouldWriteInstanceVariables 
		    ifTrue: [stompReader readInstVarsInto: self].
		stompReader readCollectionFieldsInto: self].
	^self
    ]

    stompShouldWriteInstanceVariables [
	"override"

	"Usually Collection's inst vars are not needed for serialization"

	<category: '*Stomp-Core-testing'>
	^false
    ]

]



Collection class extend [

    stompCreateCollectionInstanceFrom: stompReader [
	<category: '*Stomp-Core-instance creation'>
	^self stompCreateMixedInstanceFrom: stompReader
    ]

    stompCreateInstanceFrom: stompReader [
	<category: '*Stomp-Core-instance creation'>
	| cls |
	stompReader context clearFieldsInfo.
	cls := self.
	cls isBits ifTrue: [^self stompCreateBitsInstanceFrom: stompReader].
	^self stompCreateCollectionInstanceFrom: stompReader
    ]

]



Date extend [

    stompShouldWriteInstanceVariables [
	<category: '*Stomp-Core-testing'>
	^false
    ]

    stompSupportsReference: stompContext [
	<category: '*Stomp-Core-testing'>
	^false
    ]

    stompWriteContentTo: stompWriter [
	<category: '*Stomp-Core-writing'>
	stompWriter writeObject: self asSeconds
    ]

]



Date class extend [

    stompCreateInstanceFrom: stompReader [
	<category: '*Stomp-Core-instance creation'>
	^StompPortableUtil default dateFromSeconds: stompReader readObject
    ]

]



Duration extend [

    stompWriteContentTo: stompWriter [
	<category: '*Stomp-Core-writing'>
	stompWriter 
	    writeObject: (StompPortableUtil default nanosecondsFromDuration: self)
    ]

]



Duration class extend [

    stompCreateInstanceFrom: stompReader [
	<category: '*Stomp-Core-instance creation'>
	^StompPortableUtil default durationFromNanoseconds: stompReader readObject
    ]

]



IdentityDictionary extend [

    stompWriteContentTo: stompWriter [
	<category: '*Stomp-Core-writing'>
	stompWriter writeMap: self
    ]

]



IdentityDictionary class extend [

    stompCreateInstanceFrom: stompReader [
	<category: '*Stomp-Core-instance creation'>
	| dic inst |
	dic := stompReader readObject.
	inst := self new.
	dic keysAndValuesDo: [:k :v | inst at: k put: v].
	^inst
    ]

]



Interval extend [

    stompWriteContentTo: stompWriter [
	<category: '*Stomp-Core-writing'>
	stompWriter writePrimitiveValues: (Array 
		    with: start
		    with: stop
		    with: step)
    ]

]



Interval class extend [

    stompCreateInstanceFrom: stompReader [
	<category: '*Stomp-Core-instance creation'>
	| intervalArray |
	intervalArray := stompReader readPrimitiveValues.
	^self 
	    from: (intervalArray at: 1)
	    to: (intervalArray at: 2)
	    by: (intervalArray at: 3)
    ]

]



Metaclass extend [

    stompCreateInstance [
	<category: '*Stomp-Core-instance creation'>
	^StompPortableUtil default soleInstanceOf: self
    ]

]



MpPortableUtil extend [

    stompUtil [
	<category: '*Stomp-core-accessing'>
	^StompPortableUtil default
    ]

]



MpPortableUtil class extend [

    stomp [
	<category: '*stomp-core'>
	^self default stompUtil
    ]

]



Number extend [

    stompShouldWriteInstanceVariables [
	<category: '*Stomp-Core-testing'>
	^false
    ]

    stompSupportsReference: stompContext [
	<category: '*Stomp-Core-testing'>
	^false
    ]

]



Fraction extend [

    stompWriteContentTo: stompWriter [
	<category: '*Stomp-Core-writing'>
	stompWriter 
	    writePrimitiveValues: (Array with: self numerator with: self denominator)
    ]

]



Fraction class extend [

    stompCreateInstanceFrom: stompReader [
	<category: '*Stomp-Core-instance creation'>
	| fraArray |
	fraArray := stompReader readPrimitiveValues.
	^self numerator: (fraArray at: 1) denominator: (fraArray at: 2)
    ]

]



Point extend [

    stompWriteContentTo: stompWriter [
	<category: '*Stomp-Core-writing'>
	| rectArray |
	rectArray := Array with: self x with: self y.
	stompWriter writePrimitiveValues: rectArray
    ]

]



Point class extend [

    stompCreateInstanceFrom: stompReader [
	<category: '*Stomp-Core-instance creation'>
	| rectArray |
	rectArray := stompReader readPrimitiveValues.
	^(rectArray at: 1) @ (rectArray at: 2)
    ]

]



Rectangle extend [

    stompWriteContentTo: stompWriter [
	<category: '*Stomp-Core-writing'>
	| rectArray |
	rectArray := Array 
		    with: self origin x
		    with: self origin y
		    with: self corner x
		    with: self corner y.
	stompWriter writePrimitiveValues: rectArray
    ]

]



Rectangle class extend [

    stompCreateInstanceFrom: stompReader [
	<category: '*Stomp-Core-instance creation'>
	| rectArray |
	rectArray := stompReader readPrimitiveValues.
	^(rectArray at: 1) @ (rectArray at: 2) 
	    corner: (rectArray at: 3) @ (rectArray at: 4)
    ]

]



RunArray extend [

    stompWriteContentTo: stompWriter [
	<category: '*Stomp-Core-writing'>
	stompWriter 
	    writePrimitiveValues: (Array with: self runs with: self values)
    ]

]



RunArray class extend [

    stompCreateInstanceFrom: stompReader [
	<category: '*Stomp-Core-instance creation'>
	| fraArray |
	fraArray := stompReader readPrimitiveValues.
	^self runs: (fraArray at: 1) values: (fraArray at: 2)
    ]

]



String extend [

    stompSupportsReference: stompContext [
	<category: '*Stomp-Core-testing'>
	^false
    ]

]



Symbol extend [

    stompSupportsReference: stompContext [
	<category: '*Stomp-Core'>
	^false
    ]

]



Symbol class extend [

    stompCreateInstanceFrom: stompReader [
	<category: '*Stomp-Core-instance creation'>
	^(super stompCreateInstanceFrom: stompReader) asSymbol
    ]

]




Time extend [

    stompShouldWriteInstanceVariables [
	<category: '*Stomp-Core-testing'>
	^false
    ]

    stompSupportsReference: stompContext [
	<category: '*Stomp-Core-testing'>
	^false
    ]

    stompWriteContentTo: stompWriter [
	<category: '*Stomp-Core-writing'>
	stompWriter writeObject: self asSeconds
    ]

]



Time class extend [

    stompCreateInstanceFrom: stompReader [
	<category: '*Stomp-Core-instance creation'>
	^self fromSeconds: stompReader readObject
    ]

]



UndefinedObject extend [

    stompShouldWriteInstanceVariables [
	<category: '*Stomp-Core'>
	^false
    ]

    stompSupportsReference: stompContext [
	<category: '*Stomp-Core'>
	^false
    ]

]



Eval [
    StompWarning initialize.
    StompPortableUtil initialize.
    StompPopularClassMap initialize.
    StompConstants initialize
]

