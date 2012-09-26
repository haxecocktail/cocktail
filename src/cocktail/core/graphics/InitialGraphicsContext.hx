/*
	This file is part of Cocktail http://www.silexlabs.org/groups/labs/cocktail/
	This project is © 2010-2011 Silex Labs and is released under the GPL License:
	This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License (GPL) as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. 
	This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
	To read the license please visit http://www.gnu.org/copyleft/gpl.html
*/
package cocktail.core.graphics;

import cocktail.core.geom.Matrix;
import cocktail.core.html.HTMLDocument;
import cocktail.core.layer.LayerRenderer;
import cocktail.core.renderer.ElementRenderer;
import cocktail.port.GraphicsContextImpl;
import cocktail.port.NativeBitmapData;
import cocktail.port.NativeElement;
import cocktail.core.dom.NodeBase;
import cocktail.core.geom.GeomData;
import cocktail.core.layout.LayoutData;
import cocktail.core.css.CSSData;


/**
 * Represents the graphics context at the 
 * root of the graphics context tree
 * 
 * @author Yannick DOMINGUEZ
 */
class InitialGraphicsContext extends GraphicsContext
{
	/**
	 * class constructor
	 */
	public function new(layerRenderer:LayerRenderer)
	{
		super(layerRenderer);
	}
	
	/**
	 * Overriden to signal to the graphics context implementation
	 * to use the root of the native display list
	 */
	override private function initGraphicsContextImplementation():Void
	{
		_graphicsContextImpl = new GraphicsContextImpl(true);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// OVERRIDEN PRIVATE GRAPHICS CONTEXT TREE METHODS
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Don't attach the native layer, as for the root graphics context,
	 * it is managed be the graphics context implementation
	 */
	override private function doAttach():Void
	{
		
	}
	
	/**
	 * Don't detach the native layer, as for the root graphics context,
	 * it is managed be the graphics context implementation
	 */
	override private function doDetach():Void
	{
		
	}
}