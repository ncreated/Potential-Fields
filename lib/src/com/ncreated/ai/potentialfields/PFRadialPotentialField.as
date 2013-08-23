package com.ncreated.ai.potentialfields {
    import com.ncreated.lists.BasicLinkedListNode;

    import flash.geom.Point;

    /**
     * Pole potencjalu radialnego.
     *
     * @author maciek grzybowski, 07.03.2013 23:56
     *
     */
    public class PFRadialPotentialField extends PFPotentialField {

        /** Wartosc potencjalu w srodku pola. */
        private var _potential:int;

        /** Gradacja potencjalu na kolejnej warstwie pol otaczajacych srodek. */
        private var _gradation:int;

        /**
         * Promien oddzialywania tego potencjalu. Potencjal bedzie wyczowalny na polach polozonych
         * w odleglosci (liczonej metoda Manhatan) mniejszej niz potentialRadius:
         */
        private var _radius:int;

        public function PFRadialPotentialField() {
            super();
            _potential = 1;
            _gradation = 1;
            updateRadius();
        }

        public function set potential(value:int):void {
            _potential = value;
            updateRadius();
        }

        public function set gradation(value:int):void {
            _gradation = value;
            updateRadius();
        }

        public function get potential():int {
            return _potential;
        }

        public function get gradation():int {
            return _gradation;
        }

        override public function get potentialBoundsHalfWidth():int {
            return _radius;
        }

        override public function get potentialBoundsHalfHeight():int {
            return _radius;
        }

        override public function getLocalPotential(local_x:int,  local_y:int):int {
            var distance:int = Math.abs(local_x) + Math.abs(local_y);// manhattan distance
            if (distance > _radius) return 0;

            if (type < 0) return Math.min(0, type * (_potential - _gradation * distance) );
            return Math.max(0, type * (_potential - _gradation * distance) );
        }

        private function updateRadius():void {
            _radius = Math.ceil(_potential / _gradation) - 1;
        }
    }
}
