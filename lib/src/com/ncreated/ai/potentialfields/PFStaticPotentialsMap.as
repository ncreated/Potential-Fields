package com.ncreated.ai.potentialfields {
    import flash.display.BitmapData;
    import flash.geom.Point;

    /**
     *
     * @author maciek grzybowski, 05.03.2013 23:26
     *
     */
    public class PFStaticPotentialsMap {

        private var _cachedPoint:Point;
        private var _tilesWidth:int;
        private var _tilesHeight:int;

        /** _map[x][y] */
        private var _map:Vector.<Vector.<int>>;

        public function PFStaticPotentialsMap(tiles_width:int, tiles_height:int) {
            _cachedPoint = new Point();
            _tilesWidth = tiles_width;
            _tilesHeight = tiles_height;

            _map = new Vector.<Vector.<int>>(tiles_width, true);
            for (var col:int = 0; col < tiles_width; col++) {
                _map[col] = new Vector.<int>(tiles_height, true);
            }
        }

        public function get tilesWidth():int {
            return _tilesWidth;
        }

        public function get tilesHeight():int {
            return _tilesHeight;
        }

        public function addPotentialField(field:PFPotentialField):void {
            addPotentail(field, 1);

            if (_potentialsSnapshot) {
                debugCreatePotentialsSnapshot();
            }
        }

        public function removePotentialField(field:PFPotentialField):void {
            addPotentail(field, -1);
        }

        /**
         * Zwraca wypadkowy potencjal na wskazanej pozycji.
         * @param x
         * @param y
         * @return
         */
        public function getPotential(x:int, y:int):int {
            return _map[x][y];
        }

        private function addPotentail(field:PFPotentialField, multiplier:Number):void {
            for (var x:int = Math.max(0, field.position.x - field.potentialBoundsHalfWidth); x <= Math.min(_tilesWidth-1, field.position.x + field.potentialBoundsHalfWidth); x++) {
                for (var y:int = Math.max(0, field.position.y - field.potentialBoundsHalfHeight); y <= Math.min(_tilesHeight-1, field.position.y + field.potentialBoundsHalfHeight); y++) {
                    _map[x][y] += multiplier * field.getLocalPotential(x - field.position.x, y - field.position.y);
                }
            }
        }

        /*
            Debug
         */

        private var _potentialsSnapshot:BitmapData;

        public function debugCreatePotentialsSnapshot():void {
            _potentialsSnapshot = new BitmapData(_tilesWidth, _tilesHeight, true);
            _potentialsSnapshot.fillRect(_potentialsSnapshot.rect, 0xEEEEEE);

            _potentialsSnapshot.lock();

            for (var x:int = 0; x < _tilesWidth; x++) {
                for (var y:int = 0; y < _tilesHeight; y++) {
                    if (_map[x][y] != 0) {
                        const potential:int = _map[x][y];
                        const alpha:int = (Math.abs(potential) / 110) * 100;

                        if (potential * PFPotentialField.PF_TYPE_ATTRACT > 0) {
                            // przyciaga
                            _potentialsSnapshot.setPixel32(x, y,  alpha << 24 | 0x00 << 16 | 0xFF << 8 | 0x00);
                        }
                        else {
                            // odpycha
                            _potentialsSnapshot.setPixel32(x, y,  alpha << 24 | 0xFF << 16 | 0x00 << 8 | 0x00);
                        }
                    }
                    else {
                        _potentialsSnapshot.setPixel32(x, y, 0xFFEEEEEE);
                    }
                }
            }

            _potentialsSnapshot.unlock();
        }

        public function debugDrawPotentialsSnapshot(bitmap_data:BitmapData):void {
            if (_potentialsSnapshot) {
                bitmap_data.copyPixels(_potentialsSnapshot, _potentialsSnapshot.rect, new Point());
            }
        }
    }
}
