package components {
    import com.ncreated.ds.potentialfields.PFAgent;
    import com.ncreated.ds.potentialfields.PFDynamicPotentialsMap;
    import com.ncreated.ds.potentialfields.PFPotentialField;
    import com.ncreated.ds.potentialfields.PFStaticPotentialsMap;

    import components.model.AgentVO;
    import components.model.MarkerVO;

    import components.model.PotentialFieldVO;

    import components.model.PotentialFieldVO;

    import flash.display.Bitmap;
    import flash.display.BitmapData;

    import mx.collections.ArrayCollection;

    /**
     *
     * @author maciek grzybowski, 13.04.2013 00:48
     *
     */
    public class MapComponent {

        [Bindable]
        public var staticMapFields:ArrayCollection;

        [Bindable]
        public var agents:ArrayCollection;

        [Bindable]
        public var markers:ArrayCollection;

        [Bindable]
        public var staticPotentialsMapBitmap:Bitmap;

        [Bindable]
        public var agentsPotentialsBitmap:Bitmap;

        [Bindable]
        public var agentsPositionsBitmap:Bitmap;

        [Bindable]
        public var markersBitmap:Bitmap;


        private var _staticMap:PFStaticPotentialsMap;
        private var _agentsPotentialsMap:PFDynamicPotentialsMap;

        public function MapComponent() {
            staticMapFields = new ArrayCollection();
            agents = new ArrayCollection();
            markers = new ArrayCollection();
        }

        public function createMap(width:int, height:int, map_bitmap:Bitmap, agents_potentials_bitmap:Bitmap, agents_positions_bitmap:Bitmap, markers_bitmap:Bitmap):void {
            _agentsPotentialsMap = new PFDynamicPotentialsMap(width, height);

            _staticMap = new PFStaticPotentialsMap(width, height);
            _staticMap.debugCreatePotentialsSnapshot();

            map_bitmap.bitmapData = new BitmapData(width, height, true, 0x00000000);
            staticPotentialsMapBitmap = map_bitmap;
            drawMap();

            agents_potentials_bitmap.bitmapData = new BitmapData(width, height, true, 0x00000000);
            agentsPotentialsBitmap = agents_potentials_bitmap;
            drawAgentsPotentials();

            agents_positions_bitmap.bitmapData = new BitmapData(width, height, true, 0x00000000);
            agentsPositionsBitmap = agents_positions_bitmap;
            drawAgentsPositions();

            markers_bitmap.bitmapData = new BitmapData(width, height, true, 0x00000000);
            markersBitmap = markers_bitmap;
            drawMarkers();
        }

        /*
            statyczne pola potencjalow
         */

        public function addPotentialField(vo:PotentialFieldVO,  store_on_list:Boolean = false):void {
            if (store_on_list) staticMapFields.addItem(vo);
            _staticMap.addPotentialField(vo.field);
            drawMap();
        }

        public function removePotentialFieldWithVO(vo:PotentialFieldVO, redraw_map:Boolean = true):void {
            staticMapFields.removeItemAt(staticMapFields.getItemIndex(vo));
            _staticMap.removePotentialField(vo.field);

            if (redraw_map) {
                drawMap();
            }
        }

        public function removeAllPotentialFields(redraw_map:Boolean = true):void {
            for (var i:int = 0; i < staticMapFields.length; i++) {
                _staticMap.removePotentialField(PotentialFieldVO(staticMapFields.getItemAt(i)).field);
            }
            staticMapFields.removeAll();

            if (redraw_map) {
                drawMap();
            }
        }

        public function updateStaticPotentialField(vo:PotentialFieldVO):void {
            _staticMap.debugCreatePotentialsSnapshot();
        }

        /*
            agenci
         */

        public function addAgent(vo:AgentVO, store_on_list:Boolean = false, redraw_map:Boolean = true):void {
            if (store_on_list) agents.addItem(vo);
            _agentsPotentialsMap.addPotentialField(vo.agent);

            vo.agent.addStaticPotentialsMap(_staticMap);
            vo.agent.addDynamicPotentialsMap(_agentsPotentialsMap);

            if (redraw_map) {
                drawAgentsPotentials();
                drawAgentsPositions();
            }
        }

        public function removeAgentWithVO(vo:AgentVO, redraw_map:Boolean = true):void {
            agents.removeItemAt(agents.getItemIndex(vo));
            _agentsPotentialsMap.removePotentialField(vo.agent);
            vo.agent.removeAllDynamicPotentialsMaps();
            vo.agent.removeAllStaticPotentialsMaps();

            if (redraw_map) {
                drawAgentsPotentials();
                drawAgentsPositions();
            }
        }

        public function removeAllAgents(redraw_map:Boolean = true):void {
            for (var i:int = 0; i < agents.length; i++) {
                _agentsPotentialsMap.removePotentialField(AgentVO(agents.getItemAt(i)).agent);
                AgentVO(agents.getItemAt(i)).agent.removeAllDynamicPotentialsMaps();
                AgentVO(agents.getItemAt(i)).agent.removeAllStaticPotentialsMaps();
            }
            agents.removeAll();

            if (redraw_map) {
                drawAgentsPotentials();
                drawAgentsPositions();
            }
        }

        /*
            agent's movement
         */

        public function moveAgents():void {
            for each (var vo:AgentVO in agents) {
                var agent:PFAgent = vo.agent;

                agent.moveToPositionPoint(agent.nextPosition());
            }
        }

        /*
         znaczniki
         */

        public function addMarker(vo:MarkerVO, store_on_list:Boolean = false):void {
            if (store_on_list) markers.addItem(vo);

            drawMarkers();
        }

        public function removeMarkerWithVO(vo:MarkerVO, redraw_map:Boolean = true):void {
            markers.removeItemAt(markers.getItemIndex(vo));

            if (redraw_map) {
                drawMarkers();
            }
        }

        public function removeAllMarkers(redraw_map:Boolean = true):void {
            markers.removeAll();

            if (redraw_map) {
                drawMarkers();
            }
        }

        /*
            rysowanie
         */

        public function drawMap():void {
            staticPotentialsMapBitmap.bitmapData.fillRect(staticPotentialsMapBitmap.bitmapData.rect, 0x00000000);
            _staticMap.debugDrawPotentialsSnapshot(staticPotentialsMapBitmap.bitmapData);
        }

        public function drawAgentsPotentials():void {
            agentsPotentialsBitmap.bitmapData.fillRect(agentsPotentialsBitmap.bitmapData.rect, 0x00000000);
            _agentsPotentialsMap.debugDrawPotentials(agentsPotentialsBitmap.bitmapData);
        }

        public function drawAgentsPositions():void {
            agentsPositionsBitmap.bitmapData.lock();
            agentsPositionsBitmap.bitmapData.fillRect(agentsPositionsBitmap.bitmapData.rect, 0x00000000);

            for each (var vo:AgentVO in agents) {
                agentsPositionsBitmap.bitmapData.setPixel32(vo.agent.position.x, vo.agent.position.y, (0xFF << 24) | vo.color);
            }

            agentsPositionsBitmap.bitmapData.unlock();
        }

        public function drawMarkers():void {
            markersBitmap.bitmapData.lock();
            markersBitmap.bitmapData.fillRect(markersBitmap.bitmapData.rect, 0x00000000);

            for each (var vo:MarkerVO in markers) {
                markersBitmap.bitmapData.setPixel32(vo.position.x, vo.position.y, (0xFF << 24) | vo.color);
            }

            markersBitmap.bitmapData.unlock();
        }
    }
}
