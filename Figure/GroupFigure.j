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
@implementation GroupFigure : CompositeFigure 
{
}

- (id) initWithFrame:(CGRect)aFrame 
{ 
	self = [super initWithFrame:aFrame];
	if (self) {
		[handles addObject: [Handle target: self selector: @"topLeft"]];
		[handles addObject: [Handle target: self selector: @"topMiddle"]];
		[handles addObject: [Handle target: self selector: @"topRight"]];

		[handles addObject: [Handle target: self selector: @"middleLeft"]];
		[handles addObject: [Handle target: self selector: @"middleRight"]];

		[handles addObject: [Handle target: self selector: @"bottomLeft"]];
		[handles addObject: [Handle target: self selector: @"bottomMiddle"]];
		[handles addObject: [Handle target: self selector: @"bottomRight"]];
		return self;
	}
}

- (id) figureAt: (CPPoint) aPoint
{
	var figure = [self primSubfiguresAt: aPoint];
	if (figure != nil) {
		return self;
	} else {
		return nil;
	}
}

- (id) ungroup
{
	var parent = [self superview];
	var figures = [self figures];
	var translation = [self frameOrigin];
	
	[parent removeFigure: self];

	for (var i = 0; i < [figures count]; i++) { 
	    var figure = [figures objectAtIndex: i];
		[figure translateBy: translation];
		[parent addFigure: figure];
	}
	
	return figures;
}
@end