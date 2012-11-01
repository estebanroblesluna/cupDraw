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
@implementation Property : CPObject
{
	id _name;
	id _value;
	boolean _editable;
}

+ (Property) name: (id) aPropertyName value: (id) aValue
{
	return [[self alloc] initWithName: aPropertyName value: aValue];
}

- (id) initWithName: (id) aPropertyName value: (id) aValue
{
	_name = aPropertyName;
	_value = aValue;
	_hidden = NO;
	return self;
}

- (id) name
{
	return _name;
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
