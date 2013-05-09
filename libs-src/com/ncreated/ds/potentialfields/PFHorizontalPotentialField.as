package com.ncreated.ds.potentialfields {

    /**
     * Pole potencjalu z max potencjalem rozlozonym na poziomej osi symetrii pola.
     *
     * @author maciek grzybowski, 23.03.2013 22:16
     *
     */
    public class PFHorizontalPotentialField extends PFPotentialField {

        /** Wartosc potencjalu na poziomej osi symetrii pola. */
        private var _potential:int;

        /** Gradacja potencjalu w gore i w dol wzgledem poziomej osi symetrii pola. */
        private var _gradation:int;

        private var _halfWidth:int;
        private var _halfHeight:int;

        public function PFHorizontalPotentialField(half_width:int) {
            super();
            _potential = 1;
            _gradation = 1;
            _halfWidth = half_width;
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
            if (Math.abs(local_x) > _halfWidth) return 0;

            if (type < 0) {
                return Math.min(0, type * (_potential - _gradation * Math.abs(local_y)) );
            }
            return Math.max(0, type * (_potential - _gradation * Math.abs(local_y)) );
        }

        private function updateBounds():void {
            _halfHeight = Math.ceil(_potential / _gradation) - 1;
        }
    }
}
