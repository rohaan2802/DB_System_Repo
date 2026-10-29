<?php
class ProjAssign
{
    public $projno;
    public $empno;
    public $projperiod;
    public $noofhrs;

    public function __construct($projno, $empno, $projperiod, $noofhrs)
    {
        $this->projno = $projno;
        $this->empno = $empno;
        $this->projperiod = $projperiod;
        $this->noofhrs = $noofhrs;
    }
}
?>