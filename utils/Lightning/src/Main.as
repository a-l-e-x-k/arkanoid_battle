/**
 * Author: Alexey
 * Date: 7/27/12
 * Time: 1:48 AM
 */
package
{
import flash.display.Sprite;
import flash.geom.Point;

[SWF(width="774", height="680", backgroundColor="0", frameRate="30")]
public class Main extends Sprite
{
	public function Main()
	{
		var ball:Sprite = new Sprite();
		ball.graphics.beginFill(0xFF0000);
		ball.graphics.drawCircle(0, 0, 10);
		ball.graphics.endFill();
		ball.x = 50;
		ball.y = 50;
		addChild(ball);

		var ball2:Sprite = new Sprite();
		ball2.graphics.beginFill(0xFF0000);
		ball2.graphics.drawCircle(0, 0, 10);
		ball2.graphics.endFill();
		ball2.x = 724;
		ball2.y = 50;
		addChild(ball2);

		var ball3:Sprite = new Sprite();
		ball3.graphics.beginFill(0xFF0000);
		ball3.graphics.drawCircle(0, 0, 10);
		ball3.graphics.endFill();
		ball3.x = 387;
		ball3.y = 630;
		addChild(ball3);

		var lg:LightningGroup = new LightningGroup(387, 340, [new Point(ball.x,  ball.y), new Point(ball2.x,  ball2.y), new Point(ball3.x,  ball3.y)]);
		addChild(lg);
	}
}
}
