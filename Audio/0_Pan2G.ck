public class Pan2G extends Pan2{
  float _speed;
  second => dur timeUnit;

  fun float speed(float s){
    s => _speed;
    return s;
  }
  fun float speed(){
    return _speed;
  }

  fun void _movePan(dur totalDur, dur stepDur){
    for(0::samp => dur totalTime; totalTime < totalDur; totalTime + stepDur => totalTime){
      stepDur => now;
      this.pan(_speed*(stepDur/timeUnit) + this.pan());
    }
  }
  fun void _movePan(dur totalDur){
      if(_speed == 0)
        _movePan(totalDur, 100::ms);
      else
        _movePan(totalDur, 0.001/Math.fabs(_speed)*timeUnit);
  }
  fun void _movePan(dur totalDur, float value){
      (value - this.pan())*(timeUnit/totalDur) => _speed;
      _movePan(totalDur);
  }
}
