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
@implementation ToolState : CPObject
{
	StateMachineTool _tool;
}

+ (id) tool: (StateMachineTool) aTool
{
	return [[self new] initWithTool: aTool];
}

- (id) initWithTool: (StateMachineTool) aTool
{ 
	self = [super init];
	if (self) {
		_tool = aTool;
		return self;
	}
}

- (void) transitionTo: (ToolState) aNewState
{
	[_tool setState: aNewState];
}

- (void) activateSelectionTool
{
	[_tool activateSelectionTool];
}

- (void) transitionToInitialState
{
	[self transitionTo: [_tool initialState]];
}

- (void) mouseDown:(CPEvent) anEvent	 
{
	[self transitionToInitialState];
}

- (void) mouseDragged:(CPEvent) anEvent
{
	[self transitionToInitialState];
}

- (void) mouseUp:(CPEvent) anEvent
{
	[self transitionToInitialState];
}

- (void) keyUp: (CPEvent) anEvent
{
	CPLog.debug(anEvent);
	[self transitionToInitialState];
}

- (void) keyDown: (CPEvent) anEvent
{
	CPLog.debug(anEvent);
	[self transitionToInitialState];
}
@end
