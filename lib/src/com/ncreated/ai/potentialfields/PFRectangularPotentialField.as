package com.ncreated.ai.potentialfields {

    /**
     * Pole potencjalu, ktore posiada maksymalny potencjal w zadanym prostokacie. Poza granicami tego prostokata
     * potencjal ulega stopniowej gradacji o wartosc _gradation.
     * @author maciek grzybowski, 28.03.2013 00:57
     *
     */
    public class PFRectangularPotentialField extends PFPotentialField {

        /** Wartosc potencjalu wewnatrz prostokata. */
        private var _potential:int;

        /** Gradacja potencjalu poza granicami prostokata. */
        private var _gradation:int;

        private var _maxPotentialHalfWidth:int;
        private var _maxPotentialHalfHeight:int;

        private var _boundsHalfWidth:int;
        private var _boundsHalfHeight:int;

        public function PFRectangularPotentialField(max_potential_half_width:int, max_potential_half_height:int) {
            super();
            _potential = 1;
            _gradation = 1;
            _maxPotentialHalfWidth = max_potential_half_width;
            _maxPotentialHalfHeight = max_potential_half_height;
            updateBounds();
        }

        public function set maxPotentialHalfWidth(value:int):void {
            _maxPotentialHalfWidth = value;
            updateBounds();
        }

        public function get maxPotentialHalfWidth():int {
            return _maxPotentialHalfWidth;
        }

        public function set maxPotentialHalfHeight(value:int):void {
            _maxPotentialHalfHeight = value;
            updateBounds();
        }

        public function get maxPotentialHalfHeight():int {
            return _maxPotentialHalfHeight;
        }

        public function set potential(value:int):void {
            _potential = value;
            updateBounds();
        }

        public function set gradation(value:int):void {
            _gradation = value;
            updateBounds();
        }

        public function get potential():int {
            return _potential;
        }

        public function get gradation():int {
            return _gradation;
        }

        override public function get potentialBoundsHalfWidth():int {
            return _boundsHalfWidth;
        }

        override public function get potentialBoundsHalfHeight():int {
            return _boundsHalfHeight;
        }

        override public function getLocalPotential(local_x:int, local_y:int):int {
            if (Math.abs(local_x) < _maxPotentialHalfWidth && Math.abs(local_y) < _maxPotentialHalfHeight) return type * _potential;

            if (Math.abs(local_x) < _boundsHalfWidth && Math.abs(local_y) < _boundsHalfHeight) {

                var distance:int;

                if (Math.abs(local_x) > _maxPotentialHalfWidth && Math.abs(local_y) > _maxPotentialHalfHeight) {
                    distance = Math.abs(local_x) - _maxPotentialHalfWidth + Math.abs(local_y) - _maxPotentialHalfHeight;
                }
                else if (Math.abs(local_x) > _maxPotentialHalfWidth) {
                    distance = Math.abs(local_x) - _maxPotentialHalfWidth;
                }
                else if (Math.abs(local_y) > _maxPotentialHalfHeight) {
                    distance = Math.abs(local_y) - _maxPotentialHalfHeight;
                }

                if (type < 0) {
                    return Math.min(0, type * (_potential - _gradation * distance) );
                }
                return Math.max(0, type * (_potential - _gradation * distance) );
            }

            return 0;
        }

        private function updateBounds():void {
            _boundsHalfWidth = _maxPotentialHalfWidth + Math.ceil(_potential / _gradation) - 1;
            _boundsHalfHeight = _maxPotentialHalfHeight + Math.ceil(_potential / _gradation) - 1;
        }
    }
}
