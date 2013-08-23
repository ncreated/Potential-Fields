package {

    import com.ncreated.ds.potentialfields.PFAgent;
    import com.ncreated.ds.potentialfields.PFDynamicPotentialsMap;
    import com.ncreated.ds.potentialfields.PFPotentialField;
    import com.ncreated.ds.potentialfields.PFRadialPotentialField;
    import com.ncreated.ds.potentialfields.PFRectangularPotentialField;
    import com.ncreated.ds.potentialfields.PFStaticPotentialsMap;

    import flash.display.Bitmap;

    import flash.display.BitmapData;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;


    [SWF(width='400', height='300', backgroundColor='#ffffff', frameRate='30')]
    public class BasicBehaviors extends Sprite {

        private static const TILE_SIZE:int = 4;                 // grid size in pixels

        private var _obstaclesPotentialsMap:PFStaticPotentialsMap;
        private var _mousePotentialMap:PFDynamicPotentialsMap;
        private var _agentsPotentialsMap:PFDynamicPotentialsMap;

        private var _mousePotential:PFRadialPotentialField;
        private var _dynamicPotentialsBitmap:Bitmap;

        private var _agents:Vector.<PFAgent>;
        private var _counter:int = 0;

        public function BasicBehaviors() {
            addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
        }

        private function get mapTilesWidth():int {
            return Math.ceil(stage.stageWidth / TILE_SIZE);
        }

        private function get mapTilesHeight():int {
            return Math.ceil(stage.stageHeight / TILE_SIZE);
        }

        private function init(event:Event):void {
            stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
            stage.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);

            /* Create static map for obstacles. */
            _obstaclesPotentialsMap = new PFStaticPotentialsMap(mapTilesWidth, mapTilesHeight);

            /* Put random potential fields (obstacles) on the map. */
            for (var i:int = 0; i < 6; i++) {
                var field:PFRectangularPotentialField = new PFRectangularPotentialField(
                        Math.random() * 2 + 1,
                        Math.random() * 2 + 1
                );
                field.type = PFPotentialField.PF_TYPE_REPEL;
                field.position.x = mapTilesWidth * Math.random();
                field.position.y = mapTilesHeight * Math.random();
                field.potential = 100;
                field.gradation = 30;
                _obstaclesPotentialsMap.addPotentialField(field);
            }

            /* Draw obstacles map into bitmap (for debug purposes). */
            var data:BitmapData = new BitmapData(mapTilesWidth, mapTilesHeight, false);
            _obstaclesPotentialsMap.debugCreatePotentialsSnapshot();
            _obstaclesPotentialsMap.debugDrawPotentialsSnapshot(data);

            var staticPotentialsBitmap:Bitmap = new Bitmap(data);
            staticPotentialsBitmap.scaleX = stage.stageWidth / staticPotentialsBitmap.width;
            staticPotentialsBitmap.scaleY = stage.stageHeight / staticPotentialsBitmap.height;
            addChild(staticPotentialsBitmap);

            /* Create dynamic map for mouse potential. */
            _mousePotentialMap = new PFDynamicPotentialsMap(mapTilesWidth, mapTilesHeight);

            /* Create mouse potential. */
            _mousePotential = new PFRadialPotentialField();
            _mousePotential.type = PFPotentialField.PF_TYPE_ATTRACT;
            _mousePotential.potential = 300;
            _mousePotential.gradation = 15;
            _mousePotentialMap.addPotentialField(_mousePotential);

            /* Draw mouse map into bitmap (again, for debug purposes). */
            data = new BitmapData(mapTilesWidth, mapTilesHeight);
            _dynamicPotentialsBitmap = new Bitmap(data);
            _dynamicPotentialsBitmap.scaleX = stage.stageWidth / _dynamicPotentialsBitmap.width;
            _dynamicPotentialsBitmap.scaleY = stage.stageHeight / _dynamicPotentialsBitmap.height;
            addChild(_dynamicPotentialsBitmap);

            /* Create dynamic potentials map for agent's collisions. */
            _agentsPotentialsMap = new PFDynamicPotentialsMap(mapTilesWidth, mapTilesHeight);

            /* Create agents. */
            _agents = new Vector.<PFAgent>();
            for (i = 0; i < 5; i++) {
                var agent:PFAgent = new PFAgent();
                agent.type = PFPotentialField.PF_TYPE_REPEL;
                agent.potential = 60;
                agent.gradation = 10;
                agent.position.setTo(40, 40);
                agent.addStaticPotentialsMap(_obstaclesPotentialsMap);
                agent.addDynamicPotentialsMap(_agentsPotentialsMap);//
                agent.addDynamicPotentialsMap(_mousePotentialMap);
                _agentsPotentialsMap.addPotentialField(agent);
                _agents.push(agent);
            }
        }

        private function onEnterFrame(event:Event):void {
            /* Update mouse potential position. */
            _mousePotential.position.x = Math.floor((stage.mouseX / stage.stageWidth) * _mousePotentialMap.tilesWidth);
            _mousePotential.position.y = Math.floor((stage.mouseY / stage.stageHeight) * _mousePotentialMap.tilesHeight);

            /* Update agents positions. */
            if (_counter++ % 4 == 0) {
                for (var i:int = 0; i < _agents.length; i++) {
                    _agents[i].moveToPositionPoint(_agents[i].nextPosition());
                }
            }

            // Debug draws:

            /* Draw mouse potential. */
            _dynamicPotentialsBitmap.bitmapData.fillRect(_dynamicPotentialsBitmap.bitmapData.rect, 0x00FA00);// reset color
            _mousePotentialMap.debugDrawPotentials(_dynamicPotentialsBitmap.bitmapData);

            /* Draw agents potentials into the same bitmap. */
            _agentsPotentialsMap.debugDrawPotentials(_dynamicPotentialsBitmap.bitmapData);

            /* Draw agents' positions. */
            _agentsPotentialsMap.debugDrawAgents(_dynamicPotentialsBitmap.bitmapData);
        }

        private function onMouseClick(event:MouseEvent):void {
            /* Toggle between PFPotentialField.PF_TYPE_REPEL and PFPotentialField.PF_TYPE_ATTRACT. */
            _mousePotential.type *= -1;
        }
    }
}