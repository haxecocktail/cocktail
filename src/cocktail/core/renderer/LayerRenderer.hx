package cocktail.core.renderer;
import cocktail.core.geom.Matrix;
import cocktail.core.NativeElement;
import haxe.Log;
/*
	This file is part of Cocktail http://www.silexlabs.org/groups/labs/cocktail/
	This project is © 2010-2011 Silex Labs and is released under the GPL License:
	This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License (GPL) as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. 
	This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
	To read the license please visit http://www.gnu.org/copyleft/gpl.html
*/
import cocktail.core.style.StyleData;

/**
 * A LayerRenderer is in charge of rendering 
 * one or many ElementRenderers. The LayerRenders
 * of the document are rendered on top of each
 * other in a defined order.
 * 
 * LayerRenderers are created by ElementRenderers
 * which can either create new LayerRenderer or 
 * use the one of their parent
 * 
 * All the LayerRenderers are rendered recursively
 * starting from the LayerRenderer generated by 
 * the BodyHTMLElement
 * 
 * @author Yannick DOMINGUEZ
 */
class LayerRenderer 
{
	/**
	 * A reference to the ElementRenderer which
	 * created the LayerRenderer
	 */
	private var _rootRenderer:ElementRenderer;

	/**
	 * class constructor
	 */
	public function new(rootRenderer:ElementRenderer) 
	{
		_rootRenderer = rootRenderer;
	}
	
	/////////////////////////////////
	// PUBLIC METHODS
	////////////////////////////////
	
	public function dispose():Void
	{
		_rootRenderer = null;
	}
	
	/**
	 * Render all the ElementRenderers using this LayerRenderer
	 * in a defined order
	 */
	public function render():Array<NativeElement>
	{
		var nativeElements:Array<NativeElement> = new Array<NativeElement>();
	
		
		if (_rootRenderer.canHaveChildren() == true && _rootRenderer.coreStyle.isInlineLevel() == false
		|| _rootRenderer.coreStyle.display == inlineBlock)
		{
			var rootRendererBackground:Array<NativeElement> = _rootRenderer.renderBackground();
			
			for (i in 0...rootRendererBackground.length)
			{
				nativeElements.push(rootRendererBackground[i]);
			}
			
			var childrenBlockContainerBackground:Array<NativeElement> = renderChildrenBlockContainerBackground();	
				
			for (i in 0...childrenBlockContainerBackground.length)
			{
				nativeElements.push(childrenBlockContainerBackground[i]);
			}
			
			var inFlowChildren:Array<NativeElement> = renderInFlowChildren();
			
			for (i in 0...inFlowChildren.length)
			{
				nativeElements.push(inFlowChildren[i]);
			}
			
		
			var childLayers:Array<NativeElement> = renderChildLayer();

			for (i in 0...childLayers.length)
			{
				nativeElements.push(childLayers[i]);
			}
			
			#if (flash9 || nme)
			
			if (_rootRenderer.establishesNewFormattingContext() == true)
			{
				for (i in 0...nativeElements.length)
				{
					nativeElements[i].x += _rootRenderer.bounds.x;
					nativeElements[i].y += _rootRenderer.bounds.y; 
					
				}
				
				//TODO : hack to place back the background of the root layer renderer
				//as it is already placed when the background is created
				for (i in 0...rootRendererBackground.length)
				{
					rootRendererBackground[i].x -= _rootRenderer.bounds.x;
					rootRendererBackground[i].y -= _rootRenderer.bounds.y; 
				}
			}
			
		
			
			#end
	

			
			//TODO : retrieve and render floated elements	
			//renderChildrenNonPositionedFloats();
		}
		
		else
		{
			
			
			var rootRendererBackground:Array<NativeElement> = _rootRenderer.renderBackground();
			
			for (i in 0...rootRendererBackground.length)
			{
				nativeElements.push(rootRendererBackground[i]);
			}
			
			var rootRendererElements = _rootRenderer.render();
			
			for (i in 0...rootRendererElements.length)
			{
				nativeElements.push(rootRendererElements[i]);
			}
			
			
		}
		
		
		return nativeElements;
	}
	
	/////////////////////////////////
	// PRIVATE METHODS
	////////////////////////////////
	
	/**
	 * Render all the backgrounds of the block box of this LayerRenderer except for the
	 * root renderer and return an array of native elements from it
	 */
	private function renderChildrenBlockContainerBackground():Array<NativeElement>
	{
		var childrenBlockContainer:Array<ElementRenderer> = getBlockContainerChildren(cast(_rootRenderer));
		
		var ret:Array<NativeElement> = new Array<NativeElement>();
		
		for (i in 0...childrenBlockContainer.length)
		{
			var nativeElements:Array<NativeElement> = childrenBlockContainer[i].renderBackground();
			
			for (j in 0...nativeElements.length)
			{
				ret.push(nativeElements[j]);
			}
		}
		return ret;
	}
	
