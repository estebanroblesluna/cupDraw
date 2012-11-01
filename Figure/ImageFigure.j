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
@implementation ImageFigure : Figure 
{
	CPTextField _textField;
	id _offset;
	boolean _showBorder;
}

+ (ImageFigure) initializeWithImage: (id) stringResource x: (id) anX y: (id) anY
{
	return [self initializeWithImage: stringResource x: anX y: anY offset: 0];
}

+ (ImageFigure) initializeWithImage: (id) stringResource x: (id) anX y: (id) anY offset: (id) anOffset
{
	var figure = [[self alloc] initializeWithImage: stringResource x: anX y: anY offset: anOffset];
	return figure;
}

- (id) initializeWithImage: (id) stringResource x: (id) anX y: (id) anY offset: (id) anOffset
{
	var frame = CGRectMake(anX, anY, 0, 0);
	self = [super initWithFrame: frame];
	
	if (self) {
		var icon = [[CPImage alloc]
		            initWithContentsOfFile: stringResource];
		_offset = anOffset;
		_showBorder = true;
		
		[icon setDelegate: self];

		return self;
	}
}

- (void) showBorder: (boolean) aValue
{
	_showBorder = aValue;
}

- (void) imageDidLoad: (CPImage) image
{
	var size = [image size];
	var iconView = [[CPImageView alloc] initWithFrame: CGRectMake(_offset, _offset, size.width, size.height)];
	[iconView setHasShadow: NO];
	[iconView setImageScaling: CPScaleNone];
	
	var frameSize = CGSizeMake(size.width + (_offset * 2), size.height + (_offset * 2));
	[iconView setImage: image];
	[self addSubview: iconView];
	[self setFrameSize: frameSize];
	[self invalidate];
}

- (CPColor) borderColor
{ 
	return [CPColor colorWithHexString: @"#EAEAEA"];
}

- (void)drawRect:(CGRect)rect on: (id)context
{
	CGContextSetFillColor(context, [CPColor whiteColor]); 
    CGContextFillRect(context, [self bounds]); 

	if (_showBorder) {
		CGContextSetLineWidth(context, 0.25);
	    CGContextSetFillColor(context, [self borderColor]); 
	    CGContextSetStrokeColor(context, [self borderColor]); 
	    CGContextStrokeRect(context, [self bounds]);
	}
}
@end