#include "KittyMemory/KittyMemory.hpp"
#include "KittyMemory/MemoryPatch.hpp"

//antiban
%hook UIApplication
-(void)finishedTest:(id)arg1 extraResults:(id)arg2 {
%orig;


//اضف حمايه هنا 
  




}


%end
