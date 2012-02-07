package cocktailCore.background;
import cocktail.geom.Matrix;
import cocktail.nativeElement.NativeElement;
import cocktail.nativeElement.NativeElementManager;
import cocktail.nativeElement.NativeElementData;
import cocktailCore.drawing.DrawingManager;
import cocktail.geom.GeomData;
import cocktail.unit.UnitData;
import cocktail.style.StyleData;
import cocktailCore.resource.ImageLoader;
import cocktail.domElement.DOMElementData;
import cocktailCore.unit.UnitManager;
import haxe.Log;

/**
 * ...
 * @author Yannick DOMINGUEZ
 */

class BackgroundDrawingManager extends DrawingManager
{
	
	private var _imageLoader:ImageLoader;
	
	public function new(nativeElement:NativeElement, backgroundBox:RectangleData) 
	{
		super(nativeElement, Math.round(backgroundBox.width), Math.round(backgroundBox.height));
	}
	
	public function drawBackgroundImage(nativeImage:NativeElement, backgroundPositioningBox:RectangleData, backgroundPaintingBox:RectangleData, intrinsicWidth:Int, intrinsicHeight:Int, intrinsicRatio:Float, computedBackgroundSize:DimensionData, computedBackgroundPosition:PointData, backgroundRepeat:BackgroundRepeatStyleData):Void
	{
		
		var totalWidth:Int;
		var maxWidth:Int;
		var imageWidth:Int;
		var initialWidth:Int;
		
		switch (backgroundRepeat.x)
		{
			case BackgroundRepeatStyleValue.noRepeat:
				imageWidth = Math.round(computedBackgroundSize.width);
				totalWidth = Math.round(computedBackgroundPosition.x) +  Math.round(backgroundPositioningBox.x);
				initialWidth = totalWidth;
				maxWidth = totalWidth + imageWidth;
				
			case BackgroundRepeatStyleValue.repeat:
				imageWidth = computedBackgroundSize.width;
				totalWidth = Math.round(computedBackgroundPosition.x)  + Math.round(backgroundPositioningBox.x);
				while (totalWidth > backgroundPaintingBox.x)
				{
					totalWidth -= imageWidth;
				}
				initialWidth = totalWidth;
				maxWidth = Math.round(backgroundPaintingBox.x + backgroundPaintingBox.width);
				
			case BackgroundRepeatStyleValue.space:
				imageWidth = Math.round(backgroundPositioningBox.width / computedBackgroundSize.width);
				totalWidth = Math.round(computedBackgroundPosition.x) + Math.round(backgroundPositioningBox.x);
				while (totalWidth > backgroundPaintingBox.x)
				{
					totalWidth -= imageWidth;
				}
				initialWidth = totalWidth;
				maxWidth = Math.round(backgroundPaintingBox.x + backgroundPaintingBox.width);
				
			case BackgroundRepeatStyleValue.round:
				imageWidth = computedBackgroundSize.width;
				totalWidth = Math.round(computedBackgroundPosition.x) + Math.round(backgroundPositioningBox.x);
				while (totalWidth > backgroundPaintingBox.x)
				{
					totalWidth -= imageWidth;
				}
				initialWidth = totalWidth;
				maxWidth = Math.round(backgroundPaintingBox.x + backgroundPaintingBox.width);
		}
		
		var totalHeight:Float;
		var maxHeight:Float;
		var imageHeight:Float;
		var initialHeight:Float;
		
		switch (backgroundRepeat.y)
		{
			case BackgroundRepeatStyleValue.noRepeat:
				imageHeight = computedBackgroundSize.height;
				totalHeight = computedBackgroundPosition.y + Math.round(backgroundPositioningBox.y);
				initialHeight = totalHeight;
				maxHeight = totalHeight + imageHeight;
				
			case BackgroundRepeatStyleValue.repeat:
				imageHeight = computedBackgroundSize.height;
				totalHeight = computedBackgroundPosition.y + Math.round(backgroundPositioningBox.y);
				while (totalHeight > backgroundPaintingBox.y)
				{
					totalHeight -= imageHeight;
				}
				initialHeight = totalHeight;
				maxHeight = backgroundPaintingBox.y + backgroundPaintingBox.height;
				
			case BackgroundRepeatStyleValue.space:
				imageHeight = backgroundPositioningBox.height / computedBackgroundSize.height;
				totalHeight = computedBackgroundPosition.y + Math.round(backgroundPositioningBox.y);
				while (totalHeight > backgroundPaintingBox.y)
				{
					totalHeight -= imageHeight;
				}
				initialHeight = totalHeight;
				maxHeight = backgroundPaintingBox.y + backgroundPaintingBox.height;
				
			case BackgroundRepeatStyleValue.round:
				imageHeight = computedBackgroundSize.height;
				totalHeight = computedBackgroundPosition.y + Math.round(backgroundPositioningBox.y);
				while (totalHeight > backgroundPaintingBox.y)
				{
					totalHeight -= imageHeight;
				}
				initialHeight = totalHeight;
				maxHeight = backgroundPaintingBox.y + backgroundPaintingBox.height;
		}
		
		while (totalHeight < maxHeight)
		{
			var matrix:Matrix = new Matrix();
		
			
			matrix.translate(totalWidth, totalHeight);
			
			matrix.scale(imageWidth / intrinsicWidth ,  imageHeight / intrinsicHeight, { x:0.0, y:0.0 } );
			
			drawImage(nativeImage, matrix, backgroundPaintingBox);
			
			totalWidth += imageWidth;
			
			if (totalWidth >= maxWidth)
			{
				totalWidth = initialWidth;
				totalHeight += imageHeight;
			}
		}
	}
	