	/**
	 * Retrieve all the children block container of this LayerRenderer by traversing
	 * recursively the rendering tree.
	 * 
	 * TODO : would also return the InlineBoxRenderer if they were attached to the
	 * rendering tree as they should
	 */
	private function getBlockContainerChildren(rootRenderer:FlowBoxRenderer):Array<ElementRenderer>
	{
		var ret:Array<ElementRenderer> = new Array<ElementRenderer>();
		
		for (i in 0...rootRenderer.childNodes.length)
		{
			var child:ElementRenderer = cast(rootRenderer.childNodes[i]);
			
			if (child.layerRenderer == this)
			{
				//TODO : must add more condition, for instance, no float
				if (child.canHaveChildren() == true && child.coreStyle.display != inlineBlock)
				{
					ret.push(cast(child));
					
					var childElementRenderer:Array<ElementRenderer> = getBlockContainerChildren(cast(child));
					
					for (j in 0...childElementRenderer.length)
					{
						ret.push(childElementRenderer[j]);
					}
				}
			}
		}
		return ret;
	}
	
	/**
	 * Render all the children LayerRenderer of this LayerRenderer
	 * and return an array of NativeElements from it
	 */
	private function renderChildLayer():Array<NativeElement>
	{
		var childLayers:Array<LayerRenderer> = getChildLayers(cast(_rootRenderer), this);
		
		//TODO : shouldn't have to do that
		childLayers.reverse();
		
		var ret:Array<NativeElement> = new Array<NativeElement>();
		
		for (i in 0...childLayers.length)
		{
			var nativeElements:Array<NativeElement> = childLayers[i].render();
			for (j in 0...nativeElements.length)
			{
				ret.push(nativeElements[j]);
			}
		}
		
		return ret;
	}
	
	/**
	 * Retrieve all the children LayerRenderer of this LayerRenderer by traversing
	 * recursively the rendering tree.
	 */
	private function getChildLayers(rootRenderer:FlowBoxRenderer, referenceLayer:LayerRenderer):Array<LayerRenderer>
	{
		var childLayers:Array<LayerRenderer> = new Array<LayerRenderer>();
		
		//loop in all the children of the root renderer of this LayerRenderer
		for (i in 0...rootRenderer.childNodes.length)
		{
			var child:ElementRenderer = cast(rootRenderer.childNodes[i]);
			
			//if the child uses this layer
			if (child.layerRenderer == referenceLayer)
			{
				//if it can have children, recursively search for children layerRenderer
				if (child.canHaveChildren() == true && child.coreStyle.display != inlineBlock)
				{
					var childElementRenderer:Array<LayerRenderer> = getChildLayers(cast(child), referenceLayer);
					for (j in 0...childElementRenderer.length)
					{
						childLayers.push(childElementRenderer[j]);
					}
				}
			}
			//if the child has a different LayerRenderer, store it in the childLayers array
			else
			{
				childLayers.push(child.layerRenderer);
			}
		}
		
		return childLayers;
	}
	
	/**
	 * Render all the in flow children (not positioned) using
	 * this LayerRenderer and return an array of NativeElement
	 * from it
	 */
	private function renderInFlowChildren():Array<NativeElement>
	{
		var inFlowChildren:Array<ElementRenderer> = getInFlowChildren(cast(_rootRenderer));
		
		var ret:Array<NativeElement> = new Array<NativeElement>();
		
		for (i in 0...inFlowChildren.length)
		{
			var nativeElements:Array<NativeElement> = [];
			if (inFlowChildren[i].coreStyle.display == inlineBlock)
			{
				
				
				//TODO : add missing rendering bits
				//TODO : manage the case where inline-block is a replaced element
						
				//TODO : messy, should be below
					var bg = inFlowChildren[i].renderBackground();
				
					for (l in 0...bg.length)
					{
						nativeElements.push(bg[l]);
					}
					
					var d = getChildLayers(cast(inFlowChildren[i]), this);
					
					for (l in 0...d.length)
					{
						var ne = d[l].render();
						for (m in 0...ne.length)
						{
							#if (flash9 || nme)
							ne[m].x += inFlowChildren[i].bounds.x;
							ne[m].y += inFlowChildren[i].bounds.y;
							#end
						
							nativeElements.push(ne[m]);
						}
	
					}
					
					var childElementRenderer:Array<ElementRenderer> = getInFlowChildren(cast(inFlowChildren[i]));
					for (l in 0...childElementRenderer.length)
					{
						childElementRenderer[l].bounds.x += inFlowChildren[i].bounds.x;
						childElementRenderer[l].bounds.y += inFlowChildren[i].bounds.y;
						
						var el = childElementRenderer[l].render();
						
						for (k in 0...el.length)
						{
							nativeElements.push(el[k]);
						}
						
					}
			}
				
			else
			{
				nativeElements = inFlowChildren[i].render();
			}
			
			if (inFlowChildren[i].canHaveChildren() == false && inFlowChildren[i].isText() == false)
			{
				
				
				var bg = inFlowChildren[i].renderBackground();
				
				for (j in 0...bg.length)
				{
					ret.push(bg[j]);
				}
			}
			
			for (j in 0...nativeElements.length)
			{
				ret.push(nativeElements[j]);
			}
			
			
		}
		
		return ret;
	}
	
