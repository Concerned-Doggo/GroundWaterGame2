extends Node2D

var isReadyToFixPipe : bool  = false
var hasSeenLeakage : bool = false
var hasFixedPipe : bool = false

func spokeToElder():
	isReadyToFixPipe = true

func sawTheLeakage():
	hasSeenLeakage = true

func fixedPipe():
	hasFixedPipe = true
