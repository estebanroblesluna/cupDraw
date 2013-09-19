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
@implementation LabelFigure : Figure 
{
	CPTextField _textField;
}

+ (LabelFigure) initializeWithText: (id) text at: (CPPoint) aPoint
{
	var label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
	[label setStringValue: text];
	[label setTextColor: [CPColor blackColor]];
	[label setFrameOrigin: CGPointMake(0, 0)];
	[label sizeToFit];
	[label setBordered: NO];
	[label setBezeled: NO];
	return [self initializeWithTextField: label at: aPoint];
}

+ (LabelFigure) initializeWithTextField: (CPTextField) textField at: (CPPoint) aPoint
{
	var textFrameSize = [textField frameSize];
	var frame = CGRectMake(aPoint.x, aPoint.y, textFrameSize.width, textFrameSize.height);
	var label = [[self alloc] initWithFrame: frame textField: textField];
	return label;
}

- (id) initWithFrame: (CGRect) aFrame textField: (id) aTextField
{ 
	[super initWithFrame: aFrame];
	_textField = aTextField;
	_backgroundColor = [CPColor whiteColor];
	_foregroundColor = [CPColor blackColor];
	[self addSubview: _textField];
	return self;
}

- (void) figureAt: (CPPoint) aPoint
{
	var frame = [self frame];
	if (CPRectContainsPoint(frame, aPoint)) {
		return self;
	} else {
		return nil;
	}
}

- (void) setText: (id) aText
{
	[_textField setStringValue: aText];
	[_textField sizeToFit];
	[self setFrameSize: [_textField frameSize]];
}

- (void) backgroundColor: (CPColor) aColor
{
	[super backgroundColor: aColor];
	[_textField setTextFieldBackgroundColor: aColor];
}

- (void) foregroundColor: (CPColor) aColor
{
	[super foregroundColor: aColor];
	[_textField setTextColor: aColor];
}

- (bool) isSelectable
{ 
	return true;
}

- (bool) isMoveable
{ 
	return true;
}
@end