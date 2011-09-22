﻿package net.findzen.utils {	import flash.display.Shape;	import flash.display.Sprite;	import flash.display.Stage;	import flash.events.ContextMenuEvent;	import flash.events.KeyboardEvent;	import flash.net.FileReference;	import flash.system.Capabilities;	import flash.system.System;	import flash.text.TextField;	import flash.text.TextFieldAutoSize;	import flash.text.TextFormat;	import flash.ui.ContextMenu;	import flash.ui.ContextMenuItem;	import flash.utils.Dictionary;	public class DebugPanel {		private static const ALL_LEVELS:String    = 'ALL LEVELS';		private static const SYSTEM:String    = 'SYSTEM';		private static const TXT_COLOR:uint      = 0xFFFFFF;		private static const TXT_SIZE:Number    = 10;		private static const FONT:String    = 'Monaco';		private static const BG_COLOR:uint      = 0x000000;		private static const BG_ALPHA:Number    = .8;		private static var __index:Number    = 0;		private static var __output:Dictionary;		private static var __levels:Array;		private static var __panel:Sprite;		private static var __txt:TextField;		private static var __format:TextFormat;		private static var __stage:Stage;		private static var __menu:ContextMenu;		public function DebugPanel() {		}		////////////////////////////////////////////////////////////////////////////////		// SETUP		private static function __init():void {			__output = new Dictionary();			__levels = new Array();			__panel = new Sprite();			__menu = new ContextMenu();			__panel.visible = false;			__stage.addChild(__panel);			__setupContextMenu();			__drawBg();			__addTextField();			output(ALL_LEVELS);			__getSystemCapabilities();			__stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);		}		private static function __setupContextMenu():void {			var copy:ContextMenuItem                = new ContextMenuItem('Copy current');			copy.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, __copyCurrent);			var copyAll:ContextMenuItem             = new ContextMenuItem('Copy all');			copyAll.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, __copyAll);			var dl:ContextMenuItem                  = new ContextMenuItem('Download log');			dl.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, __download);			__menu.hideBuiltInItems();			__menu.customItems.push(copy, copyAll, dl);			__panel.contextMenu = __menu		}		private static function __drawBg():void {			var bg:Shape = new Shape();			with(bg) {				graphics.beginFill(BG_COLOR);				graphics.drawRect(0, 0, __stage.stageWidth, __stage.stageHeight);				graphics.endFill();				alpha = BG_ALPHA;			}			__panel.addChild(bg);		}		private static function __addTextField():void {			__format = new TextFormat();			__format.font = FONT;			__format.size = TXT_SIZE;			__txt = new TextField();			with(__txt) {				wordWrap = true;				multiline = true;				textColor = TXT_COLOR;				width = __stage.stageWidth;				height = __stage.stageHeight;				defaultTextFormat = __format;			}			__panel.addChild(__txt);		}		private static function __getSystemCapabilities():void {			output(SYSTEM, 'avHardwareDisable: ' + Capabilities.avHardwareDisable, 'hasAccessibility: ' + Capabilities.hasAccessibility, 'hasAudio: ' + Capabilities.hasAudio, 'hasAudioEncoder: ' + Capabilities.hasAudioEncoder, 'hasEmbeddedVideo: ' + Capabilities.hasEmbeddedVideo, 'hasIME: ' + Capabilities.hasIME, 'hasMP3: ' + Capabilities.hasMP3, 'hasPrinting: ' + Capabilities.hasPrinting, 'hasScreenBroadcast: ' + Capabilities.hasScreenBroadcast, 'hasScreenPlayback: ' + Capabilities.hasScreenPlayback, 'hasStreamingAudio: ' + Capabilities.hasStreamingAudio, 'hasStreamingVideo: ' + Capabilities.hasStreamingVideo, 'hasTLS: ' + Capabilities.hasTLS, 'hasVideoEncoder: ' + Capabilities.hasVideoEncoder, 'isDebugger: ' + Capabilities.isDebugger, 'isEmbeddedInAcrobat: ' + Capabilities.isEmbeddedInAcrobat, 'language: ' + Capabilities.language, 'localFileReadDisable: ' + Capabilities.localFileReadDisable, 'manufacturer: ' + Capabilities.manufacturer, 'maxLevelIDC: ' + Capabilities.maxLevelIDC, 'os: ' + Capabilities.os, 'pixelAspectRatio: ' + Capabilities.pixelAspectRatio, 'playerType: ' + Capabilities.playerType, 'screenColor: ' + Capabilities.screenColor, 'screenDPI: ' + Capabilities.screenDPI, 'screenResolutionX: ' + Capabilities.screenResolutionX, 'screenResolutionY: ' + Capabilities.screenResolutionY, 'serverString: ' + Capabilities.serverString, 'version: ' + Capabilities.version);		}		////////////////////////////////////////////////////////////////////////////////		// PRIVATE		private static function __update():void {			var a:Array     = __output[__levels[__index]];			__txt.text = __getHeader();			for(var i:String in a)				__txt.appendText(a[i]);			__txt.scrollV = 0;		}		private static function __getHeader():String {			return __levels[__index] + '\n=======================================================================\n\n';		}		private static function _onKeyDown($e:KeyboardEvent):void {			if($e.shiftKey && $e.ctrlKey && $e.keyCode == 48)				__panel.visible = !__panel.visible; // CMD/CTRL + SHIFT + 0			if(!__panel.visible)				return;			switch($e.keyCode) {				case 38: // up					$e.shiftKey ? __txt.scrollV = 0 : __txt.scrollV--;					break;				case 40: // down					__txt.scrollV = $e.shiftKey ? __txt.maxScrollV : __txt.scrollV + 1;					break;				case 37: // left					__index ? __index-- : __index = __levels.length - 1;					__update();					break;				case 39: // right					__index < __levels.length - 1 ? __index++ : __index = 0;					__update();					break;			}		}		private static function __copyCurrent($e:ContextMenuEvent):void {			System.setClipboard(__getText());		}		private static function __copyAll($e:ContextMenuEvent):void {			System.setClipboard(__getText(true));		}		private static function __download($e:ContextMenuEvent):void {			__save(__getText(true));		}		private static function __onContextMenuLevelSelect($e:ContextMenuEvent):void {			for(var i:String in __levels) {				if(__levels[i] == $e.target.caption) {					__index = Number(i);					__update();				}			}		}		private static function __getText($all:Boolean = false):String {			var txt:String = '';			if($all) {				var a:Array = __output[ALL_LEVELS];				for(var j:String in a)					txt += a[j];			} else {				txt = __txt.text;			}			return txt;		}		private static function __save($txt:String):void {			var file:FileReference = new FileReference();			file.save($txt, 'log.txt');		}		////////////////////////////////////////////////////////////////////////////////		// PUBLIC		public static function output($level:String, ... $args):void {			// add level to levels array if it doesn't exist and create new array in the output dictionary			if(!__output.hasOwnProperty($level)) {				__levels.push($level);				__output[$level] = new Array();				// context menu item				var m:ContextMenuItem = new ContextMenuItem($level);				m.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, __onContextMenuLevelSelect);				if(__levels.length == 1) {					m.separatorBefore = true;					__txt.appendText(__getHeader());				}				__menu.customItems.push(m);			}			if(!$args.length)				return;			var output:String = '';			for(var i:String in $args)				output += $args[i].toString() + '\n';			__output[$level].push(output);			if($level != ALL_LEVELS)				__output[ALL_LEVELS].push(output);			// if the current level matches this level, update the text field			if(__levels[__index] == $level || __index == 0)				__txt.appendText(output);		}		public static function set stage($stage:Stage):void {			__stage = $stage;			__init();		}	}}