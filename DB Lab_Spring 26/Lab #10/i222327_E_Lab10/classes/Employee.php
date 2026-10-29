<?php
class Employee
{
    public $empno;
    public $ename;
    public $job;
    public $mgr;
    public $hiredate;
    public $sal;
    public $comm;
    public $deptno;

    public function __construct($empno, $ename, $job, $mgr, $hiredate, $sal, $comm, $deptno)
    {
        $this->empno = $empno;
        $this->ename = $ename;
        $this->job = $job;
        $this->mgr = $mgr;
        $this->hiredate = $hiredate;
        $this->sal = $sal;
        $this->comm = $comm;
        $this->deptno = $deptno;
    }
}
?>