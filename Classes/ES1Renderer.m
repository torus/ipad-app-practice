//
//  ES1Renderer.m
//  Box2DPractice
//
//  Created by Toru Hisai on 10/09/19.
//  Copyright 2010 Kronecker's Delta Studio. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "ES1Renderer.h"

@implementation ES1Renderer

// Create an OpenGL ES 1.1 context
- (id)init
{
    if ((self = [super init]))
    {
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];

        if (!context || ![EAGLContext setCurrentContext:context])
        {
            [self release];
            return nil;
        }

        // Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
        glGenFramebuffersOES(1, &defaultFramebuffer);
        glGenRenderbuffersOES(1, &colorRenderbuffer);
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);

            // load texture
        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity();
            // Disable Depth
        glDisable(GL_DEPTH_TEST);
        
            // Load textures
        glEnable(GL_TEXTURE_2D);
        glEnable(GL_BLEND);
        glBlendFunc(GL_ONE, GL_SRC_COLOR);
        
        glGenTextures(1, texture);

    	NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"goya.jpg"];
        NSLog(@"Texture path: %@", fullpath);
        
//        UIImage *img = [UIImage imageWithContentsOfFile:fullpath];
//        NSLog(@"Image: %x", img);
//
//        CGImageRef cgimage = img.CGImage;
//        
//        float width = CGImageGetWidth(cgimage);
//        float height = CGImageGetHeight(cgimage);
//        NSLog(@"width: %f, height: %f", width, height);
//        CGRect bounds = CGRectMake(0, 0, width, height);
//        CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
//        
//        void *image = malloc(width * height * 4);
//        CGContextRef imgContext = CGBitmapContextCreate(image,
//                                                        width, height,
//                                                        8, 4 * width, colourSpace,
//                                                        kCGImageAlphaPremultipliedLast);
//    
//        CGColorSpaceRelease(colourSpace);
//        CGContextClearRect(imgContext, bounds);
//        CGContextTranslateCTM (imgContext, 0, height);
//        CGContextScaleCTM (imgContext, 1.0, -1.0);
//        CGContextDrawImage(imgContext, bounds, cgimage);
//        
//        CGContextRelease(imgContext);
//        
//        glBindTexture(GL_TEXTURE_2D, texture[0]);
//        
//        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); 
//        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
//        
//        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, image);
//        
//        GLenum err = glGetError();
//        if (err != GL_NO_ERROR)
//            NSLog(@"Error. glError: 0x%04X\n", err);
        
//        free(image);
//        [img release];
        
        UIImage *loadImage = [UIImage imageWithContentsOfFile:fullpath];
        NSLog(@"Image: %x", loadImage);
        tex1 = [[GLTexture alloc] initWithImage: loadImage];
        
            //        NSLog(@"Tex: %x", tex1);
    }

    return self;
}

- (void)render
{
    // Replace the implementation of this method to do your own custom drawing

    static const GLfloat squareVertices[] = {
        -0.5f,  -0.33f,
         0.5f,  -0.33f,
        -0.5f,   0.33f,
         0.5f,   0.33f,
    };

    static const GLubyte squareColors[] = {
        255, 255,   0, 255,
        0,   255, 255, 255,
        0,     0,   0,   0,
        255,   0, 255, 255,
    };

    static float transY = 0.0f;

    // This application only creates a single context which is already set current at this point.
    // This call is redundant, but needed if dealing with multiple contexts.
    [EAGLContext setCurrentContext:context];

    // This application only creates a single default framebuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple framebuffers.
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glTranslatef(0.0f, (GLfloat)(sinf(transY)/2.0f), 0.0f);
    transY += 0.075f;

    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);

//    glVertexPointer(2, GL_FLOAT, 0, squareVertices);
//    glEnableClientState(GL_VERTEX_ARRAY);
//    glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
//    glEnableClientState(GL_COLOR_ARRAY);

        //    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

        // Textures
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);

    [tex1 drawAtPoint:CGPointMake(0, 0) withRotation: 0 withScale: 0.005];
//    glBindTexture(GL_TEXTURE_2D, texture[0]);
//    NSLog(@"tex: %d", texture[0]);

        //glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
//    static const float textureVertices[] = {
//        -0.5f, -0.33f,
//        0.5f, -0.33f,
//        -0.5f,  0.33f,
//        0.5f,  0.33f,   
//    };
//
//    static const float textureCoords[] = {
//        0.0f, 0.0f,
//        0.0f, 0.515625f,
//        0.12890625f, 0.0f,
//        0.12890625f, 0.515625f,
//    };
//
//    glVertexPointer(2, GL_FLOAT, 0, textureVertices);
//    glTexCoordPointer(2, GL_FLOAT, 0, textureCoords);
//    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
//
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    // This application only creates a single color renderbuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple renderbuffers.
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer
{	
    // Allocate color buffer backing based on the current layer size
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);

    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
    {
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }

    return YES;
}

- (void)dealloc
{
    // Tear down GL
    if (defaultFramebuffer)
    {
        glDeleteFramebuffersOES(1, &defaultFramebuffer);
        defaultFramebuffer = 0;
    }

    if (colorRenderbuffer)
    {
        glDeleteRenderbuffersOES(1, &colorRenderbuffer);
        colorRenderbuffer = 0;
    }

    // Tear down context
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];

    [context release];
    context = nil;

    [super dealloc];
}

@end
