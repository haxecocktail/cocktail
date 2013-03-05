/*
 * Cocktail, HTML rendering engine
 * http://haxe.org/com/libs/cocktail
 *
 * Copyright (c) Silex Labs
 * Cocktail is available under the MIT license
 * http://www.silexlabs.org/labs/cocktail-licensing/
*/
package cocktail.core.html;
import cocktail.core.css.InitialStyleDeclaration;
import cocktail.core.dom.Document;
import cocktail.core.dom.DOMException;
import cocktail.core.renderer.InitialBlockRenderer;
import cocktail.core.layer.LayerRenderer;
import cocktail.core.renderer.RendererData;
import cocktail.core.parser.DOMParser;

/**
 * Root of an HTML document
 * 
 * @author Yannick DOMINGUEZ
 */
class HTMLHtmlElement extends HTMLElement
{	
	/**
	 * class constructor
	 */
	public function new() 
	{
		super(HTMLConstants.HTML_HTML_TAG_NAME);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// OVERRIDEN GETTER/SETTER
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Overriden to reset the HTMLBodyElement when the innerHTML is set,
	 * as it reset the whole document
	 */
	override private function set_innerHTML(value:String):String
	{
		super.set_innerHTML(value);
		var htmlDocument:HTMLDocument = cast(ownerDocument);
		htmlDocument.initBody(cast(getElementsByTagName(HTMLConstants.HTML_BODY_TAG_NAME)[0]));
		return value;
	}

	/**
	 * Overriden as the HTML element's outerHTML can't be set
	 */
	override private function set_outerHTML(value:String):String
	{
		throw DOMException.NO_MODIFICATION_ALLOWED_ERR;
		return value;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// OVERRIDEN PRIVATE RENDERING TREE METHODS
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * As the ElementRenderer generated by the 
	 * HTMLHTMLElement is the root of the rendering
	 * tree, its parent is always considered rendered
	 * so that this doesn't prevent the rendering of
	 * the document
	 */
	override private function isParentRendered():Bool
	{
		return true;
	}
	
	/**
	 * The HTMLHTMLElement always generate a root rendering
	 * tree element.
	 */
	override private function createElementRenderer():Void
	{ 
		elementRenderer = new InitialBlockRenderer(this);
	}
	
	/**
	 * do nothing as there is no parent ElementRenderern no need to
	 * attach to parent
	 */
	override private function attachToParentElementRenderer():Void
	{
		
	}
	
	/**
	 * As there is no parent ElementRenderer, need to 
	 * detach explicitily the initial block renderer
	 */
	override private function detachFromParentElementRenderer():Void
	{
		elementRenderer.removedFromRenderingTree();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// OVERRIDEN COORDS GETTERS
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Return nothing as the HTMLHTMLElement is the root 
	 * of the rendering tree
	 */
	override private function get_offsetParent():HTMLElement
	{
		return null;
	}
	
	/**
	 * The html root don't have an offset top
	 */
	override private function get_offsetTop():Int
	{
		return 0;
	}
	
	/**
	 * The html root don't have an offset left
	 */
	override private function get_offsetLeft():Int
	{
		return 0;
	}
	
}