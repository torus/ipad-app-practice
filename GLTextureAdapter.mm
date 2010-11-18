/*
 *  GLTextureAdapter.mm
 *  Box2DPractice
 *
 *  Created by Toru Hisai on 10/09/26.
 *  Copyright 2010 Kronecker's Delta Studio. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "GLTexture.h"
#import "GLTextureAdapter.h"

GLTextureAdapter::GLTextureAdapter(const char* filename)
{
    NSString *fullpath = [[[NSBundle mainBundle] bundlePath]
                          stringByAppendingPathComponent:[NSString stringWithCString:filename encoding:NSUTF8StringEncoding]];
    NSLog(@"Texture path: %@", fullpath);
    
    UIImage *loadImage = [UIImage imageWithContentsOfFile:fullpath];
    NSLog(@"Image: %x", loadImage);
    
    entity = [[GLTexture alloc] initWithImage:loadImage];
}

GLTextureAdapter::~GLTextureAdapter()
{
    [(GLTexture*)entity dealloc];
}

void
GLTextureAdapter::draw(double x, double y, double rot, double scale)
{
    [(GLTexture*)entity drawAtPoint:CGPointMake(x, y) withRotation:rot withScale:scale];
}

void
GLTextureAdapter::drawInRect(double x, double y, double rot, double off_x, double off_y, double width, double height)
{
    [(GLTexture*)entity drawInRect:CGRectMake(x, y, width, height)
                        withClip:CGRectMake(off_x, off_y, width, height)
                        withRotation:rot];
}
