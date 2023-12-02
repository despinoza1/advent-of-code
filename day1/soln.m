#import <Foundation/Foundation.h>
#include <Foundation/NSCharacterSet.h>
#include <Foundation/NSObjCRuntime.h>
#import <objc/Object.h>
#import <objc/runtime.h>
#import <stdio.h>
#include <strings.h>

// TODO: This is slow
int is_match(NSArray *numbers, NSString *substr) {
  NSUInteger j;

  for (j = 0; j < 9; j++) {
    NSString *number = [numbers objectAtIndex:j];

    if (!strncmp([number UTF8String], [substr UTF8String], [number length])) {
      return j + 1;
    }
  }

  return -1;
}

int main(int argc, const char *argv[]) {
  if (argc != 2) {
    printf("Usage: %s <filename>\n", argv[0]);
    return 1;
  }

  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  NSUInteger sum = 0;
  NSCharacterSet *numericSet = [NSCharacterSet decimalDigitCharacterSet];
  NSArray *numbers =
      [NSArray arrayWithObjects:@"one", @"two", @"three", @"four", @"five",
                                @"six", @"seven", @"eight", @"nine", nil];

  NSString *path = [NSString stringWithCString:argv[1]];
  NSStringEncoding encoding = NSASCIIStringEncoding;
  NSError *error;

  NSString *data = [NSString stringWithContentsOfFile:path
                                             encoding:encoding
                                                error:&error];
  NSArray *lines =
      [[data stringByTrimmingTailSpaces] componentsSeparatedByString:@"\n"];

  for (NSString *line in lines) {
    NSLog(@"%@", line);
    NSUInteger left_val = -1;
    NSUInteger right_val = -1;

    int i;
    for (i = 0; i < line.length; i++) {
      unichar ch = [line characterAtIndex:i];

      if ([numericSet characterIsMember:ch]) {
        // printf("%C,", ch);
        if (left_val == -1) {
          // HACK: Use objc idiomatic way instead of:
          left_val = ch - 0x30;
          right_val = ch - 0x30;
        } else {
          right_val = ch - 0x30;
        }
      } else {
        NSString *substr = [line substringFromIndex:i];
        NSUInteger match = is_match(numbers, substr);

        if (match != -1) {
          if (left_val == -1) {
            left_val = match;
            right_val = match;
          } else {
            right_val = match;
          }
        }
      }
    }

    printf("%lu%lu\n", left_val, right_val);
    sum += left_val * 10 + right_val;
  }

  NSLog(@"%lu", sum);

  [pool drain];
  return 0;
}
