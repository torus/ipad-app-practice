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

//            // load texture
//        glMatrixMode(GL_MODELVIEW);
//        glLoadIdentity();
//            // Disable Depth
//        glDisable(GL_DEPTH_TEST);
//        
//            // Load textures
//        glEnable(GL_TEXTURE_2D);
//        glEnable(GL_BLEND);
//        glBlendFunc(GL_ONE, GL_SRC_COLOR);

        
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
//            // Box2D
//        CGSize size = CGSizeMake(10, 10);
//        printf("w: %f, h: %f\n", size.width, size.height);
//        world = new b2World(b2Vec2(0, -10), false);
//        
//        b2BodyDef bodyDef;
//        bodyDef.type = b2_staticBody;
//        bodyDef.position.Set(0, 0);
//        b2Body* edge_body = world->CreateBody(&bodyDef);
//        
//        float wext = size.width / 2;
//        float hext = size.height / 2;
//        b2PolygonShape shapes[4];
//        shapes[0].SetAsBox(wext, 1, b2Vec2(wext, -1), 0);
//        shapes[1].SetAsBox(wext, 1, b2Vec2(wext, size.height + 1), 0);
//        shapes[2].SetAsBox(1, hext, b2Vec2(-1, hext), 0);
//        shapes[3].SetAsBox(1, hext, b2Vec2(size.width + 1, hext), 0);
//        
//        for (int i = 0; i < 4; ++i) {
//            b2FixtureDef fixtureDef;
//            fixtureDef.shape = &shapes[i];
//            edge_body->CreateFixture(&fixtureDef);
//        }
//
//        {
//            b2BodyDef bodyDef;
//            bodyDef.type = b2_dynamicBody;
//            bodyDef.position.Set(5.0f, 9.0f);
//            body = world->CreateBody(&bodyDef);
//            
//            b2PolygonShape dynamicBox;
//            dynamicBox.SetAsBox(1.0f, 1.0f);
//            
//            b2FixtureDef fixtureDef;
//            fixtureDef.shape = &dynamicBox;
//            fixtureDef.density = 1.0f;
//            fixtureDef.friction = 0.3f;
//            
//            body->CreateFixture(&fixtureDef);
//        }
        
        
    }

    return self;
}

- (void)render
{
        // Box2D
//    float32 timeStep = 1.0f / 30.0f;
//    int32 velocityIterations = 6;
//    int32 positionIterations = 2;
//    world->Step(timeStep, velocityIterations, positionIterations);
//    
//    world->ClearForces();
//    b2Vec2 position = body->GetPosition();
//    float32 angle = body->GetAngle();
//    printf("%4.2f %4.2f %4.2f\n", position.x, position.y, angle);

        
        // Replace the implementation of this method to do your own custom drawing

    static float transY = 0.0f;

    // This application only creates a single context which is already set current at this point.
    // This call is redundant, but needed if dealing with multiple contexts.
    [EAGLContext setCurrentContext:context];
        //
    // This application only creates a single default framebuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple framebuffers.
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);

//    glMatrixMode(GL_PROJECTION);
//    glLoadIdentity();
//    glMatrixMode(GL_MODELVIEW);
//    glLoadIdentity();
////    glTranslatef(0.0f, (GLfloat)(sinf(transY)/2.0f), 0.0f);
//    glTranslatef((position.x - 5) / 10.0, (position.y - 5) / 10.0, 0.0f);
//    transY += 0.075f;
//
//    glClearColor(0, 0, 0, 1);
//    glClear(GL_COLOR_BUFFER_BIT);
//
//        // Textures
//    glEnableClientState(GL_VERTEX_ARRAY);
//    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
//
    int result = luaL_dostring(luastat, "draw()");
    
    if (result) {
        const char *err = lua_tostring(luastat, lua_gettop(luastat));
        NSLog(@"Lua Error: %s\n", err);
    }
    
//
//    glDisableClientState(GL_VERTEX_ARRAY);
//    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
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
