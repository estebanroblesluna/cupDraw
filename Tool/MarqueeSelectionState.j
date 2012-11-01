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
@implementation MarqueeSelectionState : ToolState
{
	CPPoint _initialDragPoint;
	RectangleFigure _rectangleFigure;
}

+ (id) tool: (StateMachineTool) aTool initialDragPoint: (CPPoint) anInitialDragPoint
{
	var state = [self tool: aTool];
	[state initWithInitialDragPoint: anInitialDragPoint];
	return state;
}

- (id) initWithInitialDragPoint: (CPPoint) anInitialDragPoint
{
	_initialDragPoint = anInitialDragPoint;
	_rectangleFigure = [RectangleFigure newAt: _initialDragPoint];
	[_rectangleFigure backgroundColor: [CPColor colorWithWhite: 0 alpha: 0]];
	var frame = CGRectMake(_initialDragPoint.x, _initialDragPoint.y, 1, 1);
	[_rectangleFigure setFrame: frame];
	[[_tool drawing] addFigure: _rectangleFigure];
	return self;
}

- (void) mouseDragged: (CPEvent) anEvent
{
	var frame = [self computeFrame: anEvent];
	[_rectangleFigure setFrame: frame];
}

- (void) mouseUp: (CPEvent) anEvent
{
	var frame = [self computeFrame: anEvent];
	[_rectangleFigure removeFromSuperview];
	
	var figures = [[_tool drawing] figuresIn: frame];
	
	if ([figures count] > 0) {
		for (var i = 0; i < [figures count]; i++) { 
			var selectedFigure = [figures objectAtIndex: i];
			[_tool select: selectedFigure];
		}
		[self transitionTo: [SelectedState tool: _tool initialDragPoint: nil]];
	} else {
		[_tool clearSelection];
		[self transitionToInitialState];
	}
}

- (id) computeFrame: (CPEvent) anEvent
{
	var point = [anEvent locationInWindow];
	var x = MIN(_initialDragPoint.x, point.x);
	var y = MIN(_initialDragPoint.y, point.y);
	var width = ABS(_initialDragPoint.x - point.x);
	var height = ABS(_initialDragPoint.y - point.y);
	var frame = CGRectMake(x, y, width, height);
	return frame;
}
@end