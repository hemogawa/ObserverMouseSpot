//
//  main.m
//  ObserveMouseSpot
//
//  Created by 菊川 真理子 on 11/05/23.
//  Copyright 2011 北陸先端科学技術大学院大学. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include<ApplicationServices/ApplicationServices.h>
#define Delta 30

CGEventRef CGMouseEventCallback(CGEventTapProxy proxy,CGEventType type, CGEventRef inEvent, void *refcon){
	NSDictionary *activeApp = [[NSWorkspace sharedWorkspace] activeApplication];
	NSArray *runningApp = [[NSWorkspace sharedWorkspace] runningApplications];
	NSString *activeAppName = [activeApp objectForKey:@"NSApplicationName"];
	NSLog(@"%@",activeAppName);
	if(![activeAppName isEqualToString:@"WindowMouse"]){
		[[NSWorkspace sharedWorkspace] launchApplication:@"/Users/kikugawamariko/XCodeProjects/WindowMouse3/build/Debug/WindowMouse.app"]; 
	}
	return inEvent;
}

int main (int argc, const char * argv[]){
	CFMachPortRef        eventTap;	//CFMachPortオブジェクトへの参照
	CGEventMask          eventMask;	//Quartzイベントを発生させるマスク
	CFRunLoopSourceRef   runLoopSource;	//ループする的ななにか？
	
	/* どのイベントでコールバック関数が起動するか指定 */
	eventMask   = CGEventMaskBit(kCGEventLeftMouseUp);
	/* イベントタップを作る．タップしたら発生するイベント
	 イベント発生箇所:デバイス上か，リモートでログインした先のポイント,
	 イベント挿入箇所?:先頭,
	 新イベントはリスナーかフィルターか:リスナー
	 どのイベントで発生するか(eventMask)・監視するか
	 コールバック関数*/
	eventTap    = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, 
								   kCGEventTapOptionListenOnly, eventMask, CGMouseEventCallback, NULL);
	/* イベントタップを作れなかったらログ表示 */
	if (!eventTap) {
		printf("Hello, World!\n");
	}
	
	/* CFMachPortCreateRunLoopSourceオブジェクトを作成
	 メモリ確保・解放オブジェクト:NULLと同義らしい,
	 オブジェクト作成先,ループの中で0番目？
	 */
	runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
	/*
	 CFRunLoopSourceオブジェクトを追加(上で作成したのをループのに追加?)
	 追加するループ:カレント
	 追加するソース,モード(これしかないっぽ)
	 */
	CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
	
	CGEventTapEnable(eventTap, true);	//イベントタップを可能にする
	CFRunLoopRun();	//ループを実行してるんですかね？
	
	CFRelease(runLoopSource);	//ループソースを解放
	return 0;
}