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
@implementation Tool : CPObject
{
	Drawing _drawing;
}

+ (id) drawing: (Drawing) aDrawing
{
	return [[self new] initWithDrawing: aDrawing];
}

- (id) initWithDrawing: (Drawing) aDrawing 
{ 
	_drawing = aDrawing;
	return self;
}

- (Drawing) drawing	 
{
	return _drawing;
}

- (void) activateSelectionTool
{
	var tool = [SelectionTool drawing: _drawing];
	[_drawing tool: tool];
}

- (void) activate
{
}

- (void) release
{
}

- (void) mouseDown:(CPEvent) anEvent	 
{
}

- (void) mouseDragged:(CPEvent) anEvent
{
}

- (void) mouseUp:(CPEvent) anEvent
{
}

- (void) keyUp: (CPEvent) anEvent
{
}

- (void) keyDown: (CPEvent) anEvent
{
}
@end
