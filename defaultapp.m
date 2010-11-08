#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <ApplicationServices/ApplicationServices.h>

@interface NSFileHandle (defaultapp)
- (void)writeString:(NSString *)str;
@end
@implementation NSFileHandle (defaultapp)
- (void)writeString:(NSString *)str {
	NSData *d = [NSData dataWithBytes:[str UTF8String] length:[str lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	[self writeData:d];
}
@end


int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	OSStatus err = noErr;
	NSFileHandle *fh = [NSFileHandle fileHandleWithStandardOutput];
	if (argc == 2) {
		NSString *uri = [NSString stringWithUTF8String:argv[1]];
		if ([uri length] && [uri characterAtIndex:0] == '.') {
			NSURL *appURL = nil;
			NSString *ext = [uri substringFromIndex:1];
			LSGetApplicationForInfo(kLSUnknownType, kLSUnknownCreator, (CFStringRef)ext, kLSRolesAll, nil, (CFURLRef *)&appURL);
			[appURL autorelease];
			[fh writeString:[[appURL description] stringByAppendingString:@"\n"]];
		}
		else
		{
			// A valid URL may be "mailto:" but *not* "mailto".  This attempts to correct that.
			if ([uri rangeOfString:@":"].location == NSNotFound) uri = [uri stringByAppendingString:@":"];
			NSURL *url = [NSURL URLWithString:uri];
			NSURL *appURL = nil;
			err = LSGetApplicationForURL((CFURLRef)url, kLSRolesViewer, nil, (CFURLRef *)&appURL);
			[appURL autorelease];
			[fh writeString:[[appURL description] stringByAppendingString:@"\n"]];
		}
	}
	else if (argc == 3) {
		NSString *uri = [NSString stringWithUTF8String:argv[1]];
		if ([uri length] && [uri characterAtIndex:0] == '.') {
			NSString *ext = [uri substringFromIndex:1];
			
			// Find the bundle identifier for an application
			NSString *appName = [NSString stringWithUTF8String:argv[2]];
			NSString *bundleIdentifier = nil;
			if ([[NSWorkspace sharedWorkspace] respondsToSelector:@selector(URLForApplicationWithBundleIdentifier:)]) 
				bundleIdentifier = [[NSWorkspace sharedWorkspace] performSelector:@selector(URLForApplicationWithBundleIdentifier:) withObject:appName] ? appName : nil;
			if (!bundleIdentifier) {
				NSString *appPath = [[NSWorkspace sharedWorkspace] fullPathForApplication:appName];
				if (!appPath) goto end;
				bundleIdentifier = [[NSBundle bundleWithPath:appPath] bundleIdentifier];
				if (!bundleIdentifier) goto end;
			}
			NSString *uti = (NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (CFStringRef)ext, nil);
			LSSetDefaultRoleHandlerForContentType((CFStringRef)uti, kLSRolesAll, (CFStringRef)bundleIdentifier);
			[uti autorelease];
			end:;
		}
		else {
			NSString *appName = [NSString stringWithUTF8String:argv[2]];
			NSBundle *bundle = [NSBundle bundleWithPath:[[NSWorkspace sharedWorkspace] fullPathForApplication:appName]];
			[fh writeString:[bundle bundleIdentifier]];
			err = LSSetDefaultHandlerForURLScheme((CFStringRef)uri, (CFStringRef)[bundle bundleIdentifier]);
			[fh writeString:@"\nDONE\n"];
		}
	}
	else {
		[fh writeString:
			@"To see what app is the default for an URL scheme, pass the URL scheme to defaultapp "
			@"(defaultapp mailto).  To change the default, pass the URL scheme and the name of the "
			@"application (defaultapp http Safari).\n"];
	}
	if (err != noErr) [fh writeString:[NSString stringWithFormat:@"LaunchServices reported error %d.  See this page for more details:\nhttp://developer.apple.com/mac/library/documentation/Carbon/Reference/LaunchServicesReference/Reference/reference.html#//apple_ref/doc/uid/TP30000998-CH4g-BCIHFFIA\n", err]];
    [pool drain];
    return 0;
}


