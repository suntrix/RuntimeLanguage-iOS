//
//  NSBundle+RuntimeLanguage.m
//
//  Created by Sebastian Owodziń on 20/01/14.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "NSBundle+RuntimeLanguage.h"

#import <objc/runtime.h>

NSString * const kRuntimeLanguageBundleKey = @"RuntimeLanguageBundleDKey";

@interface RuntimeLanguageBundle : NSBundle

@end

@implementation RuntimeLanguageBundle

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName
{
    NSBundle *bundle = objc_getAssociatedObject(self, &kRuntimeLanguageBundleKey);
    
    return bundle ? [bundle localizedStringForKey:key value:value table:tableName] : [super localizedStringForKey:key value:value table:tableName];
}
@end

@implementation NSBundle (RuntimeLanguage)

+ (void)setLanguage:(NSString *)language
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        object_setClass([NSBundle mainBundle], [RuntimeLanguageBundle class]);
    });
    
    objc_setAssociatedObject([NSBundle mainBundle], &kRuntimeLanguageBundleKey, language ? [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]] : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
