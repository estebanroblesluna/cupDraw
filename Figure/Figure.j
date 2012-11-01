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
@implementation Figure : CPView 
{
	CPMutableArray handles;
	CPMutableArray _inConnections;
	CPMutableArray _outConnections;
	
	CPColor _backgroundColor;
	CPColor _foregroundColor;

	boolean _selectable;
	boolean _moveable;
	boolean _editable;
	
	Model _model;
	bool _selected;
}

+ (Figure) frame: (CGRect) aFrame
{
	var figure = [self new];
	[figure initWithFrame: aFrame];
	return figure;
}

+ (Figure) newAt: (CGPoint) aPoint
{
	var frame = CGRectMake(aPoint.x, aPoint.y, 20, 20);
	var figure = [self frame: frame];
	return figure;
}

- (id) init
{ 
	[super init];
	
	handles = [CPMutableArray array];
	_inConnections = [CPMutableArray array];
	_outConnections = [CPMutableArray array];

	_backgroundColor = [CPColor blackColor];
	_foregroundColor = _backgroundColor;

	_selectable = true;
	_moveable = true;
	_editable = true;
		
	_selected = false;
		
	[self setPostsFrameChangedNotifications: YES]; 
	
	return self;
} 

- (id) figureAt: (CPPoint) aPoint
{
	var figureInSubfigures = [self primSubfiguresAt: aPoint];
	if (figureInSubfigures != nil) {
		return figureInSubfigures;
	}

	//otherwise check our frame
	return [self primFigureAt: aPoint];
}

- (id) primSubfiguresAt: (CPPoint) aPoint {
	//check our figures if any of them return a not nil result
	var figures = [self subviews];
	
	//translate the parent global point to my coordinate system
	var origin = [self frameOrigin];
	var translatedPoint = CGPointMake(aPoint.x - origin.x, aPoint.y - origin.y);
	
	//check the sub figures
	for (var i = [figures count] - 1; i >= 0 ; i--) { 
	    var figure = [figures objectAtIndex: i];
		var result;
		if ([figure respondsToSelector: @selector(figureAt:)]) {
			result = [figure figureAt: translatedPoint];
		} else {
			if (CPRectContainsPoint([figure frame], translatedPoint)) {
				result = self;
			} else {
				result = nil;
			}
		}
		if (result != nil) {
			return result;
		}
	}
}

- (id) primFigureAt: (CPPoint) aPoint {
	var frame = [self frame];
	if (CPRectContainsPoint(frame, aPoint)) {
		return self;
	} else {
		return nil;
	}
}

- (void) globalToLocal: (CPPoint) aPoint
{
	var current = self;
	var offset = CGPointMake(0, 0);
	while (current != nil && ![current isKindOfClass:[Drawing class]]) {
		var frameOrigin = [current frameOrigin];
		offset = CGPointMake(offset.x - frameOrigin.x, offset.y - frameOrigin.y);
		current = [current superview];
	}
	
	var result = CGPointMake(aPoint.x + offset.x, aPoint.y + offset.y);
	return result;
}

- (void) addInConnection: (id) aConnection
{
	[_inConnections addObject: aConnection];
}

- (void) addOutConnection: (id) aConnection
{
	[_outConnections addObject: aConnection];
}

- (void) moveTo: (CGPoint) aPoint
{
	if (_moveable) {
		[self setFrameOrigin: aPoint];
	}
}

- (void) translateBy: (CGPoint) aPoint
{
	if (_moveable) {
		var frameOrigin = [self frameOrigin];
		var newFrameOrigin = CGPointMake(frameOrigin.x + aPoint.x, frameOrigin.y + aPoint.y);
		[self setFrameOrigin: newFrameOrigin];
	}
}

- (id) handleAt: (int) anIndex
{
	return [handles objectAtIndex: anIndex];
}

- (CPColor) borderColor
{ 
	return [CPColor blackColor];
}

- (CPColor) handleColor
{ 
	return [self borderColor];
}

- (bool) isSelectable
{ 
	return _selectable;
}

- (bool) isMoveable
{ 
	return _moveable;
}

- (bool) isEditable
{ 
	return _editable;
}

- (void) selectable: (boolean) aValue
{
	_selectable = aValue;
}

- (void) moveable: (boolean) aValue
{
	_moveable = aValue;
}

- (void) editable: (boolean) aValue
{
	_editable = aValue;
}

- (bool) isHandle
{ 
	return false;
}

- (void) invalidate
{
	[self setNeedsDisplay: YES];
}

- (void) switchToEditMode
{
}

- (void) update
{
}

- (void) select
{ 
	//CPLog.info(@"select");
	_selected = true;
	var container = [self superview];
	for (var i = 0; i < [handles count]; i++) { 
	    var handle = [handles objectAtIndex:i];
		//CPLog.info(handle);
		[container addFigure: handle];
		//CPLog.info(handle);
	}
}

- (void) unselect
{ 
	_selected = false;
	for (var i = 0; i < [handles count]; i++) { 
	    var handle = [handles objectAtIndex:i];
		[handle removeFromSuperview];
	}
}

- (Drawing) drawing
{ 
	return [[self superview] drawing];
}

- (CPArray) handles
{ 
	return handles;
}

