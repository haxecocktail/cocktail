/*
	This project is © 2010-2011 Silex Labs and is released under the GPL License:
	This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License (GPL) as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. 
	This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
	To read the license please visit http://www.gnu.org/copyleft/gpl.html
*/

package org.intermedia.view;

// DOM
import cocktail.domElement.DOMElement;
import cocktail.domElement.ContainerDOMElement;
import cocktail.domElement.ImageDOMElement;
import cocktail.domElement.GraphicDOMElement;

// Native Elements
import cocktail.nativeElement.NativeElementManager;
import cocktail.nativeElement.NativeElementData;

// Style
import cocktail.style.StyleData;
import cocktail.unit.UnitData;
import org.intermedia.view.ScreenResolution;
import org.intermedia.model.ApplicationModel;


/**
 * This class defines the styles used by the CellThumbText
 * 
 * @author Raphael Harmel
 */

class CellThumbText1Style
{
	static inline var CELL_VERTICAL_SPACE:Int = Constants.CELL_VERTICAL_SPACE;
	static inline var CELL_TEXT_WIDTH_PERCENT:Int = 60;
	public static inline var CELL_THUMB_WIDTH_PERCENT:Int = 100 - CELL_TEXT_WIDTH_PERCENT - 5;
	
	/**
	 * Defines cell Style
	 * 
	 * @param	domElement
	 * @param	?cellPerLine
	 * @return	thumb mask size
	 */
	public static function setCellStyle(domElement:DOMElement,?cellPerLine:Int=1):Size
	{
		/*domElement.style.display = DisplayStyleValue.inlineBlock;
		domElement.style.position = PositionStyleValue.staticStyle;
		
		domElement.style.marginLeft = MarginStyleValue.length(px(0));
		domElement.style.marginRight = MarginStyleValue.length(px(0));
		domElement.style.marginTop = MarginStyleValue.length(px(0));
		domElement.style.marginBottom = MarginStyleValue.length(px(0));
		
		domElement.style.paddingLeft = PaddingStyleValue.length(px(0));
		domElement.style.paddingRight = PaddingStyleValue.length(px(0));
		domElement.style.paddingTop = PaddingStyleValue.length(px(CELL_VERTICAL_SPACE));
		domElement.style.paddingBottom = PaddingStyleValue.length(px(0));
		
		// compute cell width depending on cellPerLine value
		var cellPercentWidth:Int = 0;
		//if (cellPerLine != 0) cellPercentWidth = Std.int(100 / cellPerLine) - 1;
		if (cellPerLine != 0) cellPercentWidth = Std.int(100 / cellPerLine);
		else cellPercentWidth = 100;
		domElement.style.width = DimensionStyleValue.percent(cellPercentWidth);
		//domElement.style.height = DimensionStyleValue.length(px(70));
		//domElement.style.overflow = { x:OverflowStyleValue.hidden, y:OverflowStyleValue.hidden };*/
		
		CellStyle.setCellStyle(domElement,cellPerLine);
		
		// apply border
		//CellStyle.addBorder(domElement);
		
		// compute cell size in pixel depending on cellPerLine value
		//var cellSize:Size = computeMaskSize(cellPerLine, thumbWidthPercent);
		var cellSize:Size = ImageUtils.computeMaskSize(cellPerLine,CELL_THUMB_WIDTH_PERCENT);
		
		domElement.style.height = DimensionStyleValue.length(px(cellSize.height));
		//domElement.style.maxHeight = ConstrainedDimensionStyleValue.length(px(CELL_MAX_HEIGHT));

		domElement.style.overflow = { x:OverflowStyleValue.hidden, y:OverflowStyleValue.hidden };
		
		// apply border
		CellStyle.addBorder(domElement);
		
		return cellSize;

	}
	
