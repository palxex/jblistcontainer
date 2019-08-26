
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#include <string.h>

void listapps();

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if( argc < 2 ) {
            NSLog(@"Please provide a bundle id, or use -l for list all of installed apps!");
            return -1;
        }
        if( strncmp(argv[1],"-l",sizeof("-l")) == 0 ) {
            listapps();
            return 0;
        }
        NSString *bundleID = [NSString stringWithUTF8String:argv[1]];
        Class LSApplicationProxy_class = objc_getClass("LSApplicationProxy");
        if( LSApplicationProxy_class == nil ){
            NSLog(@"No LSApplicationProxy class found, check whether MobileCoreServices linked!");
            return -1;
        }
        NSObject* app = [LSApplicationProxy_class performSelector:@selector(applicationProxyForIdentifier:) withObject:bundleID];
        if( app == nil ){
            NSLog(@"No bundle %@ found, please provide a valid bundle id that installed!",bundleID);
            return -1;
        }
        NSURL *documentURL = [app performSelector:@selector(containerURL)];
        printf("%s\n",[documentURL.path UTF8String]);
        if( argc > 2 && strncmp(argv[2],"-u",sizeof("-u")) == 0 ) {
            NSURL *containerURL = [app performSelector:@selector(bundleURL)];
            printf("%s\n",[containerURL.path UTF8String]);
        }
    }
    return 0;
}

void listapps() {
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    Class LSApplicationProxy_class = objc_getClass("LSApplicationProxy");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    NSArray *apps = [workspace performSelector:@selector(allApplications)];
    NSMutableArray *array = [NSMutableArray new];
    for(NSObject *app in apps) {
        printf("app id:%s,name:%s\n",[[app performSelector:@selector(applicationIdentifier)] UTF8String],[[app performSelector:@selector(localizedName)] UTF8String]);
    }
}
