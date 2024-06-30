extends Node

var camera: Camera2D = null
var console: Label = null
var player: CharacterBody2D = null

var opened = false
var music_control =  false

func log(text):
	if console != null:
		console.log(text)

