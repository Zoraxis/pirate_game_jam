extends Node

var camera: Camera2D = null
var console: Label = null
var player: CharacterBody2D = null

func log(text):
	if console != null:
		console.log(text)

var opened = false
