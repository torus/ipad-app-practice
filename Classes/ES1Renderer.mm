//
//  ES1Renderer.m
//  Box2DPractice
//
//  Created by Toru Hisai on 10/09/19.
//  Copyright 2010 Kronecker's Delta Studio. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "ES1Renderer.h"

extern "C" {
#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"
int luaopen_gltexture(lua_State* L); // declare the wrapped module
int luaopen_gl(lua_State* L); // declare the wrapped module
int luaopen_b2(lua_State* L); // declare the wrapped module
}

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

        luastat = lua_open();
        luaopen_base(luastat);
        luaopen_gltexture(luastat);
        luaopen_gl(luastat);
        luaopen_b2(luastat);

        NSString *fullpath = [[[NSBundle mainBundle] bundlePath]
                              stringByAppendingPathComponent:@"goya.lua"];
        NSLog(@"script path: %@", fullpath);
        
        int fileresult = luaL_dofile(luastat, [fullpath cStringUsingEncoding:NSUTF8StringEncoding]);

        if (fileresult) {
            const char *err = lua_tostring(luastat, lua_gettop(luastat));
            NSLog(@"Lua Error: %s\n", err);
        }

        int result = luaL_dostring(luastat, "init()");
        
        if (result) {
            const char *err = lua_tostring(luastat, lua_gettop(luastat));
            NSLog(@"Lua Error: %s\n", err);
        }
    }

    return self;
}

- (void)render
{
    // This application only creates a single context which is already set current at this point.
    // This call is redundant, but needed if dealing with multiple contexts.
    [EAGLContext setCurrentContext:context];

    // This application only creates a single default framebuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple framebuffers.
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);

    int result = luaL_dostring(luastat, "draw()");
    
    if (result) {
        const char *err = lua_tostring(luastat, lua_gettop(luastat));
        NSLog(@"Lua Error: %s\n", err);
    }
    
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
