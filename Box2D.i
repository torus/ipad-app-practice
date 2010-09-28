%module b2

%{
#include <Box2D/Box2D.h>
%}

%include <Box2D/Common/b2Settings.h>

%include <Box2D/Collision/Shapes/b2CircleShape.h>
%include <Box2D/Collision/Shapes/b2PolygonShape.h>

%include <Box2D/Collision/b2BroadPhase.h>
%include <Box2D/Collision/b2Distance.h>
%include <Box2D/Collision/b2DynamicTree.h>
%include <Box2D/Collision/b2TimeOfImpact.h>

%include <Box2D/Dynamics/b2Body.h>
%include <Box2D/Dynamics/b2Fixture.h>
%include <Box2D/Dynamics/b2WorldCallbacks.h>
%include <Box2D/Dynamics/b2TimeStep.h>
%include <Box2D/Dynamics/b2World.h>

%include <Box2D/Dynamics/Contacts/b2Contact.h>

%include <Box2D/Dynamics/Joints/b2DistanceJoint.h>
%include <Box2D/Dynamics/Joints/b2FrictionJoint.h>
%include <Box2D/Dynamics/Joints/b2GearJoint.h>
%include <Box2D/Dynamics/Joints/b2LineJoint.h>
%include <Box2D/Dynamics/Joints/b2MouseJoint.h>
%include <Box2D/Dynamics/Joints/b2PrismaticJoint.h>
%include <Box2D/Dynamics/Joints/b2PulleyJoint.h>
%include <Box2D/Dynamics/Joints/b2RevoluteJoint.h>
%include <Box2D/Dynamics/Joints/b2WeldJoint.h>
