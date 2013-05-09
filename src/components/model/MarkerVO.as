package components.model {
    import flash.geom.Point;

    /**
     *
     * @author maciek grzybowski, 27.04.2013 13:53
     *
     */
    public class MarkerVO {

        public static var uid:int = 0;

        [Bindable]
        public var name:String;

        [Bindable]
        public var color:uint;

        [Bindable]
        public var position:Point;

        public function MarkerVO() {
            position = new Point();
            name = "#"+String(uid++);
        }

        public function withName(value:String):MarkerVO {
            name = value;
            return this;
        }

        public function withPosition(x:int, y:int):MarkerVO {
            position.setTo(x, y);
            return this;
        }

        public function withColor(value:uint):MarkerVO {
            color = value;
            return this;
        }
    }
}
