public class Parse{

  fun static string RemoveLastSplits(string str, string del, int nbSplits, int keepLastDel){
    "" => string res;
    0 => int nbDel;
    for(str.length()-1 =>int i; i>=0; i--){
      str.substring(i,1) => string char;

      if(nbDel >= nbSplits){
        char + res => res;
      }

      if(char == del){
        nbDel++;
        if((nbDel == nbSplits) && keepLastDel)
          char + res => res;
      }

    }
    return res;
  }

}
