public class GazParams{
    
    static float Kb; //in m^2*Da/(s^2*K)

    int nbParticules;
    int nbDimensions;
    1::second => dur unitTime;
    dur step;
    0 => int running;
    Event done;
    
    float positions[][];
    float velocities[][]; //in unitTime^-1
    time creationTime[];
    int isAlives[];
    int nbIsAlive; //Make by section
    2 => float visibleParticulesFactor;
    dur endOfLives[]; //In theory, should be a length travelled before next shock. But would need to compute travelled distance at every step, so we approximate by using speed at creation (just no speed down => more time). Other solution would be to draw a random uniform at each step for each particule (probability of shock at this step).
    int lastSection[];

    float radiuses[]; //for endOfLives, assumed uniform in all dimensions
    float masses[]; //in Daltons

    int survives[]; //whether survives at border or not

    //Option parameters
    0 => int canDie; //option parameter to toggle between 2 modes for borders/endOfLife, not used yet
    1 => int dynamicMode; 
    //Dynamic or fixed(path is known in advance, update only when velocity changes, still have to check every long step for border conditions--or not) implementation?
    1 => int hardBorders; //set updateSlowMultiple at 1 temporarily?

    //Update variables
    1 => float updateSlowMultiple; //Could be randomized around a mean, or used in composition.
    time lastVolumeUpdate;
    0.5::second => dur timeBeforeVolumeUpdate;
    
    float minDists[][];
    float volumePerSection[];
    
    //Global control variables
    2 => int nbSections;
    float borders[][][];
    float temperatures[][];//in K
    float globalVel[][];
    float globalMeanNewPos[][];//not used yet
    float globalDevNewPos[][];
    //float reboundVelBiasPerBorder[nbSections][0,1][dim]; //For closing masses effect
    0.05 => float reboundNewAmount;

    RandomGen random;
    MathU.BallVolumeCoef(nbDimensions-1)*Math.sqrt(2) => float ballVolumeCoefSqrt;

    GazParamsOut @ gazParamsOuts[];

    fun void init(int nbpar, int nbdim, int nbsec, dur stp){
        nbpar => nbParticules;
        nbdim => nbDimensions;
        nbsec => nbSections;
        new float[nbpar][nbdim] @=> positions;
        new float[nbpar][nbdim] @=> velocities;
        new time[nbpar] @=> creationTime;
        new float[nbpar][nbdim] @=> minDists;
        new int[nbpar] @=> isAlives;
        new dur[nbpar] @=> endOfLives;
        new float[nbpar] @=> masses;
        new float[nbpar] @=> radiuses;
        new int[nbpar] @=> lastSection;

        for(0 => int i; i < nbpar; i++){
            -1 => lastSection[i];
        }
            
        new float[nbsec][nbdim][2] @=> borders;
        new float[nbsec] @=> volumePerSection;

        new float[nbsec][nbdim] @=> temperatures;
        new float[nbsec][nbdim] @=> globalVel;
        new float[nbsec][nbdim] @=> globalMeanNewPos;
        new float[nbsec][nbdim] @=> globalDevNewPos;
        for(0 => int sec; sec < nbsec; sec++)
            for(0 => int dim; dim < nbdim; dim++)
                -1 => globalDevNewPos[sec][dim];

        new int[nbpar] @=> survives;

        new GazParamsOut @ [0] @=> gazParamsOuts;

        setStep(stp);
    }
    
    fun void setStep(dur stp){
        stp => step;
    }

    fun void setUnitTime(dur uT){
        uT => unitTime;
    }

    fun void createParticule(int particule){
        createParticule(particule, survives[particule]);
    }
    fun void createParticule(int particule, int toSurvive){
        if(toSurvive && isAlives[particule])
            setPosSurvives(particule);
        else{
            lastSection[particule] => int section;
            if(section == -1)
                Math.random2(0, nbSections - 1) => section; //Uniform initialization of particules across sections (for now)

            1 => masses[particule]; //set new mass only if doesn't survive
            0.1 => radiuses[particule];

            1 => survives[particule]; //Temporary?

            setPosNew(particule, section); 
        }

        setVel(particule, 1, 1);     
        setEndOfLife(particule);

        if(!isAlives[particule]){
            1 => isAlives[particule];
            nbIsAlive++;
        }

        now => creationTime[particule];
    }
    
    fun void setPosNew(int particule, int section){
        //random, or geometry-changing (tore, but is that necessary? parameter directly. Moebius?), or harmonics
        
        for(0=> int dim; dim < nbDimensions; dim++){
            0.5*(borders[section][dim][0] + borders[section][dim][1]) => globalMeanNewPos[section][dim];//not necessary yet

            if(globalDevNewPos[section][dim] == -1)
                Math.random2f(borders[section][dim][0], borders[section][dim][1]) => positions[particule][dim];
            else
                Std.clampf(random.generateGaussian(globalMeanNewPos[section][dim], globalDevNewPos[section][dim]), borders[section][dim][0], borders[section][dim][1]) => positions[particule][dim];
        }

        section => lastSection[particule];
    }
    fun void setPosSurvives(int particule){
        //do nothing
    }
    
    fun float pickOneVel(float temperature, float mass){
        //generalize to exponential normal?(compute energy to verify, but seems easier to compute)
        return random.generateGaussian(0, Math.sqrt(Kb*temperature/mass));
    }

    fun void setVel(int particule, float newAmount, float oldFactor){ //add bias to velNew, can depend on position and aimed point. Think about how to preserve energy, or not
        for(0 => int dim; dim < nbDimensions; dim++){
            0 => float velNew;
            if(newAmount != 0)
                pickOneVel(temperatures[lastSection[particule]][dim], masses[particule]) => velNew;
            
            if(newAmount == 1)
                velNew => velocities[particule][dim];
            else
                (1 - newAmount) * oldFactor * velocities[particule][dim] + newAmount * velNew => velocities[particule][dim];
        }
    }

