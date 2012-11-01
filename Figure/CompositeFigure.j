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
@implementation CompositeFigure : Figure 
{
}

- (void) addFigure: (Figure) aFigure
{
	[super addSubview: aFigure];
}


- (void) removeFigure: (Figure) aFigure
{
	[aFigure removeFromSuperview];
}

- (void) addSubview: (id) aView
{
	[CPException raise: "invalid method" reason:"Use addFigure instead"];
}

- (void) clearFigures
{
	[self setSubviews: [CPMutableArray array]];
}

- (id) figures
{
	var figures = [CPMutableArray array];
	[figures addObjectsFromArray: [self subviews]];
	return figures;
}

- (CPArray) figuresIn: (id) rect
{
	var result = [CPMutableArray array];
	var figures = [self subviews];
	for (var i = 0; i < [figures count]; i++) { 
		var figure = [figures objectAtIndex:i];
		if (CGRectContainsRect(rect, [figure frame])) {
			[result addObject: figure];
		}
	}
	return result;
}

@end