	/**
	 * Defines cell image Style
	 * 
	 * @param	domElement
	 */
	public static function setThumbnailStyle(domElement:ImageDOMElement,maskSize:Size):Void
	{
		/*var imageMaxWidth:Int = 200;
		
		//setCellStyle(domElement);
		
		domElement.style.display = DisplayStyleValue.inlineStyle;
		
		//domElement.style.paddingLeft = PaddingStyleValue.percent(0);
		//domElement.style.paddingRight = PaddingStyleValue.percent(0);
		//domElement.style.paddingLeft = PaddingStyleValue.length(px(5));
		//domElement.style.paddingRight = PaddingStyleValue.length(px(5));

		domElement.style.verticalAlign = VerticalAlignStyleValue.middle;

		domElement.style.maxWidth = ConstrainedDimensionStyleValue.length(px(imageMaxWidth));
		domElement.style.maxHeight = ConstrainedDimensionStyleValue.percent(50);
		domElement.style.width = DimensionStyleValue.percent(CELL_THUMB_WIDTH_PERCENT);	

		domElement.style.opacity = OpacityStyleValue.number(0);*/
		
		CellThumbStyle.setThumbnailStyle(domElement,maskSize);
	}
		
	/**
	 * Defines cell text block Style
	 * 
	 * @param	domElement
	 */
	public static function setTextBlockStyle(domElement:DOMElement):Void
	{
		//setCellStyle(domElement);
		
		domElement.style.display = DisplayStyleValue.inlineBlock;
		domElement.style.marginLeft = MarginStyleValue.percent(2);
		domElement.style.verticalAlign = VerticalAlignStyleValue.top;
		domElement.style.width = DimensionStyleValue.percent(CELL_TEXT_WIDTH_PERCENT);
		
	}

	/**
	 * Defines cell text Style
	 * 
	 * @param	domElement
	 */
	private static function setTextStyle(domElement:DOMElement):Void
	{
		domElement.style.display = DisplayStyleValue.block;
		domElement.style.color = ColorValue.hex('#202020');
		domElement.style.fontFamily =
			[
				FontFamilyStyleValue.familyName('Arial'),
				FontFamilyStyleValue.genericFamily(GenericFontFamilyValue.sansSerif)
			];
	}

	/**
	 * Defines cell title Style
	 * 
	 * @param	domElement
	 */
	public static function setTitleStyle(domElement:DOMElement,?screenResolutionSize:ScreenResolutionSize):Void
	{
		setTextStyle(domElement);
		
		if (screenResolutionSize == null)
			screenResolutionSize = ScreenResolutionSize.small;
		
		var fontSize:Int = 14;
		if (screenResolutionSize == ScreenResolutionSize.small) fontSize = 14;
		else if (screenResolutionSize == ScreenResolutionSize.normal) fontSize = 16;
		else  fontSize = 18;
		
		domElement.style.fontSize = FontSizeStyleValue.length(px(fontSize));
		//domElement.style.fontWeight = FontWeightStyleValue.bold;
	}

	/**
	 * Defines cell comment Style
	 * 
	 * @param	domElement
	 */
	public static function setAuthorStyle(domElement:DOMElement,?screenResolutionSize:ScreenResolutionSize):Void
	{
		setTextStyle(domElement);

		var fontSize:Int = 10;
		if (screenResolutionSize == ScreenResolutionSize.small) fontSize = 10;
		else if (screenResolutionSize == ScreenResolutionSize.normal) fontSize = 11;
		else  fontSize = 12;
		
		domElement.style.fontSize = FontSizeStyleValue.length(px(fontSize));
		domElement.style.fontWeight = FontWeightStyleValue.normal;
	}
	
	/**
	 * Defines cell line Style
	 * 
	 * @param	domElement
	 */
	public static function setLineStyle(domElement:DOMElement):Void
	{
		domElement.style.display = DisplayStyleValue.block;
		domElement.style.position = PositionStyleValue.relative;

		domElement.style.width = DimensionStyleValue.percent(100);
		domElement.style.height = DimensionStyleValue.length(px(1));
		domElement.style.marginTop = MarginStyleValue.length(px(CELL_VERTICAL_SPACE));	
	}
	
}
