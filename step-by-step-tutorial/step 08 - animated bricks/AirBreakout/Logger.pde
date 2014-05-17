static final boolean TRACE_ON = true;
static final boolean SAMPLER_ON = true;
static final int SAMPLER_INTERVAL = 100;

void log(Object aSender, String aMessage) {
  StringBuilder builder = new StringBuilder();
  builder.append(frameCount);
  builder.append(" - INFO - ");
  builder.append(aSender.getClass().getName());
  builder.append(" - ");
  builder.append(aMessage);
  
  println(builder.toString());
}

void trace(Object aSender, String aMessage) {
  if (TRACE_ON) {
    if (! SAMPLER_ON || frameCount % SAMPLER_INTERVAL == 0) { 
      StringBuilder builder = new StringBuilder();
      builder.append(frameCount);
      builder.append(" - TRACE - ");
      builder.append(aSender.getClass().getName());
      builder.append(" - ");
      builder.append(aMessage);
      
      println(builder.toString());
    }
  }
}
