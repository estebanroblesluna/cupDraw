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

PropertyTypeBoolean = @"TYPE_BOOLEAN";
PropertyTypeInteger = @"TYPE_INTEGER";
PropertyTypeFloat   = @"TYPE_FLOAT";
PropertyTypeString  = @"TYPE_STRING";

/**
 * @author "Esteban Robles Luna <esteban.roblesluna@gmail.com>"
 */
@implementation Property : CPObject
{
	id _name;
	id _displayName;
	id _value;
	id _type;
	boolean _editable;
}

+ (Property) name: (id) aPropertyName value: (id) aValue
{
	return [self name: aPropertyName displayName: aPropertyName value: aValue];
}

+ (Property) name: (id) aPropertyName displayName: (id) aDisplayName value: (id) aValue
{
	return [[self new] initWithName: aPropertyName displayName: aDisplayName value: aValue type: PropertyTypeString];
}

+ (Property) name: (id) aPropertyName displayName: (id) aDisplayName value: (id) aValue type: (id) aType
{
	return [[self new] initWithName: aPropertyName displayName: aDisplayName value: aValue type: aType];
}

- (id) initWithName: (id) aPropertyName displayName: (id) aDisplayName value: (id) aValue type: (id) aType
{
	_name = aPropertyName;
	_value = aValue;
	_displayName = aDisplayName;
	_hidden = NO;
	_type = aType;
	return self;
}

- (id) name
{
	return _name;
}

- (id) type
{
	return _type;
}

- (id) displayName
{
	return _displayName;
}

- (id) value
{
	return _value;
}

- (void) value: aValue
{
	_value = aValue;
}

- (boolean) editable
{
	return _editable;
}

- (void) editable: aValue
{
	_editable = aValue;
}
@end
