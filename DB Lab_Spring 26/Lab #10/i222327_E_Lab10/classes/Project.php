<?php
class Project
{
    public $projno;
    public $projname;
    public $projtype;
    public $startdate;
    public $enddate;
    public $managerno;
    public $hrsrate;

    public function __construct($projno, $projname, $projtype, $startdate, $enddate, $managerno, $hrsrate)
    {
        $this->projno = $projno;
        $this->projname = $projname;
        $this->projtype = $projtype;
        $this->startdate = $startdate;
        $this->enddate = $enddate;
        $this->managerno = $managerno;
        $this->hrsrate = $hrsrate;
    }
}
?>