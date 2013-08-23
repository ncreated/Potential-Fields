package com.ncreated.ds.potentialfields {
    import com.ncreated.lists.BasicLinkedListNode;

    import flash.geom.Point;

    import org.osmf.net.StreamType;

    /**
     *
     * @author maciek grzybowski, 23.03.2013 16:51
     *
     */
    public class PFPotentialField extends BasicLinkedListNode {

        public static const PF_TYPE_ATTRACT:int = -1;
        public static const PF_TYPE_REPEL:int = 1;

        public var position:Point;

        /** Typ potencjalu (PF_TYPE_ATTRACT | PF_TYPE_REPEL). */
        public var type:int;

        public function PFPotentialField() {
            position = new Point();
            type = PF_TYPE_REPEL;
        }

        public function get potentialBoundsHalfWidth():int {
            throw new Error("Method is abstract, override it in inherited class!");
            return 0;
        }

        public function get potentialBoundsHalfHeight():int {
            throw new Error("Method is abstract, override it in inherited class!");
            return 0;
        }

        public function getLocalPotential(local_x:int,  local_y:int):int {
            throw new Error("Method is abstract, override it in inherited class!");
            return 0;
        }
    }
}
