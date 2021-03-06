//
//  ES1Renderer.h
//  Box2DPractice
//
//  Created by Toru Hisai on 10/09/19.
//  Copyright 2010 Kronecker's Delta Studio. All rights reserved.
//

#import "ESRenderer.h"

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "GLTexture.h"
#import <Box2D/Box2D.h>

#import "GLTextureAdapter.h"

extern "C" {
#import "lua.h"
}

@interface ES1Renderer : NSObject <ESRenderer>
{
@private
    EAGLContext *context;

    // The pixel dimensions of the CAEAGLLayer
    GLint backingWidth;
    GLint backingHeight;

    // The OpenGL ES names for the framebuffer and renderbuffer used to render to this view
    GLuint defaultFramebuffer, colorRenderbuffer;
    
    // texutures
    GLTextureAdapter *tex1;
    
        // Box2D
    b2World *world;
    b2Body *body;
    
        // Lua
    lua_State *luastat;
}

- (void)render;
- (void)stepTime:(float)time gravityX:(double)x gravityY:(double)y;
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;
- (void)touch:(CGPoint)touch;
- (void)swipeRight;
- (void)swipeLeft;

@end
