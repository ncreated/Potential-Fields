package com.ncreated.ds.potentialfields {
    import com.ncreated.lists.BasicLinkedList;
    import com.ncreated.lists.BasicLinkedListNode;

    import flash.geom.Point;

    import flash.geom.Point;

    /**
     *
     * @author maciek grzybowski, 05.03.2013 23:26
     *
     */
    public class PFAgent extends PFRadialPotentialField {

        public static const MAX_TRAIL_LENGTH:int = 14;

        /**
         * Czy ma odejmowac swoj wlasny potencjal od wypadkowego potencjalu map dynamicznych.
         * Wartosc domyslna: true.
         */
        public var subtractSelfPotentialFromDynamicsMapSum:Boolean;

        private var _cachedPoint:Point;
        private var _mapTilesWidth:int;
        private var _mapTilesHeight:int;

        private var _staticPotentialsMaps:Vector.<PFStaticPotentialsMap>;           // lazy initialized
        private var _dynamicPotentialsMaps:Vector.<PFDynamicPotentialsMap>;         // lazy initialized
        private var _staticPotentialsMapsEnabe:Vector.<Boolean>;
        private var _dynamicPotentialsMapsEnabe:Vector.<Boolean>;
        private var _trails:BasicLinkedList;

        /**
         * Readonly! Do ustawienia trailLength powinna byc uzywana metoda setTrailLength().
         * Ze wzgledow optymalizacyjnych nie ma tu gettera/settera.
         */
        public var trailLength:int = MAX_TRAIL_LENGTH;

        public var debugDrawColor:uint;

        public function PFAgent(static_potentials_map:Vector.<PFStaticPotentialsMap> = null, dynamic_potentials_map:Vector.<PFDynamicPotentialsMap> = null,
                                subtract_self_potential_from_dynamic_maps_sum:Boolean = true) {
            super();
            _cachedPoint = new Point();
            _mapTilesWidth = (static_potentials_map)?static_potentials_map[0].tilesWidth:0;
            _mapTilesHeight = (static_potentials_map)?static_potentials_map[0].tilesHeight:0;
            _staticPotentialsMaps = static_potentials_map;
            _dynamicPotentialsMaps = dynamic_potentials_map;
            _trails = new BasicLinkedList();
            subtractSelfPotentialFromDynamicsMapSum = subtract_self_potential_from_dynamic_maps_sum;

            debugDrawColor = 0xFF000000;
        }

        public function addStaticPotentialsMap(value:PFStaticPotentialsMap):void {
            if (_mapTilesWidth > 0 && _mapTilesHeight > 0) {
                if (_mapTilesWidth != value.tilesWidth || _mapTilesHeight != value.tilesHeight)
                    throw new Error("All potentials maps should have the same tilesWidth and tilesHeight!");
            }
            else {
                _mapTilesWidth = value.tilesWidth;
                _mapTilesHeight = value.tilesHeight;
            }

            if (!_staticPotentialsMaps) {
                _staticPotentialsMaps = new Vector.<PFStaticPotentialsMap>();
                _staticPotentialsMapsEnabe = new Vector.<Boolean>();
            }
            _staticPotentialsMaps.push(value);
            _staticPotentialsMapsEnabe.push(true);
        }

        public function removeAllStaticPotentialsMaps():void {
            _staticPotentialsMaps = null;
            _staticPotentialsMapsEnabe = null;
            if (!_dynamicPotentialsMaps) _mapTilesWidth = _mapTilesHeight = 0;
        }

        public function addDynamicPotentialsMap(value:PFDynamicPotentialsMap):void {
            if (_mapTilesWidth > 0 && _mapTilesHeight > 0) {
                if (_mapTilesWidth != value.tilesWidth || _mapTilesHeight != value.tilesHeight)
                    throw new Error("All potentials maps should have the same tilesWidth and tilesHeight!");
            }
            else {
                _mapTilesWidth = value.tilesWidth;
                _mapTilesHeight = value.tilesHeight;
            }

            if (!_dynamicPotentialsMaps) {
                _dynamicPotentialsMaps = new Vector.<PFDynamicPotentialsMap>();
                _dynamicPotentialsMapsEnabe = new Vector.<Boolean>();
            }
            _dynamicPotentialsMaps.push(value);
            _dynamicPotentialsMapsEnabe.push(true);
        }

        public function removeAllDynamicPotentialsMaps():void {
            _dynamicPotentialsMaps = null;
            _dynamicPotentialsMapsEnabe = null;
            if (!_staticPotentialsMaps) _mapTilesWidth = _mapTilesHeight = 0;
        }

        public function get staticPotentialsMaps():Vector.<PFStaticPotentialsMap> {
            return _staticPotentialsMaps;
        }

        public function get dynamicPotentialsMaps():Vector.<PFDynamicPotentialsMap> {
            return _dynamicPotentialsMaps;
        }

        public function enableStaticPotentialMap(map_index:int, enabled:Boolean):void {
            if (_staticPotentialsMaps)
                _staticPotentialsMapsEnabe[map_index] = enabled;
        }

        public function enableDynamicPotentialMap(map_index:int, enabled:Boolean):void {
            if (_dynamicPotentialsMaps)
                _dynamicPotentialsMapsEnabe[map_index] = enabled;
        }

        public function isStaticPotentialMapEnabled(map_index:int):Boolean {
            return _staticPotentialsMapsEnabe[map_index];
        }

        public function isDynamicPotentialMapEnabled(map_index:int):Boolean {
            return _dynamicPotentialsMapsEnabe[map_index];
        }

        /**
         * Zwraca wartosc potencjalu generowanego przez tego agenta w zadanym punkcie mapy.
         * @param map_x
         * @param map_y
         * @return
         */
        public function getPotential(map_x:int, map_y:int):int {
            return getLocalPotential(map_x - position.x,  map_y - position.y);
        }

        private function getTrailPotential(map_x:int, map_y:int):int {
            var potential:int = 0;
            for (var trail:BasicLinkedListNode = _trails.head; trail; trail = trail.next) {
                if (PFAgentTrail(trail).worldX == map_x && PFAgentTrail(trail).worldY == map_y) {
                    potential += PFAgentTrail(trail).potential;
                }
            }
            return potential;
        }

        private function staticPotentialsSum(map_x:int, map_y:int):int {
            var sum:int = 0;
            var len:int = _staticPotentialsMaps.length;
            for (var i:int = 0; i < len; i++) {
                if (_staticPotentialsMapsEnabe[i]) {
                    sum += _staticPotentialsMaps[i].getPotential(map_x, map_y);
                }
            }
            return sum;
        }

        private function dynamicPotentialsSum(map_x:int, map_y:int):int {
            var sum:int = 0;
            var len:int = _dynamicPotentialsMaps.length;
            for (var i:int = 0; i < len; i++) {
                if (_dynamicPotentialsMapsEnabe[i]) {
                    sum += _dynamicPotentialsMaps[i].getPotential(map_x, map_y);
                }
            }
            return sum;
        }

        /**
         * Przesuwa agenta na jeden z 8 otaczjacych go obszarow (lub pozostaje na swoim dotychczasowym) w kierunku najwiekszego potencjalu przyciagajacego.
         * Wybierany jest pierwszy znaleziony kafelek z najlepszym potencjalem przyciagajacym. Kolejnosc przeszukiwania kafelkow
         * moze byc okreslana parametrami x_order i y_order.
         * @param agent
         * @param x_order kolejnosc przeszukiwania kafelkow w X (1 -> najpierw po prawej, -1 -> najpierw po lewej)
         * @param y_order kolejnosc przeszukiwania kafelkow w Y (1 -> najpierw na gorze, -1 -> najpierw na dole)
         * @return
         */
        public function nextPosition(x_order:int = 1, y_order:int = 1):Point {
            _cachedPoint.setTo(position.x, position.y);

            var staticPotential:int = staticPotentialsSum(position.x, position.y);
            var agentsPotential:int = dynamicPotentialsSum(position.x, position.y);
            var selfPotential:int = getPotential(position.x, position.y);
            var trailPotential:int = getTrailPotential(position.x, position.y);

            var bestAttractPotential:int = staticPotential + agentsPotential - (subtractSelfPotentialFromDynamicsMapSum?selfPotential:0) + trailPotential;

            for (var x:int = -1; x <= 1; x++) {
                var xx:int = position.x + x * x_order;
                if (xx >= 0 && xx < _mapTilesWidth) {

                    for (var y:int = -1; y <= 1; y++) {
                        if (x == 0 && y == 0) {
                            continue;
                        }

                        var yy:int = position.y + y * y_order;
                        if (yy >= 0 && yy < _mapTilesHeight) {
                            var comparingPotential:int = staticPotentialsSum(xx, yy) + dynamicPotentialsSum(xx, yy) - (subtractSelfPotentialFromDynamicsMapSum?getPotential(xx, yy):0) + getTrailPotential(xx, yy);

                            if (comparingPotential < bestAttractPotential) {
                                bestAttractPotential = comparingPotential;
                                _cachedPoint.setTo(xx, yy);
                            }
                        }
                    }
                }
            }

            if (_cachedPoint.x == position.x && _cachedPoint.y == position.y) {
                if (_trails.length > trailLength) {// zapewnia stala dlugosc listy sladow i reuzywa ponownie starego sladu
                    var recycledTrail:PFAgentTrail = PFAgentTrail(_trails.head);
                    _trails.removeNode(recycledTrail);// usuwa go z poczatku listy
                    recycledTrail.worldX = position.x;
                    recycledTrail.worldY = position.y;
                    _trails.appendNode(recycledTrail);// dodaje go na koniec listy
                }
                else {
                    _trails.appendNode(new PFAgentTrail(position.x, position.y, type * potential));
                }
                _cachedPoint.setTo(position.x,  position.y);
            }
            return _cachedPoint;
        }

        public function setTrailLength(value:int):void {
            while (value < _trails.length) {
                _trails.fetchHead();
            }
            trailLength = value;
        }

        public function moveToPositionPoint(p:Point):void {
            moveToPosition(p.x,  p.y);
        }

        public function moveToPosition(new_x:int, new_y:int):void {
            position.x = new_x;
            position.y = new_y;
        }
    }
}


import com.ncreated.lists.BasicLinkedListNode;

/**
 *
 * @author maciek grzybowski, 09.03.2013 16:53
 *
 */
internal class PFAgentTrail extends BasicLinkedListNode {

    public var worldX:int;
    public var worldY:int;
    public var potential:int;

    public function PFAgentTrail(world_x:int, world_y:int, potential:int) {
        this.worldX = world_x;
        this.worldY = world_y;
        this.potential = potential;
    }
}