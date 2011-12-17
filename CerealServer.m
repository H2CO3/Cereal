/*
  CerealServer.m
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


static UIViewController *viewController = NULL;


@interface CerealServer: NSObject {
	CPDistributedMessagingCenter *center;
}

- (void) handleMessageNamed:(NSString *)name userInfo:(NSDictionary *)userInfo;

@end


@implementation CerealServer

- (id) init {
	self = [super init];
	center = [CPDistributedMessagingCenter centerNamed:@"org.h2co3.cerealserver"];
	[center registerForMessageName:@"org.h2co3.cerealserver.record" target:self selector:@selector(handleMessageNamed:userInfo:)];
	[center registerForMessageName:@"org.h2co3.cerealserver.twitter" target:self selector:@selector(handleMessageNamed:userInfo:)];
	[center registerForMessageName:@"org.h2co3.cerealserver.facebook" target:self selector:@selector(handleMessageNamed:userInfo:)];
	[center runServerOnCurrentThread];
	return self;
}

- (void) handleMessageNamed:(NSString *)name userInfo:(NSDictionary *)userInfo {
	if ([name isEqualToString:@"org.h2co3.cerealserver.record"]) {
		[viewController recordAction];
	} else if ([name isEqualToString:@"org.h2co3.cerealserver.twitter"]) {
		[viewController sendTwitterMessage];
	} else if ([name isEqualToString:@"org.h2co3.cerealserver.facebook"]) {
		[viewController sendFacebookMessage];
	}
}

@end


static IMP _original_$_DetailViewController_$_initWithNibName_bundle_ = NULL;

id _modified_$_DetailViewController_$_initWithNibName_bundle_(id _self, SEL _cmd, NSString *nib, NSBundle *bundle) {
	_self = _original_$_DetailViewController_$_initWithNibName_bundle_(_self, _cmd, nib, bundle);
	viewController = _self;
	return _self;
}


initializer void init() {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	CerealServer *server = [[CerealServer alloc] init];
	MSHookMessageEx(objc_getClass("DetailViewController"), @selector(initWithNibName:bundle:), (IMP)_modified_$_DetailViewController_$_initWithNibName_bundle_, &_original_$_DetailViewController_$_initWithNibName_bundle_);
	[pool release];
}

