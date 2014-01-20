//
//  UIViewController+RuntimeLanguage.m
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

#import "UIViewController+RuntimeLanguage.h"

#import <objc/runtime.h>

#import "NSBundle+RuntimeLanguage.h"

NSString * const kStoryboardIDKey = @"StoryboardIDKey";

@implementation UIViewController (RuntimeLanguage)

- (NSString *)storyboardID
{
    return objc_getAssociatedObject(self, &kStoryboardIDKey);
}

- (void)setStoryboardID:(NSString *)storyboardID
{
    objc_setAssociatedObject(self, &kStoryboardIDKey, storyboardID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)changeRuntimeLanguage:(NSString *)language reloadViewController:(BOOL)reload
{
    [NSBundle setLanguage:language];

    if ( reload )
    {
        [self reloadViewController];
    }
}

- (void)resetRuntimeLanguage:(BOOL)reload
{
    [NSBundle setLanguage:nil];
    
    if ( reload )
    {
        [self reloadViewController];
    }
}

- (void)reloadViewController
{
    UIViewController *newVC = [self.storyboard instantiateViewControllerWithIdentifier:self.storyboardID];
    newVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:newVC animated:YES completion:nil];
}

@end
