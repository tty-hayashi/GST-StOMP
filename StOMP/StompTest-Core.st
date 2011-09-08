Eval [
    'From Squeak4.2 of 4 February 2011 [latest update: #10966] on 8 August 2011 at 10:30:43 am'
]



TestCase subclass: StompCustomSerializationTestCase [
    
    <comment: nil>
    <category: 'StompTest-Core'>

    testReadStompWriteValueAndStompReadValue [
	"self debug: #testReadStompWriteValueAndStompReadValue"

	<category: 'testing'>
	| object1 object2 stomp1 docodedTuple className array stomp2 readArray inArray readObject1 readObject2 |
	object1 := StompMockCustomWriteObject new.
	object1 name: 'Masashi Umezawa'.
	object1 email: 'mu@example.com'.
	object2 := StompMockCustomWriteObject new.
	object2 name: 'Shiho Umezawa'.
	object2 email: 'su@example.com'.
	stomp1 := object1 toStomp.
	docodedTuple := MpDecoder decode: stomp1.
	className := ((docodedTuple at: 2) at: StompConstants klassName) asString 
		    asSymbol.
	self should: [className = #StompMockMementoArray].
	array := Array 
		    with: object1
		    with: object2
		    with: (Array 
			    with: object1
			    with: object2
			    with: 3).
	stomp2 := array toStomp.
	readArray := Object fromStomp: stomp2.
	inArray := readArray at: 3.
	self should: [(readArray at: 1) = (inArray at: 1)].
	self should: [(readArray at: 2) = (inArray at: 2)].
	self shouldnt: 
		[(readArray at: 3) = (Array 
			    with: object1
			    with: object2
			    with: 3)].
	readObject1 := readArray at: 1.
	self should: [readObject1 name = 'Masashi Umezawa'].
	self should: [readObject1 email = 'mu@example.com'].
	readObject2 := readArray at: 2.
	self should: [readObject2 name = 'Shiho Umezawa'].
	self should: [readObject2 email = 'su@example.com']
    ]

    testSameStompWriteValueAndStompReadValue [
	"self debug: #testSameStompWriteValueAndStompReadValue"

	<category: 'testing'>
	| obj1 array array2 |
	obj1 := (StompMockCustomWriteObject new)
		    name: 'AA';
		    email: 'aa@example.com'.
	array := Array with: obj1 with: obj1.
	array2 := Object fromStomp: array toStomp.
	self should: [(array2 at: 1) = (array2 at: 2)]
    ]

    testStompInitialize [
	"self debug: #testStompInitialize"

	<category: 'testing'>
	| obj readObject |
	obj := StompMockObjectInitializingOnRead new.
	obj instVar1: 'cache1'.
	obj instVar2: 'cache2'.
	obj instVar3: 3.
	obj instVar4: 4.
	obj instVar5: 5.
	readObject := StompReader decode: (StompWriter encode: obj).
	self should: [readObject instVar1 = 'stomp initialized 1'].
	self should: [readObject instVar2 = 'stomp initialized 2'].
	self should: [readObject instVar3 = 3].
	self should: [readObject instVar4 = 4].
	self should: [readObject instVar5 = 5].
	self should: [obj instVar1 = 'cache1'].
	self should: [obj instVar2 = 'cache2'].
	self should: [obj instVar3 = 3].
	self should: [obj instVar4 = 4].
	self should: [obj instVar5 = 5]
    ]

    testStompPrepareWrite [
	"self debug: #testStompPrepareWrite"

	<category: 'testing'>
	| obj readObject |
	obj := StompMockObjectPreparingOnWrite new.
	obj instVar1: 1.
	obj instVar2: 2.
	obj instVar3: 3.
	obj instVar4: 4.
	obj instVar5: 5.
	readObject := StompReader decode: (StompWriter encode: obj).
	self should: [readObject instVar1 = '1'].
	self should: [readObject instVar2 = 4].
	self should: [readObject instVar3 = 3].
	self should: [readObject instVar4 = 4].
	self should: [readObject instVar5 = 5].
	self should: [obj instVar1 = '1'].
	self should: [obj instVar2 = 4].
	self should: [obj instVar3 = 3].
	self should: [obj instVar4 = 4].
	self should: [obj instVar5 = 5]
    ]

    testStompTransientClassInstVarNames [
	"self debug: #testStompTransientClassInstVarNames"

	<category: 'testing'>
	| obj encodedBytes readObject |
	obj := StompMockObjectWithCache.
	obj att1: 1.
	obj att2: 2.
	obj cache1: 'cache1'.
	encodedBytes := StompWriter encode: obj.
	obj att1: nil.
	obj att2: nil.
	obj cache1: nil.
	readObject := StompReader decode: encodedBytes.
	self should: [readObject att1 = 1].
	self should: [readObject att2 = 2].
	self should: [readObject cache1 = nil]
    ]

    testStompTransientInstVarNames [
	"self debug: #testStompTransientInstVarNames"

	<category: 'testing'>
	| obj readObject |
	obj := StompMockObjectWithCache new.
	obj instVar1: '1'.
	obj instVar2: '2'.
	obj instVar3: 3.
	obj instVar4: 4.
	obj instVar5: 5.
	readObject := StompReader decode: (StompWriter encode: obj).
	self should: [readObject instVar1 = nil].
	self should: [readObject instVar2 = nil].
	self should: [readObject instVar3 = nil].
	self should: [readObject instVar4 = 4].
	self should: [readObject instVar5 = 5].
	self should: [obj instVar1 = '1'].
	self should: [obj instVar2 = '2'].
	self should: [obj instVar3 = 3].
	self should: [obj instVar4 = 4].
	self should: [obj instVar5 = 5]
    ]
]



ByteArray subclass: StompMockByteArray [
    
    <shape: #byte>
    <category: 'StompTest-Core'>
    <comment: nil>
]



Object subclass: StompMockCustomWriteObject [
    | name email |
    
    <category: 'StompTest-Core'>
    <comment: nil>

    email [
	"Answer the value of email"

	<category: 'accessing'>
	^email
    ]

    email: anObject [
	"Set the value of email"

	<category: 'accessing'>
	email := anObject
    ]

    name [
	<category: 'accessing'>
	^name
    ]

    name: anObject [
	"Set the value of name"

	<category: 'accessing'>
	name := anObject
    ]

    initialize [
	<category: 'initialize-release'>
	name := 'Test Name'.
	email := 'test-name@example.com'
    ]

    stompWriteValue [
	"Write myself as an array"

	<category: 'stomp-objectstream-writing'>
	^StompMockMementoArray with: self name with: self email
    ]
]



Object subclass: StompMockFixedClass [
    | instVar1 instVar2 instVar3 instVar4 instVar5 |
    
    <category: 'StompTest-Core'>
    <comment: nil>

    equals: other [
	<category: 'comparing'>
	self class = other class ifFalse: [^false].
	instVar1 = other instVar1 ifFalse: [^false].
	instVar2 = other instVar2 ifFalse: [^false].
	instVar3 = other instVar3 ifFalse: [^false].
	instVar4 = other instVar4 ifFalse: [^false].
	instVar5 = other instVar5 ifFalse: [^false].
	^true
    ]

    instVar1 [
	"Answer the value of instVar1"

	<category: 'accessing'>
	^instVar1
    ]

    instVar1: anObject [
	"Set the value of instVar1"

	<category: 'accessing'>
	instVar1 := anObject
    ]

    instVar2 [
	"Answer the value of instVar2"

	<category: 'accessing'>
	^instVar2
    ]

    instVar2: anObject [
	"Set the value of instVar2"

	<category: 'accessing'>
	instVar2 := anObject
    ]

    instVar3 [
	"Answer the value of instVar3"

	<category: 'accessing'>
	^instVar3
    ]

    instVar3: anObject [
	"Set the value of instVar3"

	<category: 'accessing'>
	instVar3 := anObject
    ]

    instVar4 [
	"Answer the value of instVar4"

	<category: 'accessing'>
	^instVar4
    ]

    instVar4: anObject [
	"Set the value of instVar4"

	<category: 'accessing'>
	instVar4 := anObject
    ]

    instVar5 [
	"Answer the value of instVar5"

	<category: 'accessing'>
	^instVar5
    ]

    instVar5: anObject [
	"Set the value of instVar5"

	<category: 'accessing'>
	instVar5 := anObject
    ]
]



Object subclass: StompMockFixedClass2 [
    | instVar1 instVar2 instVar3 instVar4 instVar5 |
    
    <category: 'StompTest-Core'>
    <comment: nil>

    equals: other [
	<category: 'comparing'>
	self class = other class ifFalse: [^false].
	instVar1 = other instVar1 ifFalse: [^false].
	instVar2 = other instVar2 ifFalse: [^false].
	instVar3 = other instVar3 ifFalse: [^false].
	instVar4 = other instVar4 ifFalse: [^false].
	instVar5 = other instVar5 ifFalse: [^false].
	^true
    ]

    instVar1 [
	"Answer the value of instVar1"

	<category: 'accessing'>
	^instVar1
    ]

    instVar1: anObject [
	"Set the value of instVar1"

	<category: 'accessing'>
	instVar1 := anObject
    ]

    instVar2 [
	"Answer the value of instVar2"

	<category: 'accessing'>
	^instVar2
    ]

    instVar2: anObject [
	"Set the value of instVar2"

	<category: 'accessing'>
	instVar2 := anObject
    ]

    instVar3 [
	"Answer the value of instVar3"

	<category: 'accessing'>
	^instVar3
    ]

    instVar3: anObject [
	"Set the value of instVar3"

	<category: 'accessing'>
	instVar3 := anObject
    ]

    instVar4 [
	"Answer the value of instVar4"

	<category: 'accessing'>
	^instVar4
    ]

    instVar4: anObject [
	"Set the value of instVar4"

	<category: 'accessing'>
	instVar4 := anObject
    ]

    instVar5 [
	"Answer the value of instVar5"

	<category: 'accessing'>
	^instVar5
    ]

    instVar5: anObject [
	"Set the value of instVar5"

	<category: 'accessing'>
	instVar5 := anObject
    ]
]



Object subclass: StompMockFixedNewFailedClass [
    | att1 att2 att3Block |
    
    <category: 'StompTest-Core'>
    <comment: nil>

    StompMockFixedNewFailedClass class >> new [
	<category: 'instance creation'>
	^Error new signal: '#new should not be used!'
    ]

    StompMockFixedNewFailedClass class >> prototype1 [
	"self prototype1"

	<category: 'for tests'>
	| inst |
	inst := self basicNew.
	inst att1: 1.
	inst att2: 'TWO'.
	inst att3Block: [:this | 'is block'].
	^inst
    ]

    att1 [
	<category: 'accessing'>
	^att1
    ]

    att1: aValue [
	<category: 'accessing'>
	att1 := aValue
    ]

    att2 [
	<category: 'accessing'>
	^att2
    ]

    att2: aValue [
	<category: 'accessing'>
	att2 := aValue
    ]

    att3Block [
	<category: 'accessing'>
	^att3Block
    ]

    att3Block: aValue [
	<category: 'accessing'>
	att3Block := aValue
    ]

    stompInitialize [
	<category: 'initializing-stomp'>
	att3Block := [:a :b | a < b]
    ]
]



StompMockFixedNewFailedClass subclass: StompMockFixedAlternativeClass [
    
    <category: 'StompTest-Core'>
    <comment: nil>

    StompMockFixedAlternativeClass class >> new [
	"new is OK for me"

	<category: 'instance creation'>
	^self basicNew
    ]
]



Array subclass: StompMockMementoArray [
    
    <shape: #pointer>
    <category: 'StompTest-Core'>
    <comment: nil>

    stompReadValue [
	<category: 'stomp-objectstream-reading'>
	| inst |
	inst := StompMockCustomWriteObject new.
	inst name: (self at: 1).
	inst email: (self at: 2).
	^inst
    ]
]



Array subclass: StompMockMixedClass [
    | instVar1 instVar2 |
    
    <shape: #pointer>
    <category: 'StompTest-Core'>
    <comment: nil>

    StompMockMixedClass class >> new [
	<category: 'instance creation'>
	^super new
    ]

    equals: other [
	<category: 'comparing'>
	self class = other class ifFalse: [^false].
	instVar1 = other instVar1 ifFalse: [^false].
	instVar2 = other instVar2 ifFalse: [^false].
	^super = other
    ]

    instVar1 [
	"Answer the value of instVar1"

	<category: 'accessing'>
	^instVar1
    ]

    instVar1: anObject [
	"Set the value of instVar1"

	<category: 'accessing'>
	instVar1 := anObject
    ]

    instVar2 [
	"Answer the value of instVar2"

	<category: 'accessing'>
	^instVar2
    ]

    instVar2: anObject [
	"Set the value of instVar2"

	<category: 'accessing'>
	instVar2 := anObject
    ]

    stompShouldWriteInstanceVariables [
	<category: 'testing'>
	^true
    ]
]



StompMockFixedClass subclass: StompMockObjectInitializingOnRead [
    
    <category: 'StompTest-Core'>
    <comment: nil>

    stompInitialize [
	<category: 'initialize-release'>
	instVar1 := 'stomp initialized 1'.
	instVar2 := 'stomp initialized 2'
    ]
]



StompMockFixedClass subclass: StompMockObjectPreparingOnWrite [
    
    <category: 'StompTest-Core'>
    <comment: nil>

    stompPrepareWrite [
	<category: 'stomp-objectstream-writing'>
	self instVar1: self instVar1 printString.
	self instVar2: self instVar2 * 2
    ]
]



StompMockFixedClass subclass: StompMockObjectWithCache [
    
    <category: 'StompTest-Core'>
    <comment: nil>

    StompMockObjectWithCache class [
	| att1 att2 cache1 |
	
    ]

    StompMockObjectWithCache class >> att1 [
	"Answer the value of att1"

	<category: 'accessing'>
	^att1
    ]

    StompMockObjectWithCache class >> att1: anObject [
	"Set the value of att1"

	<category: 'accessing'>
	att1 := anObject
    ]

    StompMockObjectWithCache class >> att2 [
	"Answer the value of att2"

	<category: 'accessing'>
	^att2
    ]

    StompMockObjectWithCache class >> att2: anObject [
	"Set the value of att2"

	<category: 'accessing'>
	att2 := anObject
    ]

    StompMockObjectWithCache class >> cache1 [
	"Answer the value of cache1"

	<category: 'accessing'>
	^cache1
    ]

    StompMockObjectWithCache class >> cache1: anObject [
	"Set the value of cache1"

	<category: 'accessing'>
	cache1 := anObject
    ]

    StompMockObjectWithCache class >> stompTransientInstVarNames [
	<category: 'stomp-objectstream-writing'>
	^super stompTransientInstVarNames , #(#cache1)
    ]

    stompTransientInstVarNames [
	<category: 'stomp-objectstream-writing'>
	^#(#instVar1 #instVar2 #instVar3)
    ]
]



Object subclass: StompMockPerson [
    | name requests partners |
    
    <category: 'StompTest-Core'>
    <comment: nil>

    StompMockPerson class >> example1 [
	"self example1"

	<category: 'examples'>
	| req1 req2 person1 person2 |
	req1 := StompMockRequest new.
	req1 id: 1.
	req2 := StompMockRequest new.
	req2 id: 2.
	person1 := StompMockPerson new name: 'A'.
	person1 requests: (Array with: req1 with: req2).
	person2 := StompMockPerson new name: 'B'.
	person2 partners: (Array with: person1).
	req1 owner: person1.
	req2 owner: person2.
	^person1
    ]

    name [
	<category: 'accessing'>
	^name
    ]

    name: aString [
	<category: 'accessing'>
	name := aString
    ]

    partners [
	<category: 'accessing'>
	partners isNil ifTrue: [partners := Array new].
	^partners
    ]

    partners: anObject [
	<category: 'accessing'>
	partners := anObject
    ]

    requests [
	<category: 'accessing'>
	requests isNil ifTrue: [requests := Array new].
	^requests
    ]

    requests: anObject [
	<category: 'accessing'>
	requests := anObject
    ]
]



StompShapeChanger subclass: StompMockPersonShapeChanger [
    
    <comment: nil>
    <category: 'StompTest-Core'>

    loadInstVarAt: varIndex named: varName put: varValue [
	<category: 'actions'>
	varName = 'fullName' ifTrue: [^self targetInstance name: varValue].
	^super 
	    loadInstVarAt: varIndex
	    named: varName
	    put: varValue
    ]
]



Object subclass: StompMockRequest [
    | id owner |
    
    <category: 'StompTest-Core'>
    <comment: nil>

    id [
	<category: 'accessing'>
	^id
    ]

    id: anObject [
	<category: 'accessing'>
	id := anObject
    ]

    owner [
	<category: 'accessing'>
	^owner
    ]

    owner: anObject [
	<category: 'accessing'>
	owner := anObject
    ]
]



Object subclass: StompMockShapeChangedObject [
    | renamedAtt1 addedAtt1 originalAtt1 |
    
    <category: 'StompTest-Core'>
    <comment: nil>

    addedAtt1 [
	"Answer the value of addedAtt1"

	<category: 'accessing'>
	^addedAtt1
    ]

    addedAtt1: anObject [
	"Set the value of addedAtt1"

	<category: 'accessing'>
	addedAtt1 := anObject
    ]

    originalAtt1 [
	"Answer the value of originalAtt1"

	<category: 'accessing'>
	^originalAtt1
    ]

    originalAtt1: anObject [
	"Set the value of originalAtt1"

	<category: 'accessing'>
	originalAtt1 := anObject
    ]

    renamedAtt1 [
	"Answer the value of renamedAtt1"

	<category: 'accessing'>
	^renamedAtt1
    ]

    renamedAtt1: anObject [
	"Set the value of renamedAtt1"

	<category: 'accessing'>
	renamedAtt1 := anObject
    ]

    stompInitialize [
	<category: 'reading-stomp'>
	addedAtt1 := 2
    ]

    stompInstVarAt: instVarIndex named: varName put: value [
	<category: 'reading-stomp'>
	varName = 'oldNamedVar1' ifTrue: [^self renamedAtt1: value].
	super 
	    stompInstVarAt: instVarIndex
	    named: varName
	    put: value
    ]
]



StompShapeChanger subclass: StompMockShapeChanger [
    
    <comment: nil>
    <category: 'StompTest-Core'>

    loadAdditions [
	<category: 'actions'>
	self targetInstance instVar5: 'FIVE'
    ]

    loadInstVarAt: varIndex named: varName put: varValue [
	"renamed"

	<category: 'actions'>
	varName = 'instVar2OLD' ifTrue: [^self targetInstance instVar2: varValue].

	"removed"
	"varName = 'instVar6' ifTrue: [^ self]."
	^super 
	    loadInstVarAt: varIndex
	    named: varName
	    put: varValue
    ]
]



StompShapeChanger subclass: StompMockShapeChangerForRenamedComplexRead [
    
    <comment: nil>
    <category: 'StompTest-Core'>

    loadAdditions [
	<category: 'actions'>
	self targetInstance addedAtt1: 22222
    ]

    loadInstVarAt: varIndex named: varName put: varValue [
	"renamed"

	<category: 'actions'>
	varName = 'oldNamedVar1' 
	    ifTrue: [^self targetInstance renamedAtt1: varValue].
	^super 
	    loadInstVarAt: varIndex
	    named: varName
	    put: varValue
    ]
]



Array subclass: StompMockVariableClass [
    
    <shape: #pointer>
    <category: 'StompTest-Core'>
    <comment: nil>
]



Array subclass: StompMockVariableNewFailedClass [
    | att1 att2 att3Block |
    
    <shape: #pointer>
    <category: 'StompTest-Core'>
    <comment: nil>

    StompMockVariableNewFailedClass class >> new: size [
	<category: 'instance creation'>
	Error new signal: '#new: should not be called'
    ]

    StompMockVariableNewFailedClass class >> prototype1 [
	"self prototype1"

	<category: 'for tests'>
	| inst |
	inst := self basicNew: 3.
	1 to: 3 do: [:idx | inst at: idx put: idx printString].
	inst att1: 1.
	inst att2: 'TWO'.
	inst att3Block: [:this | 'is block'].
	^inst
    ]

    att1 [
	<category: 'accessing'>
	^att1
    ]

    att1: aValue [
	<category: 'accessing'>
	att1 := aValue
    ]

    att2 [
	<category: 'accessing'>
	^att2
    ]

    att2: aValue [
	<category: 'accessing'>
	att2 := aValue
    ]

    att3Block [
	<category: 'accessing'>
	^att3Block
    ]

    att3Block: aValue [
	<category: 'accessing'>
	att3Block := aValue
    ]

    stompInitialize [
	<category: 'initializing-stomp'>
	att3Block := [:a :b | a < b]
    ]

    stompShouldWriteInstanceVariables [
	<category: 'testing-stomp'>
	^true
    ]
]



StompMockVariableNewFailedClass subclass: StompMockVariableAlternativeClass [
    
    <shape: #pointer>
    <category: 'StompTest-Core'>
    <comment: nil>

    StompMockVariableAlternativeClass class >> new: size [
	"new: is OK for me"

	<category: 'instance creation'>
	^self basicNew: size
    ]
]



TestCase subclass: StompNewFailedTestCase [
    
    <comment: nil>
    <category: 'StompTest-Core'>

    testWriteReadNewFailedClass [
	"self debug: #testWriteReadNewFailedClass"

	<category: 'tests'>
	| original stomp read |
	original := StompMockFixedNewFailedClass prototype1.
	self should: [original att1 = 1].
	self should: [original att2 = 'TWO'].
	self should: [original toStomp] raise: StompInvalidSerialization.
	stomp := original toStomp.
	self should: [Object fromStomp: stomp] raise: StompNewFailed.
	read := Object fromStomp: stomp.
	self should: [read att1 = 1].
	self should: [read att2 = 'TWO'].
	self should: [read att3Block notNil]
    ]

    testWriteReadNewFailedClassReceiverAlternative [
	"self debug: #testWriteReadNewFailedClassReceiverAlternative"

	<category: 'tests'>
	| original stomp read |
	original := StompMockFixedNewFailedClass prototype1.
	self should: [original att1 = 1].
	self should: [original att2 = 'TWO'].
	self should: [original toStomp] raise: StompInvalidSerialization.
	stomp := original toStomp.
	self should: [Object fromStomp: stomp] raise: StompNewFailed.
	read := [Object fromStomp: stomp] on: StompNewFailed
		    do: [:ex | ex resume: StompMockFixedAlternativeClass].
	self should: [read class = StompMockFixedAlternativeClass].
	self should: [read att1 = 1].
	self should: [read att2 = 'TWO'].
	self should: [read att3Block notNil]
    ]

    testWriteReadNewVariableFailedClass [
	"self debug: #testWriteReadNewVariableFailedClass"

	<category: 'tests'>
	| original stomp read |
	original := StompMockVariableNewFailedClass prototype1.
	self should: [original att1 = 1].
	self should: [original att2 = 'TWO'].
	self should: [original toStomp] raise: StompInvalidSerialization.
	stomp := original toStomp.
	self should: [Object fromStomp: stomp] raise: StompNewFailed.
	read := Object fromStomp: stomp.
	self should: [read att1 = 1].
	self should: [read att2 = 'TWO'].
	self should: [read att3Block notNil]
    ]

    testWriteReadNewVariableFailedClassReciverAlternative [
	"self debug: #testWriteReadNewVariableFailedClassReciverAlternative"

	<category: 'tests'>
	| original stomp read |
	original := StompMockVariableNewFailedClass prototype1.
	self should: [original att1 = 1].
	self should: [original att2 = 'TWO'].
	self should: [original toStomp] raise: StompInvalidSerialization.
	stomp := original toStomp.
	self should: [Object fromStomp: stomp] raise: StompNewFailed.
	read := [Object fromStomp: stomp] on: StompNewFailed
		    do: [:ex | ex resume: StompMockVariableAlternativeClass].
	self should: [read class = StompMockVariableAlternativeClass].
	self should: [read att1 = 1].
	self should: [read att2 = 'TWO'].
	self should: [read att3Block notNil]
    ]
]



Object subclass: StompPortableFixtures [
    
    <category: 'StompTest-Core'>
    <comment: nil>

    StompPortableFixtures class >> blueColor [
	<category: 'fixtures'>
	self subclassResponsibility
    ]

    StompPortableFixtures class >> double1234567890dot123456789 [
	"^ 1234567890.123456789d"

	<category: 'fixtures'>
	self subclassResponsibility
    ]

    StompPortableFixtures class >> double3dot3 [
	"^ 3.3d"

	<category: 'fixtures'>
	self subclassResponsibility
    ]

    StompPortableFixtures class >> float1dot2bytes [
	<category: 'fixtures'>
	^#[202 63 153 153 154]
    ]

    StompPortableFixtures class >> timestamp1 [
	<category: 'fixtures'>
	self subclassResponsibility
    ]

    StompPortableFixtures class >> yellowColor [
	<category: 'fixtures'>
	self subclassResponsibility
    ]
]



TestCase subclass: StompTestCase [
    
    <comment: nil>
    <category: 'StompTest-Core'>

    bagAnswerBytes [
	<category: 'fixtures'>
	^#[147 161 2 255 148 30 30 20 10]
    ]

    basicArrayAnswerBytes [
	<category: 'fixtures'>
	^#[148 1 2 3 147 146 161 4 165 72 101 108 108 111 2 3]
    ]

    basicBitsClassAnswerBytes [
	<category: 'fixtures'>
	^#[147 161 2 129 17 218 0 18 83 116 111 109 112 77 111 99 107 66 121 116 101 65 114 114 97 121 163 0 127 255]
    ]

    basicFixedClassAnswerBytes [
	<category: 'fixtures'>
	^#[147 161 2 129 17 218 0 19 83 116 111 109 112 77 111 99 107 70 105 120 101 100 67 108 97 115 115 129 149 168 105 110 115 116 86 97 114 49 168 105 110 115 116 86 97 114 50 168 105 110 115 116 86 97 114 51 168 105 110 115 116 86 97 114 52 168 105 110 115 116 86 97 114 53 149 1 146 161 5 163 116 119 111 203 64 10 102 102 102 102 102 102 194 146 161 4 164 70 73 86 69]
    ]

    basicMixedClassAnswerBytes [
	<category: 'fixtures'>
	^#[149 161 2 129 17 218 0 19 83 116 111 109 112 77 111 99 107 77 105 120 101 100 67 108 97 115 115 3 129 146 168 105 110 115 116 86 97 114 49 168 105 110 115 116 86 97 114 50 146 146 195 194 146 192 144 147 1 146 161 4 163 116 119 111 203 64 10 102 102 102 102 102 102]
    ]

    basicVariableClassAnswerBytes [
	<category: 'fixtures'>
	^#[147 161 2 129 17 218 0 22 83 116 111 109 112 77 111 99 107 86 97 114 105 97 98 108 101 67 108 97 115 115 147 1 146 161 4 163 116 119 111 203 64 10 102 102 102 102 102 102]
    ]

    circularRefrencesAnswerBytes [
	<category: 'fixtures'>
	^#[148 147 161 2 129 17 218 0 22 83 116 111 109 112 77 111 99 107 86 97 114 105 97 98 108 101 67 108 97 115 115 147 1 146 161 4 163 116 119 111 146 161 3 1 149 161 2 129 17 218 0 19 83 116 111 109 112 77 111 99 107 77 105 120 101 100 67 108 97 115 115 3 129 146 168 105 110 115 116 86 97 114 49 168 105 110 115 116 86 97 114 50 146 146 161 3 1 146 161 3 2 147 1 146 161 4 163 116 119 111 203 64 10 102 102 102 102 102 102 146 161 3 1 146 161 3 2]
    ]

    classAnswerBytes [
	<category: 'fixtures'>
	^#[147 161 2 129 17 218 0 25 83 116 111 109 112 77 111 99 107 79 98 106 101 99 116 87 105 116 104 67 97 99 104 101 36 129 146 164 97 116 116 49 164 97 116 116 50 146 11 22]
    ]

    classNameAndIdsAnswerBytes [
	<category: 'fixtures'>
	^#[148 147 161 2 129 17 218 0 19 83 116 111 109 112 77 111 99 107 70 105 120 101 100 67 108 97 115 115 129 149 168 105 110 115 116 86 97 114 49 168 105 110 115 116 86 97 114 50 168 105 110 115 116 86 97 114 51 168 105 110 115 116 86 97 114 52 168 105 110 115 116 86 97 114 53 149 1 146 161 5 163 111 110 101 192 192 192 147 161 2 0 150 0 2 146 161 5 163 116 119 111 192 192 192 149 161 2 129 17 218 0 19 83 116 111 109 112 77 111 99 107 77 105 120 101 100 67 108 97 115 115 0 129 146 168 105 110 115 116 86 97 114 49 168 105 110 115 116 86 97 114 50 146 3 146 161 5 165 116 104 114 101 101 144 149 161 2 1 0 147 1 4 146 161 5 164 102 111 117 114 144]
    ]

    classNameAndIdsSuppressNilWritesAnswerBytes [
	<category: 'fixtures'>
	^#[148 147 161 2 129 17 218 0 19 83 116 111 109 112 77 111 99 107 70 105 120 101 100 67 108 97 115 115 129 146 168 105 110 115 116 86 97 114 49 168 105 110 115 116 86 97 114 50 146 1 146 161 5 163 111 110 101 147 161 2 0 129 146 168 105 110 115 116 86 97 114 49 168 105 110 115 116 86 97 114 50 146 2 146 161 5 163 116 119 111 149 161 2 129 17 218 0 19 83 116 111 109 112 77 111 99 107 77 105 120 101 100 67 108 97 115 115 0 129 146 168 105 110 115 116 86 97 114 49 168 105 110 115 116 86 97 114 50 146 3 146 161 5 165 116 104 114 101 101 144 149 161 2 1 0 129 146 168 105 110 115 116 86 97 114 49 168 105 110 115 116 86 97 114 50 146 4 146 161 5 164 102 111 117 114 144]
    ]

    colorAnswerBytes1 [
	<category: 'fixtures'>
	^#[147 161 2 252 147 203 0 0 0 0 0 0 0 0 203 0 0 0 0 0 0 0 0 203 63 240 0 0 0 0 0 0]
    ]

    colorAnswerBytes2 [
	<category: 'fixtures'>
	^#[147 161 2 252 147 203 63 240 0 0 0 0 0 0 203 63 240 0 0 0 0 0 0 203 0 0 0 0 0 0 0 0]
    ]

    compositeDictionaryAnswerBytes [
	<category: 'fixtures'>
	^#[132 146 161 5 167 112 97 114 101 110 116 52 129 146 161 5 166 99 104 105 108 100 49 146 161 4 165 97 98 99 100 101 146 161 5 167 112 97 114 101 110 116 50 100 146 161 5 167 112 97 114 101 110 116 51 147 10 20 30 146 161 5 167 112 97 114 101 110 116 49 146 161 4 174 115 97 109 112 108 101 32 115 116 114 105 110 103 46]
    ]

    dateAnswerBytes [
	<category: 'fixtures'>
	^#[147 161 2 250 206 190 169 158 128]
    ]

    dictionaryAnswerBytes [
	<category: 'fixtures'>
	^#[131 146 161 5 164 107 101 121 51 146 161 4 166 118 97 108 117 101 51 146 161 5 164 107 101 121 49 146 161 4 166 118 97 108 117 101 49 146 161 5 164 107 101 121 50 146 161 4 166 118 97 108 117 101 50]
    ]

    durationAnswerBytes [
	<category: 'fixtures'>
	^#[147 161 2 239 207 0 0 0 28 163 95 14 0]
    ]

    fixedClassWithNilValuesAnswerBytes [
	<category: 'fixtures'>
	^#[147 161 2 129 17 218 0 19 83 116 111 109 112 77 111 99 107 70 105 120 101 100 67 108 97 115 115 129 147 168 105 110 115 116 86 97 114 49 168 105 110 115 116 86 97 114 51 168 105 110 115 116 86 97 114 53 147 1 203 64 10 102 102 102 102 102 102 146 161 4 164 70 73 86 69]
    ]

    floatingPointAnswerBytes1 [
	<category: 'fixtures'>
	^StompPortableUtil default testFixturesClass float1dot2bytes
    ]

    floatingPointAnswerBytes2 [
	"double"

	<category: 'fixtures'>
	^#[203 65 210 101 128 180 135 230 183]
    ]

    fractionAnswerBytes [
	<category: 'fixtures'>
	^#[147 161 2 249 146 3 4]
    ]

    intervalAnswerBytes [
	<category: 'fixtures'>
	^#[147 161 2 246 147 1 10 3]
    ]

    mixedClassNoVariableDataAnswerBytes [
	<category: 'fixtures'>
	^#[149 161 2 129 17 218 0 19 83 116 111 109 112 77 111 99 107 77 105 120 101 100 67 108 97 115 115 0 129 146 168 105 110 115 116 86 97 114 49 168 105 110 115 116 86 97 114 50 146 146 195 194 146 192 144 144]
    ]

    ordredCollectionAnswerBytes [
	<category: 'fixtures'>
	^#[147 161 2 245 147 10 20 30]
    ]

    rectangleAnswerBytes [
	<category: 'fixtures'>
	^#[147 161 2 243 148 1 1 3 4]
    ]

    recursiveArrayAnswerBytes [
	<category: 'fixtures'>
	^#[147 10 20 146 161 3 0]
    ]

    runArrayAnswerBytes [
	<category: 'fixtures'>
	^#[147 161 2 236 146 147 1 2 1 147 1 2 3]
    ]

    setAnswerBytes [
	<category: 'fixtures'>
	^#[147 161 2 242 147 10 20 30]
    ]

    sharedReferenceAnswerBytes [
	<category: 'fixtures'>
	^#[148 147 161 2 129 17 218 0 22 83 116 111 109 112 77 111 99 107 86 97 114 105 97 98 108 101 67 108 97 115 115 147 1 146 161 4 163 116 119 111 203 64 10 102 102 102 102 102 102 149 161 2 129 17 218 0 19 83 116 111 109 112 77 111 99 107 77 105 120 101 100 67 108 97 115 115 3 129 146 168 105 110 115 116 86 97 114 49 168 105 110 115 116 86 97 114 50 146 146 195 194 146 192 144 147 1 146 161 4 163 116 119 111 203 64 10 102 102 102 102 102 102 146 161 3 1 146 161 3 2]
    ]

    stringAnswerBytes [
	<category: 'fixtures'>
	^#[146 161 4 218 0 21 72 105 44 32 73 39 109 32 83 116 114 105 110 103 45 111 98 106 101 99 116]
    ]

    symbolAnswerBytes [
	<category: 'fixtures'>
	^#[146 161 5 167 97 98 99 100 101 102 103]
    ]

    timeAnswerBytes [
	<category: 'fixtures'>
	^#[147 161 2 238 206 0 1 72 104]
    ]

    timestampAnswerBytes [
	<category: 'fixtures'>
	^#[147 161 2 237 207 46 57 36 122 10 159 20 0]
    ]
]



StompTestCase subclass: StompReadWriteTestCase [
    
    <comment: nil>
    <category: 'StompTest-Core'>

    testReadWriteText [
	"self debug: #testReadWriteText"

	<category: 'tests'>
	| bytes orig text |
	(StompPortableUtil default classNamed: #Text) ifNil: [^self].
	orig := 'aaa' asText allBold.
	bytes := orig toStomp.
	text := Object fromStomp: bytes.
	self should: [orig = text]
    ]
]



StompTestCase subclass: StompReaderTestCase [
    
    <comment: nil>
    <category: 'StompTest-Core'>

    collectionEquals: aCollection with: otherCollection [
	<category: 'private'>
	^MpPortableUtil default collectionEquals: aCollection with: otherCollection
    ]

    testReadBag [
	"self debug: #testReadBag"

	<category: 'tests'>
	| bytes inst |
	bytes := self bagAnswerBytes.
	inst := Object fromStomp: bytes.
	self should: [inst class = Bag].
	self should: [inst size = 4].
	self should: [inst includes: 10].
	self should: [inst includes: 20].
	self should: [inst includes: 30].
	self should: [(inst occurrencesOf: 30) = 2]
    ]

    testReadBasicArray [
	"self debug: #testReadBasicArray"

	<category: 'tests'>
	| bytes obj |
	bytes := self basicArrayAnswerBytes.
	obj := (StompReader onBytes: bytes) next.
	self should: [obj class = Array].
	self should: [obj = #(1 2 3 #('Hello' 2 3))]
    ]

    testReadBasicBitsClass [
	"self debug: #testReadBasicBitsClass"

	<category: 'tests'>
	| bytes obj expected |
	bytes := self basicBitsClassAnswerBytes.
	obj := (StompReader onBytes: bytes) next.
	expected := StompMockByteArray new: 3.
	expected at: 1 put: 0.
	expected at: 2 put: 127.
	expected at: 3 put: 255.
	self should: [obj = expected]
    ]

    testReadBasicFixedClass [
	"self debug: #testReadBasicFixedClass"

	<category: 'tests'>
	| bytes obj expected |
	bytes := self basicFixedClassAnswerBytes.
	obj := (StompReader onBytes: bytes) next.
	expected := StompMockFixedClass new.
	expected instVar1: 1.
	expected instVar2: #two.
	expected instVar3: StompPortableUtil default testFixturesClass double3dot3.
	expected instVar4: false.
	expected instVar5: 'FIVE'.
	self should: [obj equals: expected]
    ]

    testReadBasicMixedClass [
	"self debug: #testReadBasicMixedClass"

	<category: 'tests'>
	| bytes obj expected |
	bytes := self basicMixedClassAnswerBytes.
	obj := (StompReader onBytes: bytes) next.
	expected := StompMockMixedClass new: 3.
	expected at: 1 put: 1.
	expected at: 2 put: 'two'.
	expected at: 3 put: StompPortableUtil default testFixturesClass double3dot3.
	expected instVar1: #(true false).
	expected instVar2: #(nil #()).
	self should: [obj equals: expected]
    ]

    testReadBasicVariableClass [
	"self debug: #testReadBasicVariableClass"

	<category: 'tests'>
	| bytes obj expected |
	bytes := self basicVariableClassAnswerBytes.
	obj := (StompReader onBytes: bytes) next.
	expected := StompMockVariableClass new: 3.
	expected at: 1 put: 1.
	expected at: 2 put: 'two'.
	expected at: 3 put: StompPortableUtil default testFixturesClass double3dot3.
	self should: [obj = expected]
    ]

    testReadBoolean [
	"self debug: #testReadBoolean"

	<category: 'tests'>
	self should: [(Object fromStomp: #[195]) = true].
	self should: [(Object fromStomp: #[194]) = false]
    ]

    testReadByteArray [
	"self debug: #testReadByteArray"

	<category: 'tests'>
	| byteArray |
	byteArray := ByteArray 
		    with: 10
		    with: 20
		    with: 30.
	self should: [(Object fromStomp: #[163 10 20 30]) = byteArray]
    ]

    testReadCharacter [
	"self debug: #testReadCharacter"

	<category: 'tests'>
	| char1 char2 |
	char1 := $A.
	self should: [(Object fromStomp: #[147 161 2 253 65]) = char1].
	char2 := StompPortableUtil default characterFromUnicode: 12354.	"Japanese Hiragana 'A'"
	self should: [(Object fromStomp: #[147 161 2 253 205 48 66]) = char2]
    ]

    testReadCircularRefrences1 [
	"self debug: #testReadCircularRefrences1"

	<category: 'tests'>
	| bytes reader obj inst1 inst2 expected |
	bytes := self circularRefrencesAnswerBytes.
	reader := StompReader onBytes: bytes.
	obj := reader next.
	inst1 := StompMockVariableClass new: 3.
	inst1 at: 1 put: 1.
	inst1 at: 2 put: 'two'.
	inst1 at: 3 put: inst1.
	inst2 := StompMockMixedClass new: 3.
	inst2 at: 1 put: 1.
	inst2 at: 2 put: 'two'.
	inst2 at: 3 put: StompPortableUtil default testFixturesClass double3dot3.
	inst2 instVar1: inst1.
	inst2 instVar2: inst2.
	expected := Array 
		    with: inst1
		    with: inst2
		    with: inst1
		    with: inst2.
	self should: [obj class = expected class].
	self should: [obj size = expected size].
	self should: [(obj at: 1) class = StompMockVariableClass].
	self should: [(obj at: 1) class = (expected at: 1) class].
	self should: [((obj at: 1) at: 1) = 1].
	self should: [((obj at: 1) at: 1) = ((expected at: 1) at: 1)].
	self should: [((obj at: 1) at: 2) = 'two'].
	self should: [((obj at: 1) at: 2) = ((expected at: 1) at: 2)].
	self should: [((obj at: 1) at: 3) class = StompMockVariableClass].
	self should: [((obj at: 1) at: 3) class = ((expected at: 1) at: 3) class].
	self should: [(obj at: 1) identityHash = ((obj at: 1) at: 3) identityHash].
	self should: [(obj at: 2) class = StompMockMixedClass].
	self should: [(obj at: 2) class = (expected at: 2) class].
	self should: [((obj at: 2) at: 1) = 1].
	self should: [((obj at: 2) at: 1) = ((expected at: 2) at: 1)].
	self should: [((obj at: 2) at: 2) = 'two'].
	self should: [((obj at: 2) at: 2) = ((expected at: 2) at: 2)].
	self should: 
		[((obj at: 2) at: 3) 
		    = StompPortableUtil default testFixturesClass double3dot3].
	self should: [((obj at: 2) at: 3) = ((expected at: 2) at: 3)].
	self should: [(obj at: 2) instVar1 class = StompMockVariableClass].
	self 
	    should: [(obj at: 2) instVar1 class = (expected at: 2) instVar1 class].
	self 
	    should: [(obj at: 2) instVar1 identityHash = (obj at: 1) identityHash].
	self should: [(obj at: 2) instVar2 class = StompMockMixedClass].
	self 
	    should: [(obj at: 2) instVar2 class = (expected at: 2) instVar2 class].
	self 
	    should: [(obj at: 2) instVar2 identityHash = (obj at: 2) identityHash].
	self should: [(obj at: 3) class = StompMockVariableClass].
	self should: [(obj at: 3) class = (expected at: 3) class].
	self should: [((obj at: 3) at: 1) = 1].
	self should: [((obj at: 3) at: 1) = ((expected at: 3) at: 1)].
	self should: [((obj at: 3) at: 2) = 'two'].
	self should: [((obj at: 3) at: 2) = ((expected at: 3) at: 2)].
	self should: [((obj at: 3) at: 3) class = StompMockVariableClass].
	self should: [((obj at: 3) at: 3) class = ((expected at: 3) at: 3) class].
	self should: [(obj at: 3) identityHash = ((obj at: 3) at: 3) identityHash].
	self should: [(obj at: 4) class = StompMockMixedClass].
	self should: [(obj at: 4) class = (expected at: 4) class].
	self should: [((obj at: 4) at: 1) = 1].
	self should: [((obj at: 4) at: 1) = ((expected at: 4) at: 1)].
	self should: [((obj at: 4) at: 2) = 'two'].
	self should: [((obj at: 4) at: 2) = ((expected at: 4) at: 2)].
	self should: 
		[((obj at: 4) at: 3) 
		    = StompPortableUtil default testFixturesClass double3dot3].
	self should: [((obj at: 4) at: 3) = ((expected at: 4) at: 3)].
	self should: [(obj at: 4) instVar1 class = StompMockVariableClass].
	self 
	    should: [(obj at: 4) instVar1 class = (expected at: 4) instVar1 class].
	self 
	    should: [(obj at: 4) instVar1 identityHash = (obj at: 1) identityHash].
	self should: [(obj at: 4) instVar2 class = StompMockMixedClass].
	self 
	    should: [(obj at: 4) instVar2 class = (expected at: 4) instVar2 class].
	self 
	    should: [(obj at: 4) instVar2 identityHash = (obj at: 2) identityHash]
    ]

    testReadClass [
	"self debug: #testReadClass"

	<category: 'tests'>
	| cls |
	cls := StompMockObjectWithCache.
	cls att1: 11.
	cls att2: 22.
	self should: [(Object fromStomp: self classAnswerBytes) = cls]
    ]

    testReadClassNameAndIds [
	"self debug: #testReadClassNameAndIds"

	<category: 'tests'>
	| bytes obj data1 data2 data3 data4 expected |
	bytes := self classNameAndIdsAnswerBytes.
	obj := (StompReader onBytes: bytes) next.
	data1 := StompMockFixedClass new.
	data1 instVar1: 1.
	data1 instVar2: #one.
	data2 := StompMockFixedClass new.
	data2 instVar1: 2.
	data2 instVar2: #two.
	data3 := StompMockMixedClass new.
	data3 instVar1: 3.
	data3 instVar2: #three.
	data4 := StompMockMixedClass new.
	data4 instVar1: 4.
	data4 instVar2: #four.
	expected := Array 
		    with: data1
		    with: data2
		    with: data3
		    with: data4.
	self should: [(obj at: 1) equals: (expected at: 1)].
	self should: [(obj at: 2) equals: (expected at: 2)].
	self should: [(obj at: 3) equals: (expected at: 3)].
	self should: [(obj at: 4) equals: (expected at: 4)]
    ]

    testReadClassNameAndIdsSuppressNilWrites [
	"self debug: #testReadClassNameAndIdsSuppressNilWrites"

	<category: 'tests'>
	| bytes obj data1 data2 data3 data4 expected |
	bytes := self classNameAndIdsSuppressNilWritesAnswerBytes.
	obj := (StompReader onBytes: bytes) next.
	data1 := StompMockFixedClass new.
	data1 instVar1: 1.
	data1 instVar2: #one.
	data2 := StompMockFixedClass new.
	data2 instVar1: 2.
	data2 instVar2: #two.
	data3 := StompMockMixedClass new.
	data3 instVar1: 3.
	data3 instVar2: #three.
	data4 := StompMockMixedClass new.
	data4 instVar1: 4.
	data4 instVar2: #four.
	expected := Array 
		    with: data1
		    with: data2
		    with: data3
		    with: data4.
	self should: [(obj at: 1) equals: (expected at: 1)].
	self should: [(obj at: 2) equals: (expected at: 2)].
	self should: [(obj at: 3) equals: (expected at: 3)].
	self should: [(obj at: 4) equals: (expected at: 4)]
    ]

    gstIgnore_testReadColor [
	"self debug: #testReadColor"

	<category: 'tests'>
	| color1 color2 |
	color1 := StompPortableUtil default testFixturesClass blueColor.
	self should: [(Object fromStomp: self colorAnswerBytes1) = color1].
	color2 := StompPortableUtil default testFixturesClass yellowColor.
	self should: [(Object fromStomp: self colorAnswerBytes2) = color2]
    ]

    testReadCompositeDictionary [
	"self debug: #testReadCompositeDictionary"

	<category: 'tests'>
	| childDic dic readDic |
	childDic := Dictionary new.
	childDic at: #child1 put: 'abcde'.
	dic := Dictionary new.
	dic at: #parent1 put: 'sample string.'.
	dic at: #parent2 put: 100.
	dic at: #parent3 put: #(10 20 30).
	dic at: #parent4 put: childDic.
	readDic := Object fromStomp: self compositeDictionaryAnswerBytes.
	self should: [readDic size = dic size].
	self should: [(readDic at: #parent1) = (dic at: #parent1)].
	self should: [(readDic at: #parent2) = (dic at: #parent2)].
	self should: 
		[self collectionEquals: (readDic at: #parent3) with: (dic at: #parent3)].
	self should: 
		[self collectionEquals: (readDic at: #parent4) associations
		    with: (dic at: #parent4) associations]
    ]

    testReadDate [
	"self debug: #testReadDate"

	<category: 'tests'>
	| bytes inst |
	bytes := self dateAnswerBytes.
	inst := Object fromStomp: bytes.
	self should: [inst class = Date].
	self should: [inst = (Date fromDays: 37023)]
    ]

    testReadDictionary [
	"self debug: #testReadDictionary"

	<category: 'tests'>
	| dic |
	dic := Dictionary new.
	dic at: #key1 put: 'value1'.
	dic at: #key2 put: 'value2'.
	dic at: #key3 put: 'value3'.
	self should: 
		[self collectionEquals: (Object fromStomp: self dictionaryAnswerBytes)
		    with: dic]
    ]

    testReadDuration [
	"self debug: #testReadDuration"

	<category: 'tests'>
	| duration inst |
	duration := self durationAnswerBytes.
	inst := Object fromStomp: duration.
	self should: [inst class = Duration].
	self should: [inst = 123 seconds]
    ]

    testReadFixedClassWithNilValues [
	"self debug: #testReadFixedClassWithNilValues"

	<category: 'tests'>
	| data |
	data := StompMockFixedClass new.
	data instVar1: 1.
	data instVar2: nil.
	data instVar3: StompPortableUtil default testFixturesClass double3dot3.
	data instVar4: nil.
	data instVar5: 'FIVE'.
	self should: 
		[data equals: (Object fromStomp: self fixedClassWithNilValuesAnswerBytes
			    setting: [:ctx | ctx settings suppressNilWrite: true])]
    ]

    testReadFraction [
	"self debug: #testReadFraction"

	<category: 'tests'>
	| fra |
	fra := 3 / 4.
	self should: [(Object fromStomp: self fractionAnswerBytes) = fra]
    ]

    testReadInterval [
	"self debug: #testReadInterval"

	<category: 'tests'>
	| interval |
	interval := 1 to: 10 by: 3.
	self should: [(Object fromStomp: self intervalAnswerBytes) = interval]
    ]

    testReadMixedClassNoVariableData [
	"self debug: #testReadMixedClassNoVariableData"

	<category: 'tests'>
	| data |
	data := StompMockMixedClass new.
	data instVar1: #(true false).
	data instVar2: #(nil #()).
	self should: 
		[data equals: (Object fromStomp: self mixedClassNoVariableDataAnswerBytes)]
    ]

    testReadNumber [
	"self debug: #testReadNumber"

	<category: 'tests'>
	self should: [(Object fromStomp: #[1]) = 1].
	self should: [(Object fromStomp: self floatingPointAnswerBytes1) = 1.2].
	self should: 
		[(Object fromStomp: self floatingPointAnswerBytes2) 
		    = StompPortableUtil default testFixturesClass double1234567890dot123456789]
    ]

    testReadOrdredCollection [
	"self debug: #testReadOrdredCollection"

	<category: 'tests'>
	| ord |
	ord := OrderedCollection new.
	ord add: 10.
	ord add: 20.
	ord add: 30.
	self should: [(Object fromStomp: self ordredCollectionAnswerBytes) = ord]
    ]

    testReadRectangle [
	"self debug: #testReadRectangle"

	<category: 'tests'>
	| rect |
	rect := 1 @ 1 corner: 3 @ 4.
	self should: [(Object fromStomp: self rectangleAnswerBytes) = rect]
    ]

    testReadRecursiveArray [
	"self debug: #testReadRecursiveArray"

	<category: 'tests'>
	| arr readArray |
	arr := Array new: 3.
	arr at: 1 put: 10.
	arr at: 2 put: 20.
	arr at: 3 put: arr.
	readArray := Object fromStomp: self recursiveArrayAnswerBytes.
	self should: [readArray size = arr size].
	self should: [(readArray at: 1) = (arr at: 1)].
	self should: [(readArray at: 2) = (arr at: 2)].
	self should: [(readArray at: 3) identityHash = readArray identityHash]
    ]

    testReadRunArray [
	"self debug: #testReadRunArray"

	<category: 'tests'>
	| arr |
	arr := RunArray runs: #(1 2 1) values: #(1 2 3).
	self should: [(Object fromStomp: self runArrayAnswerBytes) = arr]
    ]

    testReadSet [
	"self debug: #testReadSet"

	<category: 'tests'>
	| set |
	set := Set new.
	set add: 10.
	set add: 20.
	set add: 30.
	set add: 30.
	self should: [(Object fromStomp: self setAnswerBytes) = set]
    ]

    testReadSharedRefrences1 [
	"self debug: #testReadSharedRefrences1"

	<category: 'tests'>
	| bytes reader obj inst1 inst2 expected |
	bytes := self sharedReferenceAnswerBytes.
	reader := StompReader onBytes: bytes.
	obj := reader next.
	inst1 := StompMockVariableClass new: 3.
	inst1 at: 1 put: 1.
	inst1 at: 2 put: 'two'.
	inst1 at: 3 put: StompPortableUtil default testFixturesClass double3dot3.
	inst2 := StompMockMixedClass new: 3.
	inst2 at: 1 put: 1.
	inst2 at: 2 put: 'two'.
	inst2 at: 3 put: StompPortableUtil default testFixturesClass double3dot3.
	inst2 instVar1: #(true false).
	inst2 instVar2: #(nil #()).
	expected := Array 
		    with: inst1
		    with: inst2
		    with: inst1
		    with: inst2.
	self should: [obj = expected]
    ]

    testReadString [
	"self debug: #testReadString"

	<category: 'tests'>
	| str1 |
	str1 := 'Hi, I''m String-object'.
	self should: [(Object fromStomp: self stringAnswerBytes) = str1]
    ]

    testReadTime [
	"self debug: #testReadTime"

	<category: 'tests'>
	| bytes inst |
	bytes := self timeAnswerBytes.
	inst := Object fromStomp: bytes.
	self should: [inst class = Time].
	self should: [inst = (Time fromSeconds: 84072)]
    ]

    testReadTimestamp [
	"self debug: #testReadTimestamp"

	<category: 'tests'>
	| timestamp |
	timestamp := StompPortableUtil default testFixturesClass timestamp1.
	self should: [(Object fromStomp: self timestampAnswerBytes) = timestamp]
    ]

    testReadUndefinedObject [
	"self debug: #testReadUndefinedObject"

	<category: 'tests'>
	self should: [(Object fromStomp: #[192]) = nil]
    ]
]



StompTestCase subclass: StompShapeChangerTestCase [
    
    <comment: nil>
    <category: 'StompTest-Core'>

    fixedClassOLDAnswerArray1 [
	<category: 'fixtures'>
	^#[147 161 2 129 17 218 0 22 83 116 111 109 112 77 111 99 107 70 105 120 101 100 67 108 97 115 115 79 76 68 129 149 168 105 110 115 116 86 97 114 49 168 105 110 115 116 86 97 114 50 168 105 110 115 116 86 97 114 51 168 105 110 115 116 86 97 114 52 168 105 110 115 116 86 97 114 53 149 1 146 161 5 163 116 119 111 203 64 10 102 102 102 102 102 102 194 146 161 4 164 70 73 86 69]
    ]

    fixedClassOLDAnswerArray2 [
	<category: 'fixtures'>
	^#[147 161 2 129 17 218 0 19 83 116 111 109 112 77 111 99 107 70 105 120 101 100 67 108 97 115 115 129 149 168 105 110 115 116 86 97 114 49 171 105 110 115 116 86 97 114 50 79 76 68 168 105 110 115 116 86 97 114 51 168 105 110 115 116 86 97 114 52 168 105 110 115 116 86 97 114 54 149 1 146 161 5 170 114 101 110 97 109 101 100 84 119 111 203 64 10 102 102 102 102 102 102 194 146 161 4 167 65 68 68 69 68 45 54]
    ]

    mockPersonAnswerArray1 [
	<category: 'fixtures'>
	^#[147 161 2 129 17 218 0 18 83 116 111 109 112 77 111 99 107 80 101 114 115 111 110 79 76 68 129 147 168 102 117 108 108 78 97 109 101 168 114 101 113 117 101 115 116 115 168 112 97 114 116 110 101 114 115 147 146 161 4 161 65 146 147 161 2 129 17 218 0 16 83 116 111 109 112 77 111 99 107 82 101 113 117 101 115 116 129 146 162 105 100 165 111 119 110 101 114 146 1 146 161 3 0 147 161 2 1 147 1 2 147 161 2 0 148 0 146 161 4 161 66 192 145 146 161 3 0 192]
    ]

    renamedComplexReadAnswerArray1 [
	<category: 'fixtures'>
	^#[147 147 161 2 129 17 218 0 30 83 116 111 109 112 77 111 99 107 83 104 97 112 101 67 104 97 110 103 101 100 79 98 106 101 99 116 79 76 68 129 146 172 111 108 100 78 97 109 101 100 86 97 114 49 172 111 114 105 103 105 110 97 108 65 116 116 49 146 1 3 147 161 2 0 147 0 11 33 146 161 3 1]
    ]

    renamedComplexReadAnswerArray2 [
	<category: 'fixtures'>
	^#[148 147 161 2 129 17 218 0 30 83 116 111 109 112 77 111 99 107 83 104 97 112 101 67 104 97 110 103 101 100 79 98 106 101 99 116 79 76 68 129 146 172 111 108 100 78 97 109 101 100 86 97 114 49 172 111 114 105 103 105 110 97 108 65 116 116 49 146 1 3 147 161 2 0 147 0 11 33 146 161 3 1 146 161 4 164 104 101 114 101]
    ]

    renamedComplexReadAnswerArray3 [
	<category: 'fixtures'>
	^#[147 147 161 2 129 17 218 0 30 83 116 111 109 112 77 111 99 107 83 104 97 112 101 67 104 97 110 103 101 100 79 98 106 101 99 116 79 76 68 129 146 172 111 108 100 78 97 109 101 100 86 97 114 49 172 111 114 105 103 105 110 97 108 65 116 116 49 146 1 3 147 161 2 0 147 0 11 33 146 161 3 1]
    ]

    renamedComplexReadAnswerArray4 [
	<category: 'fixtures'>
	^#[148 147 161 2 129 17 218 0 30 83 116 111 109 112 77 111 99 107 83 104 97 112 101 67 104 97 110 103 101 100 79 98 106 101 99 116 79 76 68 129 147 172 111 108 100 78 97 109 101 100 86 97 114 49 172 111 114 105 103 105 110 97 108 65 116 116 49 167 111 108 100 86 97 114 50 147 1 3 192 147 161 2 0 148 0 11 33 44 146 161 3 1 146 161 4 164 104 101 114 101]
    ]

    renamedNewFailedAnswerArray1 [
	<category: 'fixtures'>
	^#[147 147 161 2 129 17 218 0 30 83 116 111 109 112 77 111 99 107 70 105 120 101 100 65 108 116 101 114 110 97 116 105 118 101 67 108 97 115 115 129 147 164 97 116 116 49 164 97 116 116 50 169 97 116 116 51 66 108 111 99 107 147 1 2 192 147 161 2 0 148 0 3 4 192 146 161 3 1]
    ]

    renamedReadFailedAnswerArray1 [
	<category: 'fixtures'>
	^#[147 161 2 129 17 218 0 19 83 116 111 109 112 77 111 99 107 70 105 120 101 100 67 108 97 115 115 129 149 168 105 110 115 116 86 97 114 49 168 105 110 115 116 86 97 114 50 168 105 110 115 116 86 97 114 51 168 105 110 115 116 86 97 114 52 168 105 110 115 116 86 97 114 53 149 146 161 4 165 116 101 115 116 49 147 161 2 129 17 218 0 23 83 116 111 109 112 77 111 99 107 70 105 120 101 100 67 108 97 115 115 50 79 76 68 129 149 168 105 110 115 116 86 97 114 49 168 105 110 115 116 86 97 114 50 168 105 110 115 116 86 97 114 51 168 105 110 115 116 86 97 114 52 168 105 110 115 116 86 97 114 53 149 146 161 4 165 116 101 115 116 50 192 192 192 192 146 161 4 165 116 101 115 116 51 149 161 2 129 17 218 0 19 83 116 111 109 112 77 111 99 107 77 105 120 101 100 67 108 97 115 115 2 129 146 168 105 110 115 116 86 97 114 49 168 105 110 115 116 86 97 114 50 146 192 192 146 146 161 4 165 116 101 115 116 52 147 161 2 1 150 1 146 161 4 165 116 101 115 116 53 192 192 192 192 192]
    ]

    testBlockRenamedComplexShapeChangerRead [
	"self debug: #testBlockRenamedComplexShapeChangerRead"

	<category: 'testing'>
	| bytes arr obj1 obj2 obj3 |
	bytes := self renamedComplexReadAnswerArray3.
	arr := Object fromStomp: bytes
		    setting: 
			[:ctx | 
			ctx registerClassOldName: #StompMockShapeChangedObjectOLD
			    for: StompMockShapeChangedObject.
			ctx 
			    registerShapeChangerRenameBy: 
				[:target :oldName :value | 
				oldName = 'oldNamedVar1' ifTrue: [target renamedAtt1: value]]
			    initializeBy: [:target | target addedAtt1: 22222]
			    for: StompMockShapeChangedObject].
	self should: [arr class = Array].
	self should: [arr size = 3].
	obj1 := arr at: 1.
	self should: [obj1 renamedAtt1 = 1].
	self should: [obj1 addedAtt1 = 22222].
	self should: [obj1 originalAtt1 = 3].
	obj2 := arr at: 2.
	self should: [obj2 renamedAtt1 = 11].
	self should: [obj2 addedAtt1 = 22222].
	self should: [obj2 originalAtt1 = 33].
	obj3 := arr at: 3.
	self should: [obj3 = obj1]
    ]

    testBlockShapeChangedRead [
	"self debug: #testBlockShapeChangedRead"

	<category: 'testing'>
	| bytes inst expected |
	bytes := self fixedClassOLDAnswerArray2.
	inst := Object fromStomp: bytes
		    setting: 
			[:ctx | 
			ctx 
			    registerShapeChangerRenameBy: 
				[:target :oldName :value | 
				oldName = 'instVar2OLD' ifTrue: [target instVar2: value]]
			    initializeBy: [:target | target instVar5: 'FIVE']
			    for: StompMockFixedClass].
	expected := StompMockFixedClass new.
	expected instVar1: 1.
	expected instVar2: #renamedTwo.
	expected instVar3: StompPortableUtil default testFixturesClass double3dot3.
	expected instVar4: false.
	expected instVar5: 'FIVE'.
	self should: [inst equals: expected]
    ]

    testNewFailedRead [
	"self debug: #testNewFailedRead"

	<category: 'testing'>
	| bytes arr obj1 obj2 obj3 |
	bytes := self renamedNewFailedAnswerArray1.
	arr := Object fromStomp: bytes
		    setting: 
			[:ctx | 
			ctx registerClassOldName: #StompMockFixedNewFailedClass
			    for: StompMockFixedAlternativeClass].
	self should: [arr class = Array].
	self should: [arr size = 3].
	obj1 := arr at: 1.
	self should: [obj1 class = StompMockFixedAlternativeClass].
	self should: [obj1 att1 = 1].
	self should: [obj1 att2 = 2].
	self should: [obj1 att3Block notNil].
	obj2 := arr at: 2.
	self should: [obj2 class = StompMockFixedAlternativeClass].
	self should: [obj2 att1 = 3].
	self should: [obj2 att2 = 4].
	self should: [obj2 att3Block notNil].
	obj3 := arr at: 3.
	self should: [obj3 = obj1]
    ]

    testRenamedComplexRead [
	"self debug: #testRenamedComplexRead"

	<category: 'testing'>
	| bytes arr obj1 obj2 obj3 |
	bytes := self renamedComplexReadAnswerArray1.
	arr := Object fromStomp: bytes
		    setting: 
			[:ctx | 
			ctx registerClassOldName: #StompMockShapeChangedObjectOLD
			    for: StompMockShapeChangedObject].
	self should: [arr class = Array].
	self should: [arr size = 3].
	obj1 := arr at: 1.
	self should: [obj1 renamedAtt1 = 1].
	self should: [obj1 addedAtt1 = 2].
	self should: [obj1 originalAtt1 = 3].
	obj2 := arr at: 2.
	self should: [obj2 renamedAtt1 = 11].
	self should: [obj2 addedAtt1 = 2].
	self should: [obj2 originalAtt1 = 33].
	obj3 := arr at: 3.
	self should: [obj3 = obj1]
    ]

    testRenamedComplexReadFailed [
	"self debug: #testRenamedComplexReadFailed"

	<category: 'testing'>
	| bytes arr |
	bytes := self renamedComplexReadAnswerArray2.
	arr := Object fromStomp: bytes
		    setting: 
			[:ctx | 
			ctx registerClassOldName: #StompMockShapeChangedObjectFAILED
			    for: StompMockShapeChangedObject].
	self should: [arr class = Array].
	self should: [arr size = 4].
	self should: [arr = #(nil nil nil 'here')]
    ]

    testRenamedComplexShapeChangerRead [
	"self debug: #testRenamedComplexShapeChangerRead"

	<category: 'testing'>
	| bytes arr obj1 obj2 obj3 |
	bytes := self renamedComplexReadAnswerArray3.
	arr := Object fromStomp: bytes
		    setting: 
			[:ctx | 
			ctx 
			    registerClassOldName: #StompMockShapeChangedObjectOLD
			    shapeChanger: StompMockShapeChangerForRenamedComplexRead
			    for: StompMockShapeChangedObject].
	self should: [arr class = Array].
	self should: [arr size = 3].
	obj1 := arr at: 1.
	self should: [obj1 renamedAtt1 = 1].
	self should: [obj1 addedAtt1 = 22222].
	self should: [obj1 originalAtt1 = 3].
	obj2 := arr at: 2.
	self should: [obj2 renamedAtt1 = 11].
	self should: [obj2 addedAtt1 = 22222].
	self should: [obj2 originalAtt1 = 33].
	obj3 := arr at: 3.
	self should: [obj3 = obj1]
    ]

    testRenamedComplexShapeChangerReadFailed [
	"self debug: #testRenamedComplexShapeChangerReadFailed"

	<category: 'testing'>
	| bytes arr |
	bytes := self renamedComplexReadAnswerArray4.
	arr := Object fromStomp: bytes
		    setting: 
			[:ctx | 
			ctx registerShapeChanger: StompMockShapeChangerForRenamedComplexRead
			    for: StompMockFixedClass].
	self should: [arr class = Array].
	self should: [arr size = 4].
	self should: [arr = #(nil nil nil 'here')]
    ]

    testRenamedRead [
	"self debug: #testRenamedRead"

	<category: 'testing'>
	| bytes inst expected |
	bytes := self fixedClassOLDAnswerArray1.
	inst := Object fromStomp: bytes
		    setting: 
			[:ctx | 
			ctx registerClassOldName: #StompMockFixedClassOLD for: StompMockFixedClass].
	expected := StompMockFixedClass new.
	expected instVar1: 1.
	expected instVar2: #two.
	expected instVar3: StompPortableUtil default testFixturesClass double3dot3.
	expected instVar4: false.
	expected instVar5: 'FIVE'.
	self should: [inst equals: expected]
    ]

    testRenamedReadFailed [
	"self debug: #testRenamedReadFailed"

	<category: 'testing'>
	| bytes inst |
	bytes := self renamedReadFailedAnswerArray1.

	"By default, unresolved class's instance will be nil"
	inst := Object fromStomp: bytes.
	self should: [inst class = StompMockFixedClass].
	self should: [inst instVar1 = 'test1'].
	self should: [inst instVar2 isNil].
	self should: [inst instVar3 = 'test3'].
	self should: [inst instVar4 class = StompMockMixedClass].
	self should: [(inst instVar4 at: 1) = 'test4'].
	self should: [(inst instVar4 at: 2) isNil].
	self should: [inst instVar5 isNil].

	"Override the behavior by context"
	inst := Object fromStomp: bytes
		    setting: 
			[:ctx | 
			ctx registerClassOldName: #StompMockFixedClass2OLD
			    for: StompMockFixedClass2].
	self should: [inst class = StompMockFixedClass].
	self should: [inst instVar1 = 'test1'].
	self should: [inst instVar2 class = StompMockFixedClass2].
	self should: [inst instVar2 instVar1 = 'test2'].
	self should: [inst instVar3 = 'test3'].
	self should: [inst instVar4 class = StompMockMixedClass].
	self should: [(inst instVar4 at: 1) = 'test4'].
	self should: [(inst instVar4 at: 2) class = StompMockFixedClass2].
	self should: [(inst instVar4 at: 2) instVar1 = 'test5'].
	self should: [inst instVar5 isNil].

	"Or you can use exception handling"
	inst := [Object fromStomp: bytes] on: StompClassNotFound
		    do: 
			[:ex | 
			ex resume: (ex className == #StompMockFixedClass2OLD 
				    ifTrue: [StompMockFixedClass2]
				    ifFalse: [ex unresolvedClass])].
	self should: [inst class = StompMockFixedClass].
	self should: [inst instVar1 = 'test1'].
	self should: [inst instVar2 class = StompMockFixedClass2].
	self should: [inst instVar2 instVar1 = 'test2'].
	self should: [inst instVar3 = 'test3'].
	self should: [inst instVar4 class = StompMockMixedClass].
	self should: [(inst instVar4 at: 1) = 'test4'].
	self should: [(inst instVar4 at: 2) class = StompMockFixedClass2].
	self should: [(inst instVar4 at: 2) instVar1 = 'test5'].
	self should: [inst instVar5 isNil]
    ]

    testRenamedShapeChangedRead [
	"self debug: #testRenamedShapeChangedRead"

	<category: 'testing'>
	| bytes inst expected |
	bytes := self fixedClassOLDAnswerArray2.
	inst := Object fromStomp: bytes
		    setting: 
			[:ctx | 
			ctx 
			    registerClassOldName: #StompMockFixedClassOLD
			    shapeChanger: StompMockShapeChanger
			    for: StompMockFixedClass].
	expected := StompMockFixedClass new.
	expected instVar1: 1.
	expected instVar2: #renamedTwo.
	expected instVar3: StompPortableUtil default testFixturesClass double3dot3.
	expected instVar4: false.
	expected instVar5: 'FIVE'.
	self should: [inst equals: expected]
    ]

    testShapeChangedRead [
	"self debug: #testShapeChangedRead"

	<category: 'testing'>
	| bytes inst expected |
	bytes := self fixedClassOLDAnswerArray2.
	inst := Object fromStomp: bytes
		    setting: 
			[:ctx | 
			ctx registerShapeChanger: StompMockShapeChanger for: StompMockFixedClass].
	expected := StompMockFixedClass new.
	expected instVar1: 1.
	expected instVar2: #renamedTwo.
	expected instVar3: StompPortableUtil default testFixturesClass double3dot3.
	expected instVar4: false.
	expected instVar5: 'FIVE'.
	self should: [inst equals: expected]
    ]

    testShapeChangedReadCircularReference [
	"self debug: #testShapeChangedReadCircularReference"

	<category: 'testing'>
	| bytes obj |
	bytes := self mockPersonAnswerArray1.
	obj := Object fromStomp: bytes
		    setting: 
			[:ctx | 
			ctx 
			    registerClassOldName: #StompMockPersonOLD
			    shapeChanger: StompMockPersonShapeChanger
			    for: StompMockPerson].
	self should: [obj class = StompMockPerson].
	self should: [obj name = 'A'].
	self should: [obj requests size = 2].
	self should: [(obj requests detect: [:each | each id = 1]) owner = obj].
	self 
	    should: [(obj requests detect: [:each | each id = 2]) owner name = 'B'].
	self 
	    should: [(obj requests detect: [:each | each id = 2]) owner partners size = 1].
	self should: 
		[((obj requests detect: [:each | each id = 2]) owner partners at: 1) = obj]
    ]
]



StompTestCase subclass: StompWriterTestCase [
    
    <comment: 'self suite run'>
    <category: 'StompTest-Core'>

    testWriteBag [
	"self debug: #testWriteBag"

	<category: 'tests'>
	| bag actual expected |
	bag := Bag new.
	bag add: 10.
	bag add: 20.
	bag add: 30.
	bag add: 30.
	expected := self bagAnswerBytes.
	actual := bag toStomp.
	self should: [actual size = 9].
	self should: [(actual copyFrom: 1 to: 5) = (expected copyFrom: 1 to: 5)].
	self should: 
		[(actual copyFrom: 6 to: 9) asSortedCollection 
		    = (expected copyFrom: 6 to: 9) asSortedCollection]
    ]

    testWriteBasicArray [
	"self debug: #testWriteBasicArray"

	<category: 'tests'>
	| data wstr bytes |
	data := #(1 2 3 #('Hello' 2 3)).
	wstr := StompWriter onBytes: ByteArray new.
	wstr nextPut: data.
	bytes := wstr contents.
	self should: [bytes = self basicArrayAnswerBytes]
    ]

    testWriteBasicBitsClass [
	"self debug: #testWriteBasicBitsClass"

	<category: 'tests'>
	| data wstr bytes |
	data := StompMockByteArray new: 3.
	data at: 1 put: 0.
	data at: 2 put: 127.
	data at: 3 put: 255.
	wstr := StompWriter onBytes: ByteArray new.
	wstr nextPut: data.
	bytes := wstr contents.
	self should: [bytes = self basicBitsClassAnswerBytes]
    ]

    testWriteBasicFixedClass [
	"self debug: #testWriteBasicFixedClass"

	<category: 'tests'>
	| data wstr bytes |
	data := StompMockFixedClass new.
	data instVar1: 1.
	data instVar2: #two.
	data instVar3: 3.3.
	data instVar4: false.
	data instVar5: 'FIVE'.
	wstr := StompWriter onBytes: ByteArray new.
	wstr nextPut: data.
	bytes := wstr contents.
	self should: [bytes = self basicFixedClassAnswerBytes]
    ]

    testWriteBasicMixedClass [
	"self debug: #testWriteBasicMixedClass"

	<category: 'tests'>
	| data wstr bytes |
	data := StompMockMixedClass new: 3.
	data at: 1 put: 1.
	data at: 2 put: 'two'.
	data at: 3 put: StompPortableUtil default testFixturesClass double3dot3.
	data instVar1: #(true false).
	data instVar2: #(nil #()).
	wstr := StompWriter onBytes: ByteArray new.
	wstr nextPut: data.
	bytes := wstr contents.
	self should: [bytes = self basicMixedClassAnswerBytes]
    ]

    testWriteBasicVariableClass [
	"self debug: #testWriteBasicVariableClass"

	<category: 'tests'>
	| data wstr bytes |
	data := StompMockVariableClass new: 3.
	data at: 1 put: 1.
	data at: 2 put: 'two'.
	data at: 3 put: StompPortableUtil default testFixturesClass double3dot3.
	wstr := StompWriter onBytes: ByteArray new.
	wstr nextPut: data.
	bytes := wstr contents.
	self should: [bytes = self basicVariableClassAnswerBytes]
    ]

    testWriteBoolean [
	"self debug: #testWriteBoolean"

	<category: 'tests'>
	self should: [true toStomp = #[195]].
	self should: [false toStomp = #[194]]
    ]

    testWriteByteArray [
	"self debug: #testWriteByteArray"

	<category: 'tests'>
	| byteArray |
	byteArray := ByteArray 
		    with: 10
		    with: 20
		    with: 30.
	self should: [byteArray toStomp = #[163 10 20 30]]
    ]

    testWriteCharacter [
	"self debug: #testWriteCharacter"

	<category: 'tests'>
	| char1 char2 |
	char1 := $A.
	self should: [char1 toStomp = #[147 161 2 253 65]].
	char2 := StompPortableUtil default characterFromUnicode: 12354.	"Japanese Hiragana 'A'"
	self should: [char2 toStomp = #[147 161 2 253 205 48 66]]
    ]

    testWriteCircularRefrences1 [
	"self debug: #testWriteCircularRefrences1"

	<category: 'tests'>
	| inst1 inst2 data wstr bytes |
	inst1 := StompMockVariableClass new: 3.
	inst1 at: 1 put: 1.
	inst1 at: 2 put: 'two'.
	inst1 at: 3 put: inst1.
	inst2 := StompMockMixedClass new: 3.
	inst2 at: 1 put: 1.
	inst2 at: 2 put: 'two'.
	inst2 at: 3 put: StompPortableUtil default testFixturesClass double3dot3.
	inst2 instVar1: inst1.
	inst2 instVar2: inst2.
	data := Array 
		    with: inst1
		    with: inst2
		    with: inst1
		    with: inst2.
	wstr := StompWriter onBytes: ByteArray new.
	wstr nextPut: data.
	bytes := wstr contents.
	self should: [bytes = self circularRefrencesAnswerBytes]
    ]

    testWriteClass [
	"self debug: #testWriteClass"

	<category: 'tests'>
	| cls bytes |
	cls := StompMockObjectWithCache.
	cls att1: 11.
	cls att2: 22.
	bytes := cls toStomp.
	self should: [bytes = self classAnswerBytes]
    ]

    testWriteClassNameAndIds [
	"self debug: #testWriteClassNameAndIds"

	<category: 'tests'>
	| data1 data2 data3 data4 wstr bytes data |
	data1 := StompMockFixedClass new.
	data1 instVar1: 1.
	data1 instVar2: #one.
	data2 := StompMockFixedClass new.
	data2 instVar1: 2.
	data2 instVar2: #two.
	data3 := StompMockMixedClass new.
	data3 instVar1: 3.
	data3 instVar2: #three.
	data4 := StompMockMixedClass new.
	data4 instVar1: 4.
	data4 instVar2: #four.
	data := Array 
		    with: data1
		    with: data2
		    with: data3
		    with: data4.
	wstr := StompWriter onBytes: ByteArray new.
	wstr settings suppressNilWrite: false.
	wstr nextPut: data.
	bytes := wstr contents.
	self should: [bytes = self classNameAndIdsAnswerBytes]
    ]

    testWriteClassNameAndIdsSuppressNilWrites [
	"self debug: #testWriteClassNameAndIdsSuppressNilWrites"

	<category: 'tests'>
	| data1 data2 data3 data4 wstr bytes data |
	data1 := StompMockFixedClass new.
	data1 instVar1: 1.
	data1 instVar2: #one.
	data2 := StompMockFixedClass new.
	data2 instVar1: 2.
	data2 instVar2: #two.
	data3 := StompMockMixedClass new.
	data3 instVar1: 3.
	data3 instVar2: #three.
	data4 := StompMockMixedClass new.
	data4 instVar1: 4.
	data4 instVar2: #four.
	data := Array 
		    with: data1
		    with: data2
		    with: data3
		    with: data4.
	wstr := StompWriter onBytes: ByteArray new.
	wstr settings suppressNilWrite: true.
	wstr nextPut: data.
	bytes := wstr contents.
	self should: [bytes = self classNameAndIdsSuppressNilWritesAnswerBytes]
    ]

    gstIgnore_testWriteColor [
	"self debug: #testWriteColor"

	<category: 'tests'>
	| color1 bytes1 color2 bytes2 |
	color1 := StompPortableUtil default testFixturesClass blueColor.
	bytes1 := color1 toStomp.
	self should: [bytes1 = self colorAnswerBytes1].
	color2 := StompPortableUtil default testFixturesClass yellowColor.
	bytes2 := color2 toStomp.
	self should: [bytes2 = self colorAnswerBytes2]
    ]

    testWriteCompositeDictionary [
	"self debug: #testWriteCompositeDictionary"

	<category: 'tests'>
	| childDic dic bytes rawDic rawChildDic |
	childDic := Dictionary new.
	childDic at: #child1 put: 'abcde'.
	dic := Dictionary new.
	dic at: #parent1 put: 'sample string.'.
	dic at: #parent2 put: 100.
	dic at: #parent3 put: #(10 20 30).
	dic at: #parent4 put: childDic.
	bytes := dic toStomp.
	rawDic := Object fromMessagePack: bytes.
	self should: [rawDic size = 4].
	self should: 
		[(rawDic at: #(#[5] #[112 97 114 101 110 116 49])) 
		    = #(#[4] #[115 97 109 112 108 101 32 115 116 114 105 110 103 46])].
	self should: [(rawDic at: #(#[5] #[112 97 114 101 110 116 50])) = 100].
	self 
	    should: [(rawDic at: #(#[5] #[112 97 114 101 110 116 51])) = #(10 20 30)].
	rawChildDic := rawDic at: #(#[5] #[112 97 114 101 110 116 52]).
	self should: 
		[(rawChildDic at: #(#[5] #[99 104 105 108 100 49])) 
		    = #(#[4] #[97 98 99 100 101])]
    ]

    testWriteDate [
	"self debug: #testWriteDate"

	<category: 'tests'>
	| date bytes |
	date := Date fromDays: 37023.
	bytes := date toStomp.
	self should: [bytes = self dateAnswerBytes]
    ]

    testWriteDictionary [
	"self debug: #testWriteDictionary"

	<category: 'tests'>
	| dic bytes rawDic |
	dic := Dictionary new.
	dic at: #key1 put: 'value1'.
	dic at: #key2 put: 'value2'.
	dic at: #key3 put: 'value3'.
	bytes := dic toStomp.
	rawDic := Object fromMessagePack: bytes.
	self should: [rawDic size = 3].
	self should: 
		[(rawDic at: #(#[5] #[107 101 121 49])) = #(#[4] #[118 97 108 117 101 49])].
	self should: 
		[(rawDic at: #(#[5] #[107 101 121 50])) = #(#[4] #[118 97 108 117 101 50])].
	self should: 
		[(rawDic at: #(#[5] #[107 101 121 51])) = #(#[4] #[118 97 108 117 101 51])]
    ]

    testWriteDuration [
	"self debug: #testWriteDuration"

	<category: 'tests'>
	| duration bytes |
	duration := 123 seconds.
	bytes := duration toStomp.
	self should: [bytes = self durationAnswerBytes]
    ]

    testWriteFixedClassWithNilValues [
	"self debug: #testWriteFixedClassWithNilValues"

	<category: 'tests'>
	| data wstr bytes |
	data := StompMockFixedClass new.
	data instVar1: 1.
	data instVar2: nil.
	data instVar3: StompPortableUtil default testFixturesClass double3dot3.
	data instVar4: nil.
	data instVar5: 'FIVE'.
	wstr := StompWriter onBytes: ByteArray new.
	wstr settings suppressNilWrite: true.
	wstr nextPut: data.
	bytes := wstr contents.
	self should: [bytes = self fixedClassWithNilValuesAnswerBytes]
    ]

    testWriteFraction [
	"self debug: #testWriteFraction"

	<category: 'tests'>
	| fra bytes |
	fra := 3 / 4.
	bytes := fra toStomp.
	self should: [bytes = self fractionAnswerBytes]
    ]

    testWriteInterval [
	"self debug: #testWriteInterval"

	<category: 'tests'>
	| interval bytes |
	interval := 1 to: 10 by: 3.
	bytes := interval toStomp.
	self should: [bytes = self intervalAnswerBytes]
    ]

    testWriteMixedClassNoVariableData [
	"self debug: #testWriteMixedClassNoVariableData"

	<category: 'tests'>
	| data wstr bytes |
	data := StompMockMixedClass new.
	data instVar1: #(true false).
	data instVar2: #(nil #()).
	wstr := StompWriter onBytes: ByteArray new.
	wstr nextPut: data.
	bytes := wstr contents.
	self should: [bytes = self mixedClassNoVariableDataAnswerBytes]
    ]

    testWriteNumber [
	"self debug: #testWriteNumber"

	<category: 'tests'>
	self should: [1 toStomp = #[1]].
	self should: [1.2 toStomp = self floatingPointAnswerBytes1].
	self should: 
		[StompPortableUtil default testFixturesClass double1234567890dot123456789 
		    toStomp = self floatingPointAnswerBytes2]
    ]

    testWriteOrdredCollection [
	"self debug: #testWriteOrdredCollection"

	<category: 'tests'>
	| ord bytes |
	ord := OrderedCollection new.
	ord add: 10.
	ord add: 20.
	ord add: 30.
	bytes := ord toStomp.
	self should: [bytes = self ordredCollectionAnswerBytes]
    ]

    testWriteRectangle [
	"self debug: #testWriteRectangle"

	<category: 'tests'>
	| rect bytes |
	rect := 1 @ 1 corner: 3 @ 4.
	bytes := rect toStomp.
	self should: [bytes = self rectangleAnswerBytes]
    ]

    testWriteRecursiveArray [
	"self debug: #testWriteRecursiveArray"

	<category: 'tests'>
	| arr bytes |
	arr := Array new: 3.
	arr at: 1 put: 10.
	arr at: 2 put: 20.
	arr at: 3 put: arr.
	bytes := arr toStomp.
	self should: [bytes = self recursiveArrayAnswerBytes]
    ]

    testWriteRunArray [
	"self debug: #testWriteRunArray"

	<category: 'tests'>
	| arr bytes |
	arr := RunArray runs: #(1 2 1) values: #(1 2 3).
	bytes := arr toStomp.
	self should: [bytes = self runArrayAnswerBytes]
    ]

    testWriteSet [
	"self debug: #testWriteSet"

	<category: 'tests'>
	| set expected actual |
	set := Set new.
	set add: 10.
	set add: 20.
	set add: 30.
	set add: 30.
	expected := self setAnswerBytes.
	actual := set toStomp.
	self should: [actual size = 8].
	self should: [(actual copyFrom: 1 to: 5) = (expected copyFrom: 1 to: 5)].
	self should: 
		[(actual copyFrom: 6 to: 8) asSortedCollection 
		    = (expected copyFrom: 6 to: 8) asSortedCollection]
    ]

    testWriteSharedRefrences1 [
	"self debug: #testWriteSharedRefrences1"

	<category: 'tests'>
	| inst1 inst2 data wstr bytes |
	inst1 := StompMockVariableClass new: 3.
	inst1 at: 1 put: 1.
	inst1 at: 2 put: 'two'.
	inst1 at: 3 put: StompPortableUtil default testFixturesClass double3dot3.
	inst2 := StompMockMixedClass new: 3.
	inst2 at: 1 put: 1.
	inst2 at: 2 put: 'two'.
	inst2 at: 3 put: StompPortableUtil default testFixturesClass double3dot3.
	inst2 instVar1: #(true false).
	inst2 instVar2: #(nil #()).
	data := Array 
		    with: inst1
		    with: inst2
		    with: inst1
		    with: inst2.
	wstr := StompWriter onBytes: ByteArray new.
	wstr nextPut: data.
	bytes := wstr contents.
	self should: [bytes = self sharedReferenceAnswerBytes]
    ]

    testWriteString [
	"self debug: #testWriteString"

	<category: 'tests'>
	| str1 |
	str1 := 'Hi, I''m String-object'.
	self should: [str1 toStomp = self stringAnswerBytes]
    ]

    testWriteSymbol [
	"self debug: #testWriteSymbol"

	<category: 'tests'>
	| symbol1 |
	symbol1 := #abcdefg.
	self should: [symbol1 toStomp = self symbolAnswerBytes]
    ]

    testWriteTime [
	"self debug: #testWriteTime"

	<category: 'tests'>
	| inst bytes |
	inst := Time fromSeconds: 84072.
	bytes := inst toStomp.
	self should: [bytes = self timeAnswerBytes]
    ]

    testWriteTimestamp [
	"self debug: #testWriteTimestamp"

	<category: 'tests'>
	| bytes timestamp |
	timestamp := StompPortableUtil default testFixturesClass timestamp1.
	bytes := timestamp toStomp.
	self should: [bytes = self timestampAnswerBytes]
    ]

    testWriteUndefinedObject [
	"self debug: #testWriteUndefinedObject"

	<category: 'tests'>
	self should: [nil toStomp = #[192]]
    ]
]



StompPortableUtil extend [

    testFixturesClass [
	<category: '*StompTest-Core-factory'>
	self subclassResponsibility
    ]

]

