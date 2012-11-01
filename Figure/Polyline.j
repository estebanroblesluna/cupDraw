/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @author "Esteban Robles Luna <esteban.roblesluna@gmail.com>"
 */
var CachedNotificationCenter    = nil;

@implementation Polyline : Figure 
{ 
	CPMutableArray _points;
} 

- (id) initWithPoints: (CPArray) anArrayOfPoints
{ 
	CachedNotificationCenter = [CPNotificationCenter defaultCenter];
	var frame = [GeometryUtils computeFrameFor: anArrayOfPoints];
	self = [super initWithFrame: frame];

	_points = [CPMutableArray arrayWithArray: anArrayOfPoints];
	for (var i = 0; i < [_points count]; i++) { 
	    var point = [_points objectAtIndex:i];
		
		[handles addObject: [self addNewHandle: i]];
		
		if (i != [_points count] - 1) {
			[handles addObject: [self addCreateHandle: i]];
		}
	}
	
	if (self) {
		return self;
	}
}

- (Handle) addNewHandle: (int) anIndex
{
	var newHandle = [Handle 
		target: self 
		getSelector: @selector(pointAt:) 
		setSelector: @selector(pointAt:put:)
		extraArgument: anIndex];

	return newHandle;
}

- (Handle) addCreateHandle: (int) anIndex
{
	var createHandle = [Handle 
		target: self 
		getSelector: @selector(insertionPointAt:) 
		setSelector: @selector(createPointAt:put:)
		extraArgument: anIndex];
		
	[createHandle displayColor: [CPColor redColor]];
	
	return createHandle;
}

- (bool)isSelectable
{ 
	return true;
}

- (CPPoint) pointAt: (int) anIndex
{
	var point = [_points objectAtIndex: anIndex];
	return point;
}

- (void) pointAt: (int) anIndex put: (CPPoint) aPoint
{
	[_points replaceObjectAtIndex: anIndex withObject: aPoint];
	[self recomputeFrame];
}

- (CPPoint) insertionPointAt: (int)anIndex
{
	var point1 = [_points objectAtIndex: anIndex];
	var point2 = [_points objectAtIndex: (anIndex + 1)];
	
	var x = (point1.x + point2.x) / 2;
	var y = (point1.y + point2.y) / 2;

	return CGPointMake(x,y);
}

- (void) createPointAt: (int)anIndex put: (CPPoint) aPoint
{
	//insert the point in that position
	var insertIndex = anIndex + 1;
	[_points insertObject: aPoint atIndex: insertIndex];
	
	//convert the create handle into a translate handle
	var handleIndex = (anIndex * 2) + 1;
	var handleToConvert = [handles objectAtIndex: handleIndex];
	
	//CPLog.debug([handleToConvert]);
	//CPLog.info(@"createPoint1");
	[handleToConvert displayColor: [CPColor blackColor]]; 
	[handleToConvert getSelector: @selector(pointAt:) setSelector: @selector(pointAt:put:)]; 
	[handleToConvert extraArgument: insertIndex]; 
	//CPLog.info(@"createPoint2");

	var newCreateHandleBefore = [self addCreateHandle: insertIndex - 1];
	var newCreateHandleAfter = [self addCreateHandle: insertIndex];

	[handles insertObject: newCreateHandleAfter atIndex: handleIndex + 1];
	[handles insertObject: newCreateHandleBefore atIndex: handleIndex];

	for (var i = handleIndex; i < [handles count]; i++) { 
	    var handle = [handles objectAtIndex: i];
		var extraArg = FLOOR(i / 2);
		[handle extraArgument: extraArg]; 
	}
	
	var diagram = [self superview];
	
	[diagram addFigure: newCreateHandleBefore];
	[diagram addFigure: newCreateHandleAfter];
	
	[self recomputeFrame];
	//if (CPRectContainsPoint([self frame], aPoint)) {
	//} else {
	//}
	//add 1 create handle before
	//var createHandleBefore = [self addCreateHandle: (insertIndex - 1)];
	
	//add 1 create handle after
	//var createHandleAfter = [self addCreateHandle: insertIndex];
	
	
	//var count = [_points count];
	
	//var newCreateHandle = [self addCreateHandle: (count - 2)];
	//var newNewHandle = [self addNewHandle: (count - 1)];
	
	//[handles addObject: newCreateHandle];
	//[handles addObject: newNewHandle];
	
	//var diagram = [self superview];
	
	//[handles insertObject: newCreateHandle atIndex: (insertIndex * 2)];
	//[handles insertObject: newNewHandle atIndex: (insertIndex * 2)];

	//[diagram addSubview: newCreateHandle];
	//[diagram addSubview: newNewHandle];
	
	/*for (var i = 0; i < [handles count]; i++) { 
		var handle = [handles objectAtIndex: i];
		[handle extraArgument: FLOOR(i/2)];
		[handle updateLocation: nil];
	}*/
	
	
}

- (void)figureAt:(CPPoint) aPoint
{
	for (var i = 0; i < [_points count] - 1; i++) { 
	    var a = [_points objectAtIndex: i];
	    var b = [_points objectAtIndex: (i + 1)];
		if ([GeometryUtils distanceFrom: a and: b to: aPoint] < 5) {
			return self;
		}
	}

	return nil;
}

- (void) recomputeFrame
{
	var newFrame = [GeometryUtils computeFrameFor: _points];
	[self setNeedsDisplay: YES];
	[self setFrame: newFrame];
}

- (void) drawRect:(CGRect) rect on: (id) context
{
	//CGContextSetFillColor(context, [CPColor yellowColor]);
	//CGContextFillRect(context, rect);
	//CPLog.info([_points count]);
	var origin = [self frameOrigin];
    var intialPoint = [_points objectAtIndex:0];
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, intialPoint.x - origin.x, intialPoint.y - origin.y);

	//CPLog.debug([_points count]);
	for (var i = 1; i < [_points count]; i++) { 
	    var point = [_points objectAtIndex:i];
		//CGContextAddLineToPoint(context, point.x, point.y);
		CGContextAddLineToPoint(context, point.x - origin.x, point.y - origin.y);
	}			
	
	//CGContextClosePath(context);
	CGContextSetStrokeColor(context, [self foregroundColor]);
	CGContextSetLineWidth(context, 0.5);
    CGContextStrokePath(context);
}

- (void) translatedBy: (CGPoint) aPoint
{
	var frame = [self frame];
	var xOffset = aPoint.x - frame.origin.x;
	var yOffset = aPoint.y - frame.origin.y;
	for (var i = 0; i < [_points count]; i++) { 
	    var point = [_points objectAtIndex:i];
		point = CGPointMake(point.x + xOffset, point.y + yOffset);
		[_points replaceObjectAtIndex: i withObject: point];
	}
	[super translatedBy: aPoint];
}
@end