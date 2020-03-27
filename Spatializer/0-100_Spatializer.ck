public class Spatializer{
	int inSize;
	int outSize;
	
	Gain in[];
	GainGesture vca[][];
	Gain out[];
	
	fun void init(int inSiz, int outSiz){
		inSiz => inSize;
		outSiz => outSize;
		Gain tin[inSize] @=> in;
		GainGesture tvca[inSize][outSize] @=> vca;
		Gain tout[outSize] @=> out;
		
		for(0 => int i; i < inSize; i++)
			for(0 => int j; j < outSize; j++){
				vca[i][j].multMode();
				in[i] => vca[i][j] => out[j];
			}		
	}
	
	fun void set2plex(){
		if(outSize != 2)
			<<<"outSize not 2:", outSize>>>;
		
		for(0 => int i; i < inSize; i++){
			vca[i][1].link2plex(vca[i][0]);
			vca[i][0].setVal(0.5);
		}
	}
}