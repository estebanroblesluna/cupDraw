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
@implementation Handle : Figure 
{ 
	Figure _targetFigure;
	SEL _getSelector;
	SEL _setSelector;
	id _extraArgument;
	CPColor _displayColor;
} 

+ (id) target: (id) aTargetFigure selector: (CPString) aStringSelector
{
	 return [self target: aTargetFigure selector: aStringSelector extraArgument: nil];
}

+ (id) target: (id) aTargetFigure selector: (CPString) aStringSelector extraArgument: (id) extraArgument
{ 
	var getSelector = CPSelectorFromString(aStringSelector);
	var setSelector = CPSelectorFromString([aStringSelector stringByAppendingString: @":"]);
	return [self target: aTargetFigure getSelector: getSelector setSelector: setSelector extraArgument: extraArgument];
}

+ (id) target: (id) aTargetFigure getSelector: (SEL) getSelector setSelector: (SEL) setSelector extraArgument: (id) extraArgument
{
	return [[self alloc] initWithTarget: aTargetFigure getSelector: getSelector setSelector: setSelector extraArgument: extraArgument];
}

- (id) initWithTarget: (id) aTargetFigure getSelector: (SEL) getSelector setSelector: (SEL) setSelector extraArgument: (id) extraArgument
{ 
	[super init];
	
	_targetFigure = aTargetFigure;
	_getSelector = getSelector;
	_setSelector = setSelector;
	_extraArgument = extraArgument;
	_displayColor = [_targetFigure handleColor];

	[[CPNotificationCenter defaultCenter] 
		addObserver: self 
		selector: @selector(updateLocation:) 
		name: @"CPViewFrameDidChangeNotification" 
		object: _targetFigure];
	
	var point = [self getPoint];
	//CPLog.debug(point.x);
	//CPLog.debug(point.y);
	self = [super initWithFrame: CGRectMake(point.x - 4, point.y - 4, 8, 8)];
	//CPLog.debug(self);
	
	if (self) {
		return self;
	}
}

- (id) extraArgument
{
	return _extraArgument;
}

- (void) extraArgument: (id) anExtraArgument
{
	_extraArgument = anExtraArgument;
}

- (void) getSelector: (id) aGetSelector setSelector: (id) aSetSelector
{
	_getSelector = aGetSelector;
	_setSelector = aSetSelector;
	//CPLog.info(@"getSelector");
}

- (CPPoint) getPoint 
{
	var point = nil;
	
	if (_extraArgument == nil) {
		point = [_targetFigure performSelector: _getSelector];
	} else {
		point = [_targetFigure performSelector: _getSelector withObject: _extraArgument];
	}
	
	return point;
}

- (void) updateLocation: (id) aNotification
{
	var point = [self getPoint];

	var x = point.x - 4;
	var y = point.y - 4;

	var newOrigin = CGPointMake(x, y);
	[super setFrameOrigin: newOrigin];
}

- (bool) isHandle
{ 
	return true;
}

- (bool) isMoveable
{ 
	return true;
}

- (Figure) targetFigure
{ 
	return _targetFigure;
}

- (void) setFrameOrigin: (CGPoint) aPoint
{
	//CPLog.info(@"setFrameOrigin");
	if (_extraArgument == nil) {
		[_targetFigure performSelector: _setSelector withObject: aPoint];
	} else {
		[_targetFigure performSelector: _setSelector withObject: _extraArgument withObject: aPoint];
	}
}

- (void) moveTo: (CGPoint) aPoint
{
	//CPLog.info(@"moveTo");
	//CPLog.info([_targetFigure isEditable]);
	if ([_targetFigure isEditable]) {
		[super moveTo: aPoint];
	}
}

- (void) displayColor: (CPColor) aDisplayColor
{
	_displayColor = aDisplayColor;
	[self setNeedsDisplay: YES];
}

- (void)drawRect:(CGRect)rect on: (id)context
{
	CGContextSetFillColor(context, _displayColor);
	CGContextFillRect(context, [self bounds]);
	CGContextSetFillColor(context, [CPColor whiteColor]);
	CGContextFillRect(context, CGRectMake(2, 2, 4, 4));
}

@end