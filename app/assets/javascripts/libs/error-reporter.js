function error(msg,url,line){
   var REPORT_URL = "/errors?e=";
   var m =[msg, url, line, navigator.userAgent, +new Date];
   var url = REPORT_URL + m.join('||');
   var img = new Image;
   img.onload = img.onerror = function(){
      img = null;
   };
   img.src = url;
}


window.onerror = function(msg,url,line) {
  error(msg,url,line);
}