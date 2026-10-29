<?php
class Salgrade
{
    public $grade;
    public $losal;
    public $hisal;

    public function __construct($grade, $losal, $hisal)
    {
        $this->grade = $grade;
        $this->losal = $losal;
        $this->hisal = $hisal;
    }
}
?>