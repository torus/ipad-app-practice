/*
 *  GLTexureAdapter.h
 *  Box2DPractice
 *
 *  Created by Toru Hisai on 10/09/26.
 *  Copyright 2010 Kronecker's Delta Studio. All rights reserved.
 *
 */

    // This header file must be pure C++ for SWIG

class GLTextureAdapter {
    void *entity;
public:
    GLTextureAdapter(const char* filename);
    ~GLTextureAdapter();
    void draw(double x, double y, double rot, double scale);
    void drawInRect(double x, double y, double rot, double off_x, double off_y, double width, double height);
};
