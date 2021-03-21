\d .utils
urlencode:{[d] /d-dictionary
  k:key d;v:value d;                                                                //split dictionary into keys & values
  v:enlist each hu each @[v;where 10<>type each v;string];                          //string any values that aren't stringed,escape any chars that need it
  k:enlist each $[all 10=type@'k;k;string k];                                       //if keys are strings, string them
  :"&" sv "=" sv' k,'v;                                                             //return urlencoded form of dictionary
 }
