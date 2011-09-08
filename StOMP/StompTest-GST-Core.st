Eval [
    'From Squeak4.2 of 4 February 2011 [latest update: #10966] on 8 August 2011 at 10:30:51 am'
]



StompPortableFixtures subclass: StompGstFixtures [
    
    <comment: nil>
    <category: 'StompTest-GST-Core'>

    StompGstFixtures class >> blueColor [
	<category: 'fixtures'>
	^Color blue
    ]

    StompGstFixtures class >> double1234567890dot123456789 [
	<category: 'fixtures'>
	^FloatD fromBytes: #[65 210 101 128 180 135 230 183]
    ]

    StompGstFixtures class >> double3dot3 [
	<category: 'fixtures'>
	^3.3
    ]

    StompGstFixtures class >> float1dot2bytes [
	<category: 'fixtures'>
	^#[203 63 243 51 51 51 51 51 51]
    ]

    StompGstFixtures class >> timestamp1 [
	<category: 'fixtures'>
	| timestamp tsClass |
	tsClass := StompPortableUtil default popularClassMap timestampClass.
	timestamp := tsClass 
		    date: (StompPortableUtil default dateFromSeconds: 3330720000)
		    time: (Time fromSeconds: 13506).
	^timestamp
    ]

    StompGstFixtures class >> yellowColor [
	<category: 'fixtures'>
	^Color yellow
    ]
]



StompGstPortableUtil extend [

    testFixturesClass [
	<category: '*StompTest-GST-Core-factory'>
	^StompGstFixtures
    ]

]

