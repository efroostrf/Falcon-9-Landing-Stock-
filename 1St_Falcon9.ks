CLEARSCREEN.
//if you create your load on the rocket, you may have problems landing 1 rocket stage. since the code is very crude in numbers, you will test the change more than 1 time. "optional" will tell you where to replace the values. height is calculated from sea level, not surface.

//steps
set landed to false.
set liftoff to false.
set staged to false.
set landing to true.

//liftoff

stage. //engine on

wait 20. //time before liftoff (optional)
set throttle to 0.7.
set liftoff to true.

wait until liftoff.
stage.
lock steering to heading(65, 90).

when maxthrust = 0 then
{
  set ag3 to true.
}

wait until ship:altitude > 1000.
lock throttle to 1.0.
set steering to heading(65,80).

when ship:altitude > 4000 and ship:altitude < 7000 then
{
  set steering to heading(65, 65).
}

when ship:altitude > 7000 and ship:altitude < 10000 then
{
  set steering to heading(65, 50).
}

when ship:altitude > 10000 then
{
  set steering to heading(65, 39).
}

wait until ship:apoapsis > 50000.

set throttle to 0.0.
wait 5.0. //time before MECO
stage. //MECO
set staged to true.

wait until staged. //landing process
set ag1 to true.
LOCK STEERING TO (-1) * SHIP:VELOCITY:SURFACE.
rcs on. //flip maneuver

when ship:altitude > 45000 then //'grind fins' deployed
{
  brakes on.
  set steering to heading(-110, 20). //guidance
}

when ship:altitude < 3775 then //start burning 3'st engine (!optional altitude)
{
  LOCK STEERING TO (-1) * SHIP:VELOCITY:SURFACE.
  set throttle to 1.0.
}

when ship:velocity:surface:mag < 100 then //2 engine off, and 1 maxthrust
{
  set ag2 to true.
  set landing to true.
}
wait until landing.
when ship:velocity:surface:mag > 50 and ship:altitude < 1500 and not landed then
{
  set throttle to (1 * ((9.81 * ship:mass) / ship:maxthrust)).
}

when ship:velocity:surface:mag < 50 and ship:altitude > 800 and not landed then //stability thrust
{
  set throttle to 0.7.
}

when ship:velocity:surface:mag > 6 and ship:altitude < 800 then
{
  set throttle to 1.0.
  gear on.
}

when ship:velocity:surface:mag < 6 and not landed then //pre-landed fire
{
  lock steering to heading(90, 90).
  set throttle to (1 * ((9.81 * ship:mass) / ship:maxthrust)).
  gear on.
  preserve.
}
when ship:status = "landed" then
{
  set landed to true.
  set throttle to 0.0.
}
when ship:status = "splashed" then
{
  set landed to true.
  set throttle to 0.0.
}

wait until landed.