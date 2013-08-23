package com.ncreated.ds.potentialfields {
    import com.ncreated.lists.BasicLinkedList;
    import com.ncreated.lists.BasicLinkedListNode;

    import flash.display.BitmapData;

    import flash.geom.Rectangle;

    /**
     *
     * @author maciek grzybowski, 08.03.2013 23:38
     *
     */
    public class PFDynamicPotentialsMap {

        private var _tilesWidth:int;
        private var _tilesHeight:int;

        private var _fields:BasicLinkedList;

        public function PFDynamicPotentialsMap(tiles_width:int, tiles_height:int) {
            _fields = new BasicLinkedList();
            _tilesWidth = tiles_width;
            _tilesHeight = tiles_height;
        }

        public function get tilesWidth():int {
            return _tilesWidth;
        }

        public function get tilesHeight():int {
            return _tilesHeight;
        }

        public function addPotentialField(field:PFPotentialField):void {
            _fields.appendNode(field);
        }

        public function removePotentialField(field:PFPotentialField):void {
            _fields.removeNode(field);
        }

        public function removeAllPotentialFields():void {
            _fields.removeAllNodes()
        }

        /**
         * Zwraca wypadkowy potencjal na wskazanej pozycji.
         * @param x
         * @param y
         * @return
         */
        public function getPotential(map_x:int, map_y:int):int {
            var potential:int = 0;
            for (var field:PFPotentialField = PFPotentialField(_fields.head); field; field = PFPotentialField(field.next)) {
                potential += field.getLocalPotential(map_x - field.position.x, map_y - field.position.y);
            }
            return potential;
        }

        /*
             Debug
         */

        public function debugDrawPotentials(bitmap_data:BitmapData):void {
            bitmap_data.lock();

            for (var x:int = 0; x < _tilesWidth; x++) {
                for (var y:int = 0; y < _tilesHeight; y++) {
                    const potential:int = getPotential(x, y);
                    if (potential != 0) {
                        const alpha:int = (Math.abs(potential) / 100) * 100 * 0.5;

                        if (potential * PFPotentialField.PF_TYPE_ATTRACT > 0) {
                            // przyciaga
                            bitmap_data.setPixel32(x, y,  alpha << 24 | 0x00 << 16 | 0xFF << 8 | 0x00);
                        }
                        else {
                            // odpycha
                            bitmap_data.setPixel32(x, y,  alpha << 24 | 0xFF << 16 | 0x00 << 8 | 0x00);
                        }
                    }
                    else {
                        //bitmap_data.setPixel32(x, y, ((x+y)%2==0)?0xFFEEEEEE:0xFFDDDDDD);
                        //bitmap_data.setPixel32(x, y, 0xFFEEEEEE);
                    }
                }
            }

            bitmap_data.unlock();
        }

        public function debugDrawAgents(bitmap_data:BitmapData):void {
            bitmap_data.lock();

            for (var agent:BasicLinkedListNode = _fields.head; agent; agent = agent.next) {
                if (agent is PFAgent) {
                    bitmap_data.setPixel32(PFAgent(agent).position.x, PFAgent(agent).position.y, PFAgent(agent).debugDrawColor);
                }
            }

            bitmap_data.unlock();
        }
    }
}
