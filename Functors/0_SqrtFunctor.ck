public class SqrtFunctor extends FloatFunction{

  float factor;
  fun float evaluate(float value)
  {
    return factor*Math.sqrt(value);
  }
}