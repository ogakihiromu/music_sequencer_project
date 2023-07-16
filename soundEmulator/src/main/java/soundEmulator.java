import java.io.File;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import javax.sound.sampled.*;

class soundEmulator implements Runnable{
  public String filename;
  public File myCoeFile;
  public boolean errorFlag;
  public int myNum;

  public Integer note;
  public Integer length;
  public Integer volume;

  public BufferedReader br;
  
  private static final Integer SAMPLE_RATE = 44100;
  private static final Integer SAMPLE_SIZE_IN_BITS = 8;
  private static final Integer CHANNELS = 1;
  public AudioFormat af;
  public DataLine.Info info;
  public SourceDataLine line;
  public String soundData;

  public void run(){
    // load a file and check header
    try{
      myCoeFile = new File(filename);
      br = new BufferedReader(new FileReader(myCoeFile));
    }catch(FileNotFoundException e){
      System.out.println("There is no file named" + filename + ".");
      errorFlag = true;
    }

    String str;
    
    // read line0
    try{
      if((str = br.readLine()) == null){
        System.out.println("ERROR: finish readline in " + filename + ".");
        errorFlag = true;
      }else if(!str.equals("memory_initialization_radix=16;")){
        System.out.println("ERROR: line 0 in " + filename + " is not coe header.");
        errorFlag = true;
      }
    }catch(IOException e){
      System.out.println(e);
      errorFlag = true;
    }
    
    // read line1
    try{
      if((str = br.readLine()) == null){
        System.out.println("ERROR: finish readline in " + filename + ".");
        errorFlag = true;
      }else if(!str.equals("memory_initialization_vector=")){
        System.out.println("ERROR: line 1 in " + filename + " is not coe header.");
        errorFlag = true;
      }
    }catch(IOException e){
      System.out.println(e);
      errorFlag = true;
    }
 
    // initialization
    af = new AudioFormat(SAMPLE_RATE, SAMPLE_SIZE_IN_BITS, CHANNELS, true, true);
    info = new DataLine.Info(SourceDataLine.class, af);
    try{
      line = (SourceDataLine)AudioSystem.getLine(info);
      line.open();
      line.start();
    }catch(LineUnavailableException e){
      System.out.println(e);
    }

    do{
      try{
        if((str = br.readLine()) == null){
          System.out.println("ERROR: There is no data.");
          errorFlag = true;
          break;
        }
      }catch(IOException e){
        System.out.println(e);
        break;
      }

      switch(str.charAt(0)){
        case '0':
          note = 33;
          break;
        case '1':
          note = 35;
          break;
        case '2':
          note = 37;
          break;
        case '3':
          note = 39;
          break;
        case '4':
          note = 41;
          break;
        case '5':
          note = 44;
          break;
        case '6':
          note = 46;
          break;
        case '7':
          note = 49;
          break;
        case '8':
          note = 52;
          break;
        case '9':
          note = 55;
          break;
        case 'A':
          note = 58;
          break;
        case 'B':
          note = 62;
          break;
        case 'C':
          note = 0;
          break;
        default:
          note = -1;
          break;
      }

      if(note != -1){
        note = note << ((str.charAt(1) - '1'));
        length = ((str.charAt(2) <= '9' && str.charAt(2) >= '0') ? (str.charAt(2) - '0') : (str.charAt(2) - 'A' + 10)) * 16 + ((str.charAt(3) <= '9' && str.charAt(3) >= '0') ? (str.charAt(3) - '0') : (str.charAt(3) - 'A' + 10));
        Double wavelength = (double) SAMPLE_RATE / note;
        byte[] b = new byte[SAMPLE_RATE * SAMPLE_SIZE_IN_BITS / 8 * CHANNELS * length / 100];
	if(myNum != 2){
          for(int i = 0; i < b.length; i++){
            double phase = i / wavelength;
            phase -= Math.floor(phase);
            b[i] = (byte)(phase * 255 - 128);
          }
	}else{
          for(int i = 0; i < b.length; i++){
            double phase = i / wavelength;
            phase -= Math.floor(phase);
            b[i] = (byte)(Math.abs(phase - 0.5) * 510 - 128);
          }
	}
        line.write(b, 0, b.length);
      }
    }while(note != -1);

    line.drain();
    line.close();
    try{
      br.close();
    }catch(IOException e){
      System.out.println(e);
    }
    errorFlag = true;
  }

  public static void main(String[] args){
    // make 3 threads (state = 0)
    if(args.length != 3){
      System.out.println("Usage: java soundEmulator filename1 filename2 filename3");
      System.exit(1);
    }

    soundEmulator ch0 = new soundEmulator();
    ch0.filename = args[0];
    ch0.errorFlag = false;
    ch0.myNum = 0;
    Thread th0 = new Thread(ch0);

    soundEmulator ch1 = new soundEmulator();
    ch1.filename = args[1];
    ch1.errorFlag = false;
    ch1.myNum = 1;
    Thread th1 = new Thread(ch1);

    soundEmulator ch2 = new soundEmulator();
    ch2.filename = args[2];
    ch2.errorFlag = false;
    ch2.myNum = 2;
    Thread th2 = new Thread(ch2);

    th0.start();
    th1.start();
    th2.start();
  }
}
