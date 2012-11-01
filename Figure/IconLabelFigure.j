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
@implementation IconLabelFigure : Figure 
{ 
	CPTextField _label;
	CPString _iconUrl;
	id _modelFeature;
	CPImageView _iconView;
} 

+ (IconLabelFigure) newAt: (CGPoint) aPoint iconUrl: (id) iconUrl
{
	var frame = CGRectMake(aPoint.x, aPoint.y, 100, 25);
	var widget = [[self new] initWithFrame: frame iconUrl: iconUrl];
	return widget;
}

- (id) initWithFrame: (CGRect) aFrame iconUrl: (id) iconUrl
{ 
	self = [super initWithFrame:aFrame];
	if (self) {
		_iconUrl = iconUrl;
		
		[handles addObject: [Handle target: self selector: @"middleLeft"]];
		[handles addObject: [Handle target: self selector: @"middleRight"]];

		//DRAW WIDGET NAME
		var label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
		[label setStringValue: @""];
		[label setTextColor:[CPColor blackColor]];
		[label sizeToFit];
		[label setFrameOrigin: CGPointMake(22, 4)];
		[self addSubview: label];
		_label = label;

		//DRAW ICON
		var icon = [[CPImage alloc]
		            initWithContentsOfFile: _iconUrl
		            size:CGSizeMake(16, 16)];
		
		var iconView = [[CPImageView alloc] initWithFrame:CGRectMake(4, 4, 16, 160)];
		[iconView setHasShadow:NO];
		[iconView setImageScaling:CPScaleNone];
		_iconView = iconView;
		
		var iconSize = [icon size];
		[iconView setFrameSize: iconSize];
		[iconView setImage: icon];
		[self addSubview: iconView];
		
		return self;
	}
}

- (void) switchToEditMode
{
	if ([self isEditable]) {
		var editorDelegate = [[EditorDelegate alloc] 
			initWithWidget: _label 
			label: _label
			window: [self window]
			figureContainer: self
			drawing: [self drawing]];
	}
}

- (id) value
{
	return [[self model] propertyValue: _modelFeature];
}

- (void) value: (id) aValue
{
	[[self model] propertyValue: _modelFeature be: aValue];	
}

- (void) setEditionResult: (String) aValue
{
	if (_modelFeature != nil && ([self model] != nil)) {
		[self value: aValue];
	} else {
		[self setLabelValue: aValue];
	}
}

- (void) setLabelValue: (String) aValue
{
	if (aValue == nil) {
		aValue = @"";
	}
	
	[_label setObjectValue: aValue];
	[_label sizeToFit];
	
	var currentFrameSize = [self frameSize];
	currentFrameSize.width = [_label frameOrigin].x + [_label frameSize].width;
	currentFrameSize.height = [_label frameOrigin].y + [_label frameSize].height;
	[self setFrameSize: currentFrameSize];
}

- (void) propertyChanged
{
	var value = [self value];
	//CPLog.info("Figure changed  " + self + " value: " + value);
	[self setLabelValue: value];
}

- (void) update
{
	[self propertyChanged];
}

- (void) checkModelFeature: (id) aModelFeature
{
	if (_modelFeature != nil && ([self model] != nil)) {
		[[CPNotificationCenter defaultCenter] 
			removeObserver: self 
			name: ModelPropertyChangedNotification 
			object: [self model]];
		
	}

	_modelFeature = aModelFeature

	if (_modelFeature != nil && ([self model] != nil)) {
		[[CPNotificationCenter defaultCenter] 
			addObserver: self 
			selector: @selector(propertyChanged) 
			name: ModelPropertyChangedNotification 
			object: [self model]];
			
		[self propertyChanged];
	}
}
@end