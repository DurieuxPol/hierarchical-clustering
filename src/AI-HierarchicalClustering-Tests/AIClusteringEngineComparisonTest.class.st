Class {
	#name : 'AIClusteringEngineComparisonTest',
	#superclass : 'Object',
	#instVars : [
		'datasets',
		'linkageMethods',
		'numbersOfClusters'
	],
	#category : 'AI-HierarchicalClustering-Tests',
	#package : 'AI-HierarchicalClustering-Tests'
}

{ #category : 'accessing' }
AIClusteringEngineComparisonTest >> datasets [

	^ datasets
]

{ #category : 'accessing' }
AIClusteringEngineComparisonTest >> datasets: anObject [

	datasets := anObject
]

{ #category : 'as yet unclassified' }
AIClusteringEngineComparisonTest >> defaultFileLocation [
	"Put here the absolute path to the directory where the datasets are stored"

	^ nil
]

{ #category : 'initialization' }
AIClusteringEngineComparisonTest >> initialize [

	datasets := self loadDatasets.
	linkageMethods := { #singleLinkage. #averageLinkage. #completeLinkage. #wardsMethod }.
	numbersOfClusters := { 2. 2. 3 }
]

{ #category : 'accessing' }
AIClusteringEngineComparisonTest >> linkageMethods [

	^ linkageMethods
]

{ #category : 'accessing' }
AIClusteringEngineComparisonTest >> linkageMethods: anObject [

	linkageMethods := anObject
]

{ #category : 'as yet unclassified' }
AIClusteringEngineComparisonTest >> loadDatasets [

	| circles moons blobs |
	circles := (DataFrame
		            readFromCsv: (self defaultFileLocation , 'circles.csv') asFileReference
		            withColumnNames: { 'x'. 'y' }
		            separator: $,) collect: [ :row | row collect: #asNumber ].
	moons := (DataFrame
		          readFromCsv: (self defaultFileLocation , 'moons.csv') asFileReference
		          withColumnNames: { 'x'. 'y' }
		          separator: $,) collect: [ :row | row collect: #asNumber ].
	blobs := (DataFrame
		          readFromCsv: (self defaultFileLocation , 'blobs.csv') asFileReference
		          withColumnNames: { 'x'. 'y' }
		          separator: $,) collect: [ :row | row collect: #asNumber ].
	^ {
		  circles.
		  moons.
		  blobs }
]

{ #category : 'accessing' }
AIClusteringEngineComparisonTest >> numbersOfClusters [

	^ numbersOfClusters
]

{ #category : 'accessing' }
AIClusteringEngineComparisonTest >> numbersOfClusters: anObject [

	numbersOfClusters := anObject
]

{ #category : 'rende' }
AIClusteringEngineComparisonTest >> plot [

	<script: 'self new plot open'>
	| canvas layout |
	canvas := RSCanvas new.

	datasets withIndexDo: [ :dataset :index |
			| normalizedDataset |
			normalizedDataset := dataset normalizedUsing: AIStandardizationNormalizer new.

			linkageMethods do: [ :linkage |
					| numberOfCluster clusty clusters compChart |
					numberOfCluster := numbersOfClusters at: index.
					clusty := AIClusterEngine with: normalizedDataset.
					clusty hierarchicalClusteringUsing: linkage.
					clusters := clusty dendrogram breakInto: numberOfCluster.
					compChart := RSCompositeChart new.
					clusters do: [ :cluster | compChart add: (RSScatterPlot new x: (cluster collect: #first) y: (cluster collect: #second)) ].
					compChart colors: NSScale category10.
					compChart removeAllTicks.
					index = 1 ifTrue: [ compChart title: linkage ].
					canvas add: compChart asShape ] ].

	layout := RSGridLayout on: canvas shapes.
	canvas @ RSCanvasController.
	^ canvas
]
