function event_has_data, event_array, data_array, buffer, value,  sbuffer, ebuffer
; This program was created to determine if there is data durring, or
; surrounding the event and returns only those that have such data. 
                                ;Just to make sure the original
                                ;data isn't overwritten, we put
                                ;it into a new dummy variable.
  events = event_array
  length = n_elements(event_array)      ;Here we define the length of the data array 
  eventindex = where(events eq 1)       ;Here we define the first indexing array which houses all the event onesets
  eventepoch = make_array(n_elements(events), value = !values.F_NAN)
  new_events = make_array(n_elements(events), value = !values.F_NAN)
  for j = 0l, n_elements(eventindex)-1 do begin 
     eventepoch(eventindex(j) - sbuffer: eventindex(j) + ebuffer) = 1
     data = data_array(eventindex(j) - sbuffer: eventindex(j) + ebuffer) * $
            eventepoch(eventindex(j) - sbuffer: eventindex(j) + ebuffer)
     gooddata = where(finite(data))
     percentgood = n_elements(gooddata)/n_elements(data)
     if percentgood gt .5 then new_events(eventindex(j)) = 1.
  endfor
  eventindex = where(new_events eq 1) ;Here we define indexing array that has all the events that have 
                                ;at least 90% of the density data over
                                ;the epoch interval. 
  
  if buffer gt 0 then begin     ;Here we determine if the buffer is greater then zero. If the buffer is zero
                                ;then it is assumed that this
                                ;program isn't really needed.
     i = 0 
     while i lt n_elements(eventindex) do begin ;this is the loop where we replace all the
                                ; "false" onsets with value
        if eventindex(i) eq length -1 then return, new_events ;if the last value in the data 
                                ;array is 1 then exit the program, it's done
        if eventindex(i) + buffer lt length-1 then new_events(eventindex(i) + 1. : eventindex(i) + buffer) = value $
        else new_events(eventindex(i) + 1. : length -1) = value ;Here we make sure that the buffer wont 
                                ;run over the length of the array and
                                ;then put in the new value for
                                ;everything after the "first" onset
        eventindex = where(new_events eq 1) ;here we redefine our index to remove any points that may now be gone.
        i = i+1                 ;we have to count up our index manually since we're using while. While was 
                                ;used so that the bufferindex could
                                ;change, I'm not sure that for
                                ;would do that. 
     endwhile
  endif 
  return, new_events                  ;now the useful events are there, the way it should be and is returned to the program.
  
end
