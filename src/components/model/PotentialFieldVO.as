package components.model {
    import com.ncreated.ds.potentialfields.PFHorizontalPotentialField;
    import com.ncreated.ds.potentialfields.PFPotentialField;
    import com.ncreated.ds.potentialfields.PFRadialPotentialField;
    import com.ncreated.ds.potentialfields.PFRectangularPotentialField;
    import com.ncreated.ds.potentialfields.PFVerticalPotentialField;

    /**
     *
     * @author maciek grzybowski, 13.04.2013 17:43
     *
     */
    public class PotentialFieldVO {

        public static var uid:int = 0;

        private var _field:PFPotentialField;

        [Bindable]
        public var name:String;

        [Bindable]
        public var description:String;

        public function PotentialFieldVO(field:PFPotentialField) {
            _field = field;
            name = "#"+String(uid++);

            if (_field is PFRadialPotentialField) {
                description = "Radial (potential="+PFRadialPotentialField(_field).potential+", gradation="+PFRadialPotentialField(_field).gradation+")";
            }
            else if (_field is PFRectangularPotentialField) {
                description = "Rectangular (potential="+PFRectangularPotentialField(_field).potential+", gradation="+PFRectangularPotentialField(_field).gradation+")";
            }
            else if (_field is PFHorizontalPotentialField) {
                description = "Horizontal (potential="+PFHorizontalPotentialField(_field).potential+", gradation="+PFHorizontalPotentialField(_field).gradation+")";
            }
            else if (_field is PFVerticalPotentialField) {
                description = "Vertical (potential="+PFVerticalPotentialField(_field).potential+", gradation="+PFVerticalPotentialField(_field).gradation+")";
            }
            else {
                description = "unknown";
            }
        }

        public function withName(value:String):PotentialFieldVO {
            name = value;
            return this;
        }

        public function get field():PFPotentialField {
            return _field;
        }
    }
}
