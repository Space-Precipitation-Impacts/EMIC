function same_event_cleaner, origdata, buffer, value 
;This program was created to take a list of events and remove those
;that have been identified as separate, but since they are in close
;proxyimity (buffer) with other events, should be considered as
;one. This is accomplished by going through the data (which is an
;array with 1's where there is an event onset) and removing
;events with in the pre defined (buffer) time peroid. The value is the
;number of NaN which the "false" events will be set to. 
;To run this program use "result = same_event_cleaner(origdata,buffer,value)"
;Created May 15th 2010 by Alexa Halford
                                ;Just to make sure the original
                                ;data isn't overwritten, we put
                                ;it into a new dummy variable.
  data = origdata
  length = n_elements(data)      ;Here we define the length of the data array 
  bufferindex = where(data eq 1) ;Here we define the first indexing array which houses all the event onesets
  if buffer gt 0 then begin      ;Here we determine if the buffer is greater then zero. If the buffer is zero
                                ;then it is assumed that this
                                ;program isn't really needed.
     i = 0 
     while i lt n_elements(bufferindex) do begin ;this is the loop where we replace all the
                                ; "false" onsets with value
        if bufferindex(i) eq length -1 then return, data ;if the last value in the data 
                                ;array is 1 then exit the program, it's done
        if bufferindex(i) + buffer lt length-1 then data(bufferindex(i) + 1. : Bufferindex(i) + buffer) = value $
        else data(bufferindex(i) + 1. : length -1) = value ;Here we make sure that the buffer wont 
                                ;run over the length of the array and
                                ;then put in the new value for
                                ;everything after the "first" onset
        bufferindex = where(data eq 1) ;here we redefine our index to remove any points that may now be gone.
        i = i+1                 ;we have to count up our index manually since we're using while. While was 
                                ;used so that the bufferindex could
                                ;change, I'm not sure that for
                                ;would do that. 
     endwhile
  endif 
  return, data                  ;now the data is the way it should be and is returned to the program.
  
end
