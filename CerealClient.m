/*
  CerealClient.m
  Automatizing mechanisms for Dragon Dictation
  
  Created by Árpád Goretity on 16/12/2011.
  Released under a CreativeCommons Attribution 3.0 Unported License
*/

#import <Foundation/Foundation.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#import <UIKit/UIKit.h>
#import <substrate.h>
#import <libactivator/libactivator.h>

#define initializer __attribute__((constructor)) extern


@interface CerealClient: NSObject <LAListener> {
	CPDistributedMessagingCenter *center;
}

@end

@implementation CerealClient

- (id) init {
	self = [super init];
	center = [CPDistributedMessagingCenter centerNamed:@"org.h2co3.cerealserver"];
	return self;
}

- (void) activator:(LAActivator *)sender receiveEvent:(LAEvent *)event {
	/* noop(); */
}

- (void) activator:(LAActivator *)sender abortEvent:(LAEvent *)event {
	/* noop(); */
}

@end


@interface CerealClientRecord: CerealClient
@end

@implementation CerealClientRecord

- (void) activator:(LAActivator *)sender receiveEvent:(LAEvent *)event {
	[center sendMessageName:@"org.h2co3.cerealserver.record" userInfo:NULL];
}

@end


@interface CerealClientTwitter: CerealClient
@end

@implementation CerealClientTwitter

- (void) activator:(LAActivator *)sender receiveEvent:(LAEvent *)event {
	[center sendMessageName:@"org.h2co3.cerealserver.twitter" userInfo:NULL];
}

@end


@interface CerealClientFacebook: CerealClient
@end

@implementation CerealClientFacebook

- (void) activator:(LAActivator *)sender receiveEvent:(LAEvent *)event {
	[center sendMessageName:@"org.h2co3.cerealserver.facebook" userInfo:NULL];
}

@end


@interface CerealClientSMS: CerealClient
@end

@implementation CerealClientSMS

- (void) activator:(LAActivator *)sender receiveEvent:(LAEvent *)event {
	[center sendMessageName:@"org.h2co3.cerealserver.sms" userInfo:NULL];
}

@end


@interface CerealClientPasteboard: CerealClient
@end

@implementation CerealClientPasteboard

- (void) activator:(LAActivator *)sender receiveEvent:(LAEvent *)event {
	[center sendMessageName:@"org.h2co3.cerealserver.copy" userInfo:NULL];
}

@end


initializer void init() {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	CerealClientRecord *recordClient = [[CerealClientRecord alloc] init];
	CerealClientTwitter *twitterClient = [[CerealClientTwitter alloc] init];
	CerealClientFacebook *facebookClient = [[CerealClientFacebook alloc] init];
	CerealClientSMS *smsClient = [[CerealClientSMS alloc] init];
	CerealClientPasteboard *pasteboardClient = [[CerealClientPasteboard alloc] init];
	[[LAActivator sharedInstance] registerListener:recordClient forName:@"org.h2co3.cereal.record"];
	[[LAActivator sharedInstance] registerListener:twitterClient forName:@"org.h2co3.cereal.twitter"];
	[[LAActivator sharedInstance] registerListener:facebookClient forName:@"org.h2co3.cereal.facebook"];
	[[LAActivator sharedInstance] registerListener:smsClient forName:@"org.h2co3.cereal.sms"];
	[[LAActivator sharedInstance] registerListener:pasteboardClient forName:@"org.h2co3.cereal.pasteboard"];
	[pool release];
}

