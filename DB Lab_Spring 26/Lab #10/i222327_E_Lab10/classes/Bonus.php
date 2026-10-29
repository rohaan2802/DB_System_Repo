<?php
class Bonus
{
    public $ename;
    public $job;
    public $sal;
    public $comm;

    public function __construct($ename, $job, $sal, $comm)
    {
        $this->ename = $ename;
        $this->job = $job;
        $this->sal = $sal;
        $this->comm = $comm;
    }
}
?>