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
@implementation StateMachineTool : Tool
{
	ToolState _state;
}

- (id) init
{ 
	[super init];
	[self setState: [self initialState]];
	return self;
}

- (id) initialState
{
	return nil;
}

- (void) setState: (ToolState) aNewState
{
	_state = aNewState;
	//CPLog.debug(aNewState);
}

- (void) mouseDown:(CPEvent) anEvent	 
{
	[_state mouseDown: anEvent];
}

- (void) mouseDragged:(CPEvent) anEvent
{
	[_state mouseDragged: anEvent];
}

- (void) mouseUp:(CPEvent) anEvent
{
	[_state mouseUp: anEvent];
}

- (void) keyUp: (CPEvent) anEvent
{
	[_state keyUp: anEvent];
}

- (void) keyDown: (CPEvent) anEvent
{
	[_state keyDown: anEvent];
}
@end
