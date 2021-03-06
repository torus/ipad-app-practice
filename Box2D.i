%module b2

%{
#include <Box2D/Box2D.h>
%}

%include <Box2D/Common/b2Settings.h>

%include <Box2D/Common/b2Math.h>

%include <Box2D/Collision/Shapes/b2Shape.h>
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

%include <Box2D/Dynamics/Joints/b2Joint.h>
%include <Box2D/Dynamics/Joints/b2DistanceJoint.h>
%include <Box2D/Dynamics/Joints/b2FrictionJoint.h>
%include <Box2D/Dynamics/Joints/b2GearJoint.h>
%include <Box2D/Dynamics/Joints/b2LineJoint.h>
%include <Box2D/Dynamics/Joints/b2MouseJoint.h>
%include <Box2D/Dynamics/Joints/b2PrismaticJoint.h>
%include <Box2D/Dynamics/Joints/b2PulleyJoint.h>
%include <Box2D/Dynamics/Joints/b2RevoluteJoint.h>
%include <Box2D/Dynamics/Joints/b2WeldJoint.h>


///////////////////////////////////////////////////////////

/* %include <Box2D/Box2D.h> */
/* %include <Box2D/Common/b2Settings.h> */

/* %include <Box2D/Common/b2BlockAllocator.h> */
/* %include <Box2D/Common/b2Math.h> */
/* %include <Box2D/Common/b2StackAllocator.h> */

/* %include <Box2D/Collision/b2BroadPhase.h> */
/* %include <Box2D/Collision/b2Collision.h> */
/* %include <Box2D/Collision/b2Distance.h> */
/* %include <Box2D/Collision/b2DynamicTree.h> */
/* %include <Box2D/Collision/b2TimeOfImpact.h> */
/* %include <Box2D/Collision/Shapes/b2CircleShape.h> */
/* %include <Box2D/Collision/Shapes/b2PolygonShape.h> */
/* %include <Box2D/Collision/Shapes/b2Shape.h> */

/* %include <Box2D/Dynamics/b2Body.h> */
/* %include <Box2D/Dynamics/b2ContactManager.h> */
/* %include <Box2D/Dynamics/b2Fixture.h> */
/* %include <Box2D/Dynamics/b2Island.h> */
/* %include <Box2D/Dynamics/b2TimeStep.h> */
/* %include <Box2D/Dynamics/b2World.h> */
/* %include <Box2D/Dynamics/b2WorldCallbacks.h> */
/* %include <Box2D/Dynamics/Contacts/b2CircleContact.h> */
/* %include <Box2D/Dynamics/Contacts/b2Contact.h> */
/* %include <Box2D/Dynamics/Contacts/b2ContactSolver.h> */
/* %include <Box2D/Dynamics/Contacts/b2PolygonAndCircleContact.h> */
/* %include <Box2D/Dynamics/Contacts/b2PolygonContact.h> */
/* %include <Box2D/Dynamics/Contacts/b2TOISolver.h> */
/* %include <Box2D/Dynamics/Joints/b2DistanceJoint.h> */
/* %include <Box2D/Dynamics/Joints/b2FrictionJoint.h> */
/* %include <Box2D/Dynamics/Joints/b2GearJoint.h> */
/* %include <Box2D/Dynamics/Joints/b2Joint.h> */
/* %include <Box2D/Dynamics/Joints/b2LineJoint.h> */
/* %include <Box2D/Dynamics/Joints/b2MouseJoint.h> */
/* %include <Box2D/Dynamics/Joints/b2PrismaticJoint.h> */
/* %include <Box2D/Dynamics/Joints/b2PulleyJoint.h> */
/* %include <Box2D/Dynamics/Joints/b2RevoluteJoint.h> */
/* %include <Box2D/Dynamics/Joints/b2WeldJoint.h> */