	/**
	 * Return all the in flow children of this LayerRenderer by traversing
	 * recursively the rendering tree
	 */
	private function getInFlowChildren(rootRenderer:FlowBoxRenderer):Array<ElementRenderer>
	{
		
		var ret:Array<ElementRenderer> = new Array<ElementRenderer>();
		
		if (rootRenderer.establishesNewFormattingContext() == true && rootRenderer.coreStyle.childrenInline() == true)
		{
			
			
			var blockBoxRenderer:BlockBoxRenderer = cast(rootRenderer);
			

			
			for (i in 0...blockBoxRenderer.lineBoxes.length)
			{
				for (j in 0...blockBoxRenderer.lineBoxes[i].length)
				{
					if (blockBoxRenderer.lineBoxes[i][j].isPositioned() == false && blockBoxRenderer.lineBoxes[i][j].isDisplayed() == true)
					{
						ret.push(blockBoxRenderer.lineBoxes[i][j]);
					}
				}
			}
			
		}
		else
		{
			for (i in 0...rootRenderer.childNodes.length)
			{
				var child:ElementRenderer = cast(rootRenderer.childNodes[i]);
				
				if (child.isDisplayed() == true)
				{
					if (child.layerRenderer == this)
					{
						if (child.isPositioned() == false)
						{
							ret.push(child);
							

							
							if (child.canHaveChildren() == true)
							{	
	
								
								var childElementRenderer:Array<ElementRenderer> = getInFlowChildren(cast(child));
								for (j in 0...childElementRenderer.length)
								{
									if (child.establishesNewFormattingContext() == true)
									{
										childElementRenderer[j].bounds.x += child.bounds.x;
										childElementRenderer[j].bounds.y += child.bounds.y;
									}
								
									ret.push(childElementRenderer[j]);
								}
							}
						}
					}
				}

			}
		}
		
		return ret;
	}
	
	//TODO : implement layer renderer transformation
	
	/**
	 * when the matrix is set, update also
	 * the values of the native flash matrix of the
	 * native DisplayObject
	 * 
	 * 
	 * @param	matrix
	 */
	public function setNativeMatrix(matrix:Matrix):Void
	{
		/**
		//concenate the new matrix with the base matrix of the HTMLElement
		var concatenatedMatrix:Matrix = getConcatenatedMatrix(matrix);
		
		//get the data of the abstract matrix
		var matrixData:MatrixData = concatenatedMatrix.data;
		
		//create a native flash matrix with the abstract matrix data
		var nativeTransformMatrix:flash.geom.Matrix  = new flash.geom.Matrix(matrixData.a, matrixData.b, matrixData.c, matrixData.d, matrixData.e, matrixData.f);
	
		//apply the native flash matrix to the native flash DisplayObject
		_htmlElement.nativeElement.transform.matrix = nativeTransformMatrix;
		
	//	super.setNativeMatrix(concatenatedMatrix);
		*/
	}
	
	/**
	 * When concatenating the base Matrix of an embedded element, it must also
	 * be scaled using the intrinsic width and height of the HTMLElement as reference
	 * 
	 */
	private function getConcatenatedMatrix(matrix:Matrix):Matrix
	{
		
		var currentMatrix:Matrix = new Matrix();
		//
		//var embeddedHTMLElement:EmbeddedHTMLElement = cast(this._htmlElement);
		//
		//currentMatrix.concatenate(matrix);
		//currentMatrix.translate(this._nativeX, this._nativeY);
		//
		//currentMatrix.scale(this._nativeWidth / embeddedHTMLElement.intrinsicWidth, this._nativeHeight / embeddedHTMLElement.intrinsicHeight, { x:0.0, y:0.0} );
		//
		return currentMatrix;
	}
	
	/**
	 * Concatenate the new matrix with the "base" matrix of the HTMLElement
	 * where only translations (the x and y of the HTMLElement) and scales
	 * (the width and height of the HTMLElement) are applied.
	 * It is neccessary in flash to do so to prevent losing the x, y, width
	 * and height applied during layout
	 * 
	 */
	private function getConcatenatedMatrix2(matrix:Matrix):Matrix
	{
		var currentMatrix:Matrix = new Matrix();
		//currentMatrix.concatenate(matrix);
		//currentMatrix.translate(this._nativeX, this._nativeY);
		return currentMatrix;
	}
	
}