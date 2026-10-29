<?php
class Department
{
    public $deptno;
    public $dname;
    public $loc;

    public function __construct($deptno, $dname, $loc)
    {
        $this->deptno = $deptno;
        $this->dname = $dname;
        $this->loc = $loc;
    }
}
?>