- (void)drawRect:(CGRect)rect 
{ 
    var context = [[CPGraphicsContext currentContext] graphicsPort];
	[self drawRect: rect on: context];
}

- (void)drawRect:(CGRect)rect on: (id)context
{ 
}

- (CPPoint)topLeft
{
	return CGPointMake([self frame].origin.x, [self frame].origin.y);
}

- (void)topLeft: aPoint
{ 
	var oldFrame = [self frame];
	var widthOffset = oldFrame.origin.x - aPoint.x;
	var heightOffset = oldFrame.origin.y - aPoint.y;
	var newFrame = CGRectMake(aPoint.x, aPoint.y, oldFrame.size.width + widthOffset, oldFrame.size.height + heightOffset);
	[self setFrame: newFrame];
}

- (CPPoint)topMiddle
{ 
	return CGPointMake([self frame].origin.x + ([self frame].size.width / 2), [self frame].origin.y);
}

- (void)topMiddle: aPoint
{ 
	var oldFrame = [self frame];
	var widthOffset = 0;
	var heightOffset = aPoint.y - oldFrame.origin.y;
	var newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y + heightOffset, oldFrame.size.width + widthOffset, oldFrame.size.height - heightOffset);
	[self setFrame: newFrame];
}

- (CPPoint)topRight
{ 
	return CGPointMake([self frame].origin.x + [self frame].size.width, [self frame].origin.y);
}

- (void)topRight: aPoint
{ 
	var oldFrame = [self frame];
	var widthOffset = aPoint.x - (oldFrame.origin.x + oldFrame.size.width);
	var heightOffset = aPoint.y - oldFrame.origin.y;
	var newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y + heightOffset, oldFrame.size.width + widthOffset, oldFrame.size.height - heightOffset);
	[self setFrame: newFrame];
}

- (CPPoint)middleLeft
{ 
	return CGPointMake([self frame].origin.x, [self frame].origin.y + ([self frame].size.height / 2));
}

- (void)middleLeft: aPoint
{ 
	var oldFrame = [self frame];
	var widthOffset = oldFrame.origin.x - aPoint.x;
	var heightOffset = 0;
	var newFrame = CGRectMake(aPoint.x, oldFrame.origin.y, oldFrame.size.width + widthOffset, oldFrame.size.height + heightOffset);
	[self setFrame: newFrame];
}

- (CPPoint)middleRight
{ 
	return CGPointMake([self frame].origin.x + [self frame].size.width, [self frame].origin.y + ([self frame].size.height / 2));
}

- (void)middleRight: aPoint
{ 
	var oldFrame = [self frame];
	var widthOffset = aPoint.x - (oldFrame.origin.x + oldFrame.size.width);
	var heightOffset = 0;
	var newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width + widthOffset, oldFrame.size.height + heightOffset);
	[self setFrame: newFrame];
}

- (CPPoint)bottomLeft
{ 
	return CGPointMake([self frame].origin.x, [self frame].origin.y + [self frame].size.height);
}

- (void)bottomLeft: aPoint
{ 
	var oldFrame = [self frame];
	var widthOffset = oldFrame.origin.x - aPoint.x;
	var heightOffset = aPoint.y - (oldFrame.origin.y + oldFrame.size.height);
	var newFrame = CGRectMake(aPoint.x, oldFrame.origin.y, oldFrame.size.width + widthOffset, oldFrame.size.height + heightOffset);
	[self setFrame: newFrame];
}

- (CPPoint)bottomMiddle
{ 
	return CGPointMake([self frame].origin.x + ([self frame].size.width / 2), [self frame].origin.y + [self frame].size.height);
}

- (void)bottomMiddle: aPoint
{ 
	var oldFrame = [self frame];
	var widthOffset = 0;
	var heightOffset = aPoint.y - (oldFrame.origin.y + oldFrame.size.height);
	var newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width + widthOffset, oldFrame.size.height + heightOffset);
	[self setFrame: newFrame];
}

- (CPPoint) bottomRight
{ 
	return CGPointMake([self frame].origin.x + [self frame].size.width, [self frame].origin.y + [self frame].size.height);
}

- (void) bottomRight: aPoint
{ 
	var oldFrame = [self frame];
	var widthOffset = aPoint.x - (oldFrame.origin.x + oldFrame.size.width);
	var heightOffset = aPoint.y - (oldFrame.origin.y + oldFrame.size.height);
	var newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width + widthOffset, oldFrame.size.height + heightOffset);
	[self setFrame: newFrame];
}

- (id) backgroundColor
{
	return _backgroundColor;
}

- (void) backgroundColor: (CPColor) aColor
{
	_backgroundColor = aColor;
}

- (id) foregroundColor
{
	return _foregroundColor;
}

- (void) foregroundColor: (CPColor) aColor
{
	_foregroundColor = aColor;
}

- (id) model
{
	return _model;
}

- (void) model: aModel
{
	if (_model != nil) {
		[[CPNotificationCenter defaultCenter] 
			removeObserver: self 
			name: ModelPropertyChangedNotification 
			object: _model];
		
	}

	_model = aModel;

	if (_model != nil) {
		[[CPNotificationCenter defaultCenter] 
			addObserver: self 
			selector: @selector(modelChanged) 
			name: ModelPropertyChangedNotification 
			object: _model];
	}
}

- (void) modelChanged
{
	
}
@end