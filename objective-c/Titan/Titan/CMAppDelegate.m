//
//  CMAppDelegate.m
//  Titan
//
//  Created by Chyld Medford on 7/19/13.
//  Copyright (c) 2013 Chyld Medford. All rights reserved.
//

#import "CMAppDelegate.h"

@implementation CMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  self.task = [[NSTask alloc] init];
  [self.task setLaunchPath:@"/Users/chyld/Documents/chyldstudios/titan/ruby/titan.rb"];

  NSPipe *opipe = [[NSPipe alloc] init];
  NSPipe *ipipe = [[NSPipe alloc] init];

  self.task.standardOutput = opipe;
  self.task.standardInput = ipipe;

  NSFileHandle *ofile = opipe.fileHandleForReading;

  [ofile waitForDataInBackgroundAndNotify];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fromRuby:) name:NSFileHandleDataAvailableNotification object:ofile];

  [self.task launch];
}

- (void)fromRuby:(NSNotification *)aNotification
{
  NSFileHandle *fh = [aNotification object];
  NSData *data = [fh availableData];
  NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
  NSLog(@"%@",str);

  if([str length] > 4)
  {
    unichar x = [str characterAtIndex:4];

    if(x == 76)
    {
      NSLog(@"you typed an L");
      NSMutableArray *array = [[str componentsSeparatedByString:@"\n"] mutableCopy];
      [array removeObjectAtIndex:0];
      [array removeLastObject];

      for (NSString * s in array) {
        NSLog(@"----> %@", s);
      }



      int z = 3;
    }
    
  }







  [fh waitForDataInBackgroundAndNotify];
}

- (IBAction)getBuckets:(id)sender
{
  NSPipe *pipe = self.task.standardInput;
  NSFileHandle *file =  pipe.fileHandleForWriting;

  NSString* str = @"l\n";
  NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];

  [file writeData:data];
}
@end
