package {
    import com.ncreated.ds.potentialfields.PFAgent;
    import com.ncreated.ds.potentialfields.PFDynamicPotentialsMap;
    import com.ncreated.ds.potentialfields.PFPotentialField;
    import com.ncreated.ds.potentialfields.PFRadialPotentialField;

    import flash.display.Bitmap;
    import flash.display.BitmapData;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    /**
     * Demo: basic usage of potential fields library.
     *
     * @author maciek grzybowski, 23.08.2013 03:29
     *
     */
    [SWF(width='400', height='300', backgroundColor='#ffffff', frameRate='10')]
    public class HelloPotentials extends Sprite {

        private var _debugBitmap:Bitmap;

        private var _map:PFDynamicPotentialsMap;
        private var _field:PFRadialPotentialField;
        private var _agent:PFAgent;

        public function HelloPotentials() {
            addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
        }

        private function init(event:Event):void {
            stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
            stage.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);

            const TILE_SIZE:int = 4;
            const MAP_WIDTH:int =  Math.ceil(stage.stageWidth / TILE_SIZE);
            const MAP_HEIGHT:int = Math.ceil(stage.stageHeight / TILE_SIZE);

            /* Create potentials map. */
            _map = new PFDynamicPotentialsMap(MAP_WIDTH, MAP_HEIGHT);

            /* Create attracting potential field. */
            _field = new PFRadialPotentialField();
            _field.potential = 250;
            _field.gradation = 5;
            _field.position.setTo(MAP_WIDTH * 0.5, MAP_HEIGHT * 0.5);
            _field.type = PFPotentialField.PF_TYPE_ATTRACT;

            /* Add field to the map. */
            _map.addPotentialField(_field);

            /* Create an agent. */
            _agent = new PFAgent();
            _agent.position.setTo(80, 50);

            /* Add map to the agent (let him move on it!). */
            _agent.addDynamicPotentialsMap(_map);

            // Just for debug purposes:

            /* Create debug bitmap. */
            _debugBitmap = new Bitmap(new BitmapData(MAP_WIDTH, MAP_HEIGHT));
            _debugBitmap.scaleX = stage.stageWidth / MAP_WIDTH;
            _debugBitmap.scaleY = stage.stageHeight/ MAP_HEIGHT;
            addChild(_debugBitmap);
        }

        private function onEnterFrame(event:Event):void {
            /* Move an agent. */
            if (_agent) {
                _agent.moveToPositionPoint(_agent.nextPosition());
            }

            // Just for debug purposes:

            /* Clear debug drawing. */
            _debugBitmap.bitmapData.fillRect(_debugBitmap.bitmapData.rect, 0xFFFFFF);

            /* Draw map's potentials. */
            _map.debugDrawPotentials(_debugBitmap.bitmapData);

            /* Draw agent's position. */
            _debugBitmap.bitmapData.setPixel32(_agent.position.x, _agent.position.y, 0xFF0000FF);
        }

        private function onMouseClick(event:MouseEvent):void {
            /* Reset agent position to mouse position. */
            _agent.position.setTo(
                    (stage.mouseX / stage.stageWidth) * _debugBitmap.bitmapData.width,
                    (stage.mouseY / stage.stageHeight) * _debugBitmap.bitmapData.height
            );
        }
    }
}
