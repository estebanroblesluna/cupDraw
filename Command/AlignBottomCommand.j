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
@implementation AlignBottomCommand : Command
{
}

- (void) undo
{
}

- (void) execute
{
	var tool = [_drawing tool];
	var selectedFigures = [tool selectedFigures];
	
	if ([selectedFigures count] > 1) {
	    var referenceFigure = [selectedFigures objectAtIndex: 0];
		var y = [referenceFigure bottomMiddle].y;
		
		for (var i = 1; i < [selectedFigures count]; i++) { 
		    var figure = [selectedFigures objectAtIndex: i];
		    var oldFrameOrigin = [figure frameOrigin];
		    var frameSize = [figure frameSize];
			var newPosition = CGPointMake(oldFrameOrigin.x, y - frameSize.height);
			[figure moveTo: newPosition];
		}
		
		[tool updateInitialPoints];
	}
}
@end
