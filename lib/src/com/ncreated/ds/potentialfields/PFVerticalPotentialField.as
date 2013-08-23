package com.ncreated.ds.potentialfields {

    /**
     *
     * @author maciek grzybowski, 29.03.2013 00:06
     *
     */
    public class PFVerticalPotentialField extends PFPotentialField {

        /** Wartosc potencjalu na pionowej osi symetrii pola. */
        private var _potential:int;

        /** Gradacja potencjalu w lewo i prawo wzgledem pionowej osi symetrii pola. */
        private var _gradation:int;

        private var _halfWidth:int;
        private var _halfHeight:int;

        public function PFVerticalPotentialField(half_height:int) {
            super();
            _potential = 1;
            _gradation = 1;
            _halfHeight = half_height;
            updateBounds();
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
            return _halfWidth;
        }

        override public function get potentialBoundsHalfHeight():int {
            return _halfHeight;
        }

        override public function getLocalPotential(local_x:int,  local_y:int):int {
            if (Math.abs(local_y) > _halfHeight) return 0;

            if (type < 0) {
                return Math.min(0, type * (_potential - _gradation * Math.abs(local_x)) );
            }
            return Math.max(0, type * (_potential - _gradation * Math.abs(local_x)) );
        }

        private function updateBounds():void {
            _halfWidth = Math.ceil(_potential / _gradation) - 1;
        }
    }
}
