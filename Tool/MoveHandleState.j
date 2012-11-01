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
@implementation MoveHandleState : ToolState
{
	CPPoint _initialDragPoint;
	Handle _handle;
}

+ (id) tool: (StateMachineTool) aTool initialDragPoint: (CPPoint) anInitialDragPoint handle: (Handle) aHandle
{
	var state = [self tool: aTool];
	[state initWithInitialDragPoint: anInitialDragPoint handle: aHandle];
	return state;
}

- (id) initWithInitialDragPoint: (CPPoint) anInitialDragPoint handle: (Handle) aHandle
{
	_initialDragPoint = anInitialDragPoint;
	_handle = aHandle;
	return self;
}

- (void) mouseDragged:(CPEvent) anEvent
{
	var newLocation = [anEvent locationInWindow];
	var dragXOffset = newLocation.x - _initialDragPoint.x;
	var dragYOffset = newLocation.y - _initialDragPoint.y;
	
	var snapToGrid = [[_tool drawing] snapToGrid];
	var gridSize = [[_tool drawing] gridSize];
	
	var initialFigurePosition = [_tool initialPositionOf: _handle];

	var newOrigin = CGPointMake(initialFigurePosition.x + dragXOffset, initialFigurePosition.y + dragYOffset);
	
	if (snapToGrid) {
		newOrigin = CGPointMake(ROUND(newOrigin.x / gridSize) * gridSize, ROUND(newOrigin.y / gridSize) * gridSize);
	}
	
    [_handle moveTo: newOrigin];
}

- (void) mouseUp:(CPEvent) anEvent
{
	var point = [anEvent locationInWindow];
	[self transitionTo: [SelectedState tool: _tool initialDragPoint: point]];
}
@end