    fun void setEndOfLife(int particule){
        pickOneLifeTime(radiuses[particule], MathU.EuclideanNorm(velocities[particule])) => endOfLives[particule];
    }

    fun dur pickOneLifeTime(float radius, float speed){ //speed in unitTime^-1
        if(speed == 0)
            return random.generateExponential(1/ballVolumeCoefSqrt*Math.pow(2*radius, nbDimensions))*unitTime;

        return random.generateExponential(1/(ballVolumeCoefSqrt*Math.pow(2*radius, nbDimensions - 1)*speed))*unitTime; //without memory
    }  

    //random update per section?
    //Generalize to Van der Waals gas with factor b*nbIsAlive*visibleparticulesFactor*volume or smth like that.
    fun void updateVolumes(){
        for(0 => int sec; sec < nbSections; sec++){
            1 => float vol;
            for(0 => int dim; dim < nbDimensions; dim++)
                borders[sec][dim][1] - borders[sec][dim][0] *=> vol; //use abs? let's avoid for now
            
            vol => volumePerSection[sec];
        }
        now => lastVolumeUpdate;
    }
    
    //No need every step (updateSlowMultiple or a time like volumes), in that case semi-soft border unless path is known (fixed mode).
    fun int checkBorders(int particule){
        lastSection[particule] => int section;
        //Check if in last section first
        1 => int andDim;
        for(0 => int dim; dim < nbDimensions; dim++)
            if(positions[particule][dim] <= borders[section][dim][0]){
                positions[particule][dim] - borders[section][dim][0] => minDists[particule][dim]; //If too heavy, return first dim touched and minDist
                0 => andDim;
            }
            else if(positions[particule][dim] >= borders[section][dim][1]){
                positions[particule][dim] - borders[section][dim][1] => minDists[particule][dim];
                0 => andDim;
            }
            else
                0 => minDists[particule][dim];

        if(andDim)
            return 0;
        
        //Now check other sections, but minDist will not be updated for performance
        for(0 => int sec; sec < nbSections; sec++){
            if(sec == section)
                continue;

            1 => andDim;
            for(0 => int dim; dim < nbDimensions; dim++)
                if(positions[particule][dim] <= borders[sec][dim][0] || positions[particule][dim] >= borders[sec][dim][1]){
                    0 => andDim;
                    break;
                }
            
            if(andDim){
                sec => lastSection[particule];
                return 0;
            }
        }

        return 1;
    }
    
    fun void rebound(int particule){ //either same particule, or kill particule with another function spawning (independent or linked by nbAlive). Start same particule.
        //touched at (t - minDist/vel, x - minDist)
        //change vel to -vel or something else -> reboundVelBiasPerBorder
        //pos = x - minDist + newVel*minDist/oldVel
        if(survives[particule]){
            for(0 => int dim; dim < nbDimensions; dim++){
                minDists[particule][dim] => float mD;
                if(mD != 0){
                    velocities[particule][dim] => float oldVel;
                    setVel(particule, reboundNewAmount, -1); //maybe change newAmount, but in that case need constraints on the sign? 
                    if(hardBorders)
                        (velocities[particule][dim]/oldVel - 1) * mD +=> positions[particule][dim];
                }
            }
        }
        else{
            kill(particule);
            //could create new or leave another function to create from nbIsAlive
        }
    }
    
    //To simulate shock with another particule
    fun void endOfLife(int particule){
        if(isAlives[particule]){     //in case checkBorders has just killed it
            createParticule(particule, 1);
        }
        //In a different mode, might want to execute kill or not depending on the desired effect
    }

    fun void kill(int particule){ //fade? slow down?
        if(isAlives[particule]){
            0 => isAlives[particule];
            nbIsAlive--;
        }
    }
    
    fun void updatePos(int particule, float stepInUnits){
        for(0 => int dim; dim < nbDimensions; dim++){
            velocities[particule][dim]*stepInUnits + globalVel[lastSection[particule]][dim] +=> positions[particule][dim];
        }
    }
    
    //Constant (random?) (isotropic?) force for Van der Waals gas.
    fun void updateVel(int particule){ //for equa diff style control
    }
    
    fun void updateFast(){
        updateFast(step / unitTime);
    }
    fun void updateFast(float stepInUnits){
        if(now - lastVolumeUpdate >= timeBeforeVolumeUpdate) //randomize timeBeforeVolumeUpdate?
            updateVolumes();

        nbIsAlive*visibleParticulesFactor => float realNbParticules;

        for(0 => int par; par < nbParticules; par++){
            if(isAlives[par]){
                
                if(!hardBorders)
                    if(checkBorders(par))
                        rebound(par);

                if(endOfLives[par] > 0::samp)
                    if(realNbParticules/volumePerSection[lastSection[par]] * (now - creationTime[par]) >= endOfLives[par] && isAlives[par])
                        endOfLife(par);

                updateVel(par);
                updatePos(par, stepInUnits);

                if(hardBorders) //hard borders or soft borders? If hard check now and do what has to be done, if soft check before
                    if(checkBorders(par))
                        rebound(par);   
            }  
        }
    }

    fun void _run(){
        1 => running;
        while(running){
            updateFast();
            for(0 => int dim; dim < gazParamsOuts.size(); dim++)
                gazParamsOuts[dim].update();
            step => now;
        }
        done.broadcast();
    }
}
1.380649/1.6605390666050 * 10000 => GazParams.Kb;