	public function drawBackgroundColor(color:ColorData, backgroundPaintingBox:RectangleData):Void
	{
		var fillStyle:FillStyleValue = FillStyleValue.monochrome( color );
		var lineStyle:LineStyleValue = LineStyleValue.none;
		
		beginFill(fillStyle, lineStyle);
		drawRect(Math.round(backgroundPaintingBox.x), Math.round(backgroundPaintingBox.y), Math.round(backgroundPaintingBox.width), Math.round(backgroundPaintingBox.height));
		
		endFill();
	}
	
	public function drawBackgroundGradient(gradient:GradientValue, backgroundPositioningBox:RectangleData, backgroundPaintingBox:RectangleData, computedBackgroundSize:DimensionData, computedBackgroundPosition:PointData, backgroundRepeat:BackgroundRepeatStyleData):Void
	{
		var gradientSurface:DrawingManager = new DrawingManager(NativeElementManager.createNativeElement(NativeElementTypeValue.graphic), computedBackgroundSize.width, computedBackgroundSize.height);
		
		var fillStyle:FillStyleValue;
		var lineStyle = LineStyleValue.none;
		
		switch(gradient)
		{
			case GradientValue.linear(value):
				var gradientStyle:GradientStyleData = {
					gradientType:GradientTypeValue.linear,
					gradientStops:getGradientStops(value.colorStops),
					rotation:getRotation(value.angle)
				}
				fillStyle = FillStyleValue.gradient(gradientStyle);
		}
		
		gradientSurface.beginFill(fillStyle, lineStyle);
		gradientSurface.drawRect(0, 0, computedBackgroundSize.width, computedBackgroundSize.height);
		gradientSurface.endFill();
		
		drawBackgroundImage(gradientSurface.nativeElement, backgroundPositioningBox, backgroundPaintingBox, computedBackgroundSize.width, computedBackgroundSize.height, computedBackgroundSize.width / computedBackgroundSize.height, computedBackgroundSize, computedBackgroundPosition, backgroundRepeat);
		
		
	}
	
	private function getGradientStops(value:Array<GradientColorStopData>):Array<GradientStopData>
	{
		var gradientStopsData:Array<GradientStopData> = new Array<GradientStopData>();
		
		for (i in 0...value.length)
		{
			var ratio:Int;
	
			switch (value[i].stop)
			{
				case GradientStopValue.length(value):
					//TODO
					ratio = 0;
					
				case GradientStopValue.percent(value):
					ratio = value;
			}
			
			var color:ColorData = UnitManager.getColorDataFromColorValue(value[i].color);
			gradientStopsData.push( { colorStop:color, ratio:ratio } );
		}
		
		return gradientStopsData;
	}
		
	
	private function getRotation(value:GradientAngleValue):Int
	{
		var rotation:Int;
		
		switch (value)
		{
			case GradientAngleValue.angle(value):
				rotation = Math.round(UnitManager.getDegreeFromAngleValue(value));
				
			case GradientAngleValue.side(value):
			
				switch (value)
				{
					case GradientSideValue.top:
						rotation = 0;
						
					case GradientSideValue.right:
						rotation = 90;
						
					case GradientSideValue.bottom:
						rotation = 180;
						
					case GradientSideValue.left:
						rotation = 270;
				}
			
			
			case GradientAngleValue.corner(value):
			
				switch (value)
				{
					case GradientCornerValue.topRight:
						rotation = 45;
						
					case GradientCornerValue.bottomRight:
						rotation = 135;
						
					case GradientCornerValue.bottomLeft:
						rotation = 225;
						
					case GradientCornerValue.topLeft:
						rotation = 315;
				}
			
		}
		
		return rotation;
	}
	
}