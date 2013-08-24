package {
    import com.ncreated.lists.BasicLinkedListNode;

    import flash.display.Sprite;

    /**
     *
     * @author maciek grzybowski, 24.08.2013 17:37
     *
     */
    public class Bullet extends BasicLinkedListNode {

        public static const SPEED:Number = 300;// pixels per second

        public var team:int;
        public var sprite:Sprite;

        public var vx:Number;
        public var vy:Number;
        public var lifetime:Number;

        public var isAlive:Boolean;

        public function Bullet() {
            lifetime = 0.5;
        }

        public function update(dt:Number):void {
            sprite.x += dt * vx;
            sprite.y += dt * vy;
            lifetime -= dt;
            isAlive = lifetime > 0;
        }
    }
